locals {
  slis = [
    "productpage-v1",
    "details-v1",
    "reviews-v1",
    "reviews-v2",
    "reviews-v3",
  ]
}

data "newrelic_entity" "deployments" {
  for_each = toset(local.slis)
  name     = each.key
  domain   = "INFRA"
  type     = "KUBERNETES_DEPLOYMENT"
}

resource "newrelic_service_level" "availability" {
  for_each    = toset(local.slis)
  guid        = data.newrelic_entity.deployments[each.key].guid
  name        = "${each.key}-availability"
  description = "Availability of ${each.key} serivce"

  events {
    account_id = var.account_id
    valid_events {
      from = "Metric"
      select {
        attribute = "istio_requests_total"
        function  = "SUM"
      }
      where = <<-EOT
        destination_workload ='${each.key}'
        AND weekdayOf(timestamp, numeric) IN (1, 2, 3, 4, 5)
        AND hourOf(timestamp, numeric) >= 5
        AND hourOf(timestamp, numeric) <= 17
      EOT
    }
    bad_events {
      from = "Metric"
      select {
        attribute = "istio_requests_total"
        function  = "SUM"
      }
      where = <<-EOT
        destination_workload ='${each.key}'
        AND weekdayOf(timestamp, numeric) IN (1, 2, 3, 4, 5)
        AND hourOf(timestamp, numeric) >= 5
        AND hourOf(timestamp, numeric) <= 17
        AND response_code LIKE '5%'
      EOT
    }
  }

  objective {
    target = 99.00
    time_window {
      rolling {
        count = 28
        unit  = "DAY"
      }
    }
  }
}
