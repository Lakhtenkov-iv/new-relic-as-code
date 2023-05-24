resource "newrelic_one_dashboard" "istio" {
  name        = "Istio Service"
  permissions = "public_read_write"

  page {
    name = "Overview"

    widget_area {
      column                  = 1
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 11
      title                   = "Inbound Requests by Source and Response Code"
      width                   = 4
      y_axis_left_max         = 0
      y_axis_left_min         = 0

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT rate(sum(istio_requests_total), 1 SECOND) AS 'Req/Sec' where reporter = 'destination' FACET source_workload, response_code TIMESERIES "
      }
    }
    widget_area {
      column                  = 5
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 11
      title                   = "Inbound Errors by Service"
      width                   = 4
      y_axis_left_max         = 0
      y_axis_left_min         = 0

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT (filter(rate(sum(istio_requests_total), 1 minute), WHERE response_code LIKE '5%')) AS 'Errors' WHERE reporter = 'destination' FACET source_workload TIMESERIES "
      }
    }
    widget_area {
      column                  = 1
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 18
      title                   = "Outbound Requests by Source and Response Code"
      width                   = 4
      y_axis_left_max         = 0
      y_axis_left_min         = 0

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT rate(sum(istio_requests_total), 1 SECOND) AS 'Req/Sec' where reporter = 'source' FACET destination_canonical_service, response_code TIMESERIES "
      }
    }
    widget_area {
      column                  = 5
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 18
      title                   = "Outbound Errors by Service"
      width                   = 4
      y_axis_left_max         = 0
      y_axis_left_min         = 0

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT (filter(rate(sum(istio_requests_total), 1 minute), WHERE response_code LIKE '5%')) AS 'Errors' WHERE reporter = 'source' FACET destination_canonical_service TIMESERIES"
      }
    }

    widget_billboard {
      column                  = 5
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = false
      row                     = 1
      title                   = "Throughput per Second"
      width                   = 2
      y_axis_left_max         = 0
      y_axis_left_min         = 0

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT rate(sum(istio_requests_total), 1 SECOND) AS 'Req/Sec' FACET cases(WHERE reporter = 'destination' as 'Inbound', WHERE reporter = 'source' as 'Outbound')"
      }
    }
    widget_billboard {
      column                  = 11
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = false
      row                     = 1
      title                   = "Latency"
      width                   = 2
      y_axis_left_max         = 0
      y_axis_left_min         = 0

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT (rate(sum(istio_request_duration_milliseconds_sum), 1 minute) / rate(sum(istio_request_duration_milliseconds_count), 1 minute)) AS 'Milliseconds' WHERE reporter = 'destination'"
      }
    }

    widget_heatmap {
      column                   = 9
      facet_show_other_series  = false
      filter_current_dashboard = false
      height                   = 3
      ignore_time_range        = false
      legend_enabled           = false
      linked_entity_guids      = []
      row                      = 11
      title                    = "Inbound Request Duration by Source"
      width                    = 4
      y_axis_left_max          = 0
      y_axis_left_min          = 0

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT histogram(istio_request_duration_milliseconds_bucket, 1000) WHERE reporter = 'destination' FACET source_canonical_service"
      }
    }
    widget_heatmap {
      column                   = 9
      facet_show_other_series  = false
      filter_current_dashboard = false
      height                   = 3
      ignore_time_range        = false
      legend_enabled           = false
      linked_entity_guids      = []
      row                      = 18
      title                    = "Outbound Request Duration by Source"
      width                    = 4
      y_axis_left_max          = 0
      y_axis_left_min          = 0

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT histogram(istio_request_duration_milliseconds_bucket, 1000) WHERE reporter = 'source' FACET destination_canonical_service"
      }
    }

    widget_histogram {
      column                  = 10
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 8
      title                   = "Server Request Duration Ms (Histogram)"
      width                   = 3
      y_axis_left_max         = 0
      y_axis_left_min         = 0

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT histogram(istio_request_duration_milliseconds_bucket, 1000) AS 'Requests' WHERE reporter = 'destination'"
      }
    }
    widget_histogram {
      column                  = 10
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 15
      title                   = "Client Request Duration Ms (Histogram)"
      width                   = 3
      y_axis_left_max         = 0
      y_axis_left_min         = 0

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT histogram(istio_request_duration_milliseconds_bucket, 1000) AS 'Requests' WHERE reporter = 'source'"
      }
    }

    widget_line {
      column                  = 1
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 4
      title                   = "Global Request Volume"
      width                   = 12
      y_axis_left_max         = 0
      y_axis_left_min         = 0
      y_axis_left_zero        = true

      nrql_query {
        account_id = var.account_id
        query      = "SELECT sum(istio_requests_total) FROM Metric Facet reporter   LIMIT MAX TIMESERIES "
      }
    }
    widget_line {
      column                  = 1
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 8
      title                   = "Server Throughput"
      width                   = 3
      y_axis_left_max         = 0
      y_axis_left_min         = 0
      y_axis_left_zero        = true

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT rate(sum(istio_requests_total), 1 SECOND) AS 'Req/Sec' where reporter = 'destination' TIMESERIES"
      }
    }
    widget_line {
      column                  = 4
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 8
      title                   = "Server Error Rate (5xx responses)"
      width                   = 3
      y_axis_left_max         = 0
      y_axis_left_min         = 0
      y_axis_left_zero        = true

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT (filter(sum(istio_requests_total), WHERE response_code LIKE '5%') * 100 ) / sum(istio_requests_total) AS 'Error Rate (%)' WHERE reporter = 'destination' FACET source_workload LIMIT 1000 TIMESERIES "
      }
    }
    widget_line {
      column                  = 7
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 8
      title                   = "Server Request Duration (Average)"
      width                   = 3
      y_axis_left_max         = 0
      y_axis_left_min         = 0
      y_axis_left_zero        = true

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT sum(istio_request_duration_milliseconds_sum) / sum(istio_request_duration_milliseconds_count) WHERE reporter = 'destination' TIMESERIES "
      }
    }
    widget_line {
      column                  = 1
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 15
      title                   = "Client Throughput"
      width                   = 3
      y_axis_left_max         = 0
      y_axis_left_min         = 0
      y_axis_left_zero        = true

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT rate(sum(istio_requests_total), 1 SECOND) AS 'Req/Sec' where reporter = 'source' TIMESERIES"
      }
    }
    widget_line {
      column                  = 4
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 15
      title                   = "Client Error Rate (5xx responses)"
      width                   = 3
      y_axis_left_max         = 0
      y_axis_left_min         = 0
      y_axis_left_zero        = true

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT (filter(sum(istio_requests_total), WHERE response_code LIKE '5%') * 100) / sum(istio_requests_total) AS 'Error Rate (%)' WHERE reporter = 'source' Facet destination_workload_namespace, destination_workload LIMIT 10 TIMESERIES "
      }
    }
    widget_line {
      column                  = 7
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 15
      title                   = "Client Request Duration (Average)"
      width                   = 3
      y_axis_left_max         = 0
      y_axis_left_min         = 0
      y_axis_left_zero        = true

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT sum(istio_request_duration_milliseconds_sum) / sum(istio_request_duration_milliseconds_count) WHERE reporter = 'source' TIMESERIES "
      }
    }

    widget_markdown {
      title                   = ""
      column                  = 1
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = false
      row                     = 1
      text                    = <<-EOT
                
                ![Add Images](https://miro.medium.com/max/766/0*XRtdBll-FcyV_i-f.jpeg)
                
                
                To scope page to single cluster, filter by `clusterName=<cluster_name>`.
                
                Dashboard gives an overview of the services integrated with Istio.
            EOT
      width                   = 4
      y_axis_left_max         = 0
      y_axis_left_min         = 0
    }
    widget_markdown {
      title                   = ""
      column                  = 1
      facet_show_other_series = false
      height                  = 1
      ignore_time_range       = false
      legend_enabled          = false
      row                     = 7
      text                    = "# Server (inbound) Metrics"
      width                   = 12
      y_axis_left_max         = 0
      y_axis_left_min         = 0
    }
    widget_markdown {
      title                   = ""
      column                  = 1
      facet_show_other_series = false
      height                  = 1
      ignore_time_range       = false
      legend_enabled          = false
      row                     = 14
      text                    = "# Client (outbound) Metrics"
      width                   = 12
      y_axis_left_max         = 0
      y_axis_left_min         = 0
    }

    widget_pie {
      column                   = 7
      facet_show_other_series  = true
      filter_current_dashboard = false
      height                   = 3
      ignore_time_range        = false
      legend_enabled           = false
      linked_entity_guids      = []
      row                      = 1
      title                    = " Response Codes"
      width                    = 4
      y_axis_left_max          = 0
      y_axis_left_min          = 0

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT sum(istio_requests_total) WHERE reporter = 'destination' FACET response_code"
      }
    }
  }
  page {
    name = "Ingress Gateways"

    widget_area {
      column                  = 5
      facet_show_other_series = true
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 4
      title                   = "Errors in logs"
      width                   = 8
      y_axis_left_max         = 0
      y_axis_left_min         = 0

      nrql_query {
        account_id = var.account_id
        query      = "FROM Log SELECT count(*) WHERE labels.app LIKE 'istio-ingressgateway%' AND message LIKE '%error%' FACET cluster_name,namespace_name TIMESERIES AUTO LIMIT MAX "
      }
    }

    widget_line {
      column                  = 5
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 1
      title                   = "Total Requests - Ingress Gateway"
      width                   = 8
      y_axis_left_max         = 0
      y_axis_left_min         = 0
      y_axis_left_zero        = false

      nrql_query {
        account_id = var.account_id
        query      = "SELECT sum(istio_requests_total) FROM Metric WHERE label.app='istio-ingressgateway'  Facet clusterName LIMIT MAX  TIMESERIES "
      }
    }
    widget_line {
      column                  = 1
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 7
      title                   = "Requests total by Cluster, Namespace and Code"
      width                   = 12
      y_axis_left_max         = 0
      y_axis_left_min         = 0
      y_axis_left_zero        = false

      nrql_query {
        account_id = var.account_id
        query      = "SELECT sum(istio_requests_total) FROM Metric WHERE label.app = 'istio-ingressgateway' AND response_code RLIKE '[0-9][0-9][0-9]'  FACET clusterName, namespaceName,response_code TIMESERIES AUTO"
      }
    }
    widget_line {
      column                  = 1
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 10
      title                   = "Average requests-duration-milliseconds-sum by Cluster, Namespace and Code"
      width                   = 12
      y_axis_left_max         = 0
      y_axis_left_min         = 0
      y_axis_left_zero        = false

      nrql_query {
        account_id = var.account_id
        query      = "SELECT average(istio_request_duration_milliseconds_sum) FROM Metric WHERE label.app = 'istio-ingressgateway' AND response_code RLIKE '[0-9][0-9][0-9]' AND response_code LIKE '2%' FACET clusterName,namespaceName,response_code TIMESERIES 5 minutes SLIDE BY AUTO"
      }
      nrql_query {
        account_id = var.account_id
        query      = "SELECT average(istio_request_duration_milliseconds_sum) * -1 FROM Metric WHERE label.app = 'istio-ingressgateway' AND response_code RLIKE '[0-9][0-9][0-9]' AND response_code NOT LIKE '2%' FACET clusterName,namespaceName,response_code TIMESERIES 5 minutes SLIDE BY AUTO"
      }
    }
    widget_line {
      column                  = 1
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 13
      title                   = "Response code 2xx (envoy)"
      width                   = 6
      y_axis_left_max         = 0
      y_axis_left_min         = 0
      y_axis_left_zero        = true

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT sum(envoy_cluster_upstream_rq) WHERE response_code_class = '2xx' AND label.app='istio-ingressgateway' FACET clusterName  TIMESERIES AUTO"
      }
    }
    widget_line {
      column                  = 7
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 13
      title                   = "Response code 5xx (envoy)"
      width                   = 6
      y_axis_left_max         = 0
      y_axis_left_min         = 0
      y_axis_left_zero        = true

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT sum(envoy_cluster_upstream_rq) WHERE response_code_class = '5xx' AND label.app='istio-ingressgateway' FACET clusterName TIMESERIES AUTO"
      }
    }
    widget_line {
      column                  = 1
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 16
      title                   = "Average request-bytes-sum by Source Cluster, Namespace and Code (istio)"
      width                   = 6
      y_axis_left_max         = 0
      y_axis_left_min         = 0
      y_axis_left_zero        = false

      nrql_query {
        account_id = var.account_id
        query      = "SELECT average(istio_request_bytes_sum) FROM Metric WHERE label.app = 'istio-ingressgateway' AND response_code RLIKE '[0-9][0-9][0-9]' AND response_code LIKE '2%' FACET clusterName,source_workload_namespace,response_code TIMESERIES 5 minutes SLIDE BY AUTO"
      }
      nrql_query {
        account_id = var.account_id
        query      = "SELECT average(istio_request_bytes_sum) * -1 FROM Metric WHERE label.app = 'istio-ingressgateway' AND response_code RLIKE '[0-9][0-9][0-9]' AND response_code NOT LIKE '2%' FACET clusterName, source_workload_namespace,response_code TIMESERIES 5 minutes SLIDE BY AUTO"
      }
    }
    widget_line {
      column                  = 7
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 16
      title                   = "Average response-bytes-sum by Source Cluster, Namespace and Code"
      width                   = 6
      y_axis_left_max         = 0
      y_axis_left_min         = 0
      y_axis_left_zero        = false

      nrql_query {
        account_id = var.account_id
        query      = "SELECT average(istio_response_bytes_sum) FROM Metric WHERE label.app = 'istio-ingressgateway' AND response_code RLIKE '[0-9][0-9][0-9]' AND response_code LIKE '2%' FACET clusterName,namespaceName,response_code TIMESERIES 5 minutes SLIDE BY AUTO"
      }
      nrql_query {
        account_id = var.account_id
        query      = "SELECT average(istio_response_bytes_sum) * -1 FROM Metric WHERE app = 'istio-ingressgateway' AND response_code RLIKE '[0-9][0-9][0-9]' AND response_code NOT LIKE '2%' FACET clusterName, namespaceName,response_code TIMESERIES 5 minutes SLIDE BY AUTO"
      }
    }
    widget_line {
      column                  = 1
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 19
      title                   = "Average tcp-sent-bytes-total by Source Cluster, Namespace and Code (Top 10)"
      width                   = 6
      y_axis_left_max         = 0
      y_axis_left_min         = 0
      y_axis_left_zero        = false

      nrql_query {
        account_id = var.account_id
        query      = "SELECT average(istio_tcp_sent_bytes_total) FROM Metric FACET clusterName, namespaceName, source_workload TIMESERIES LIMIT 10"
      }
    }
    widget_line {
      column                  = 7
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 19
      title                   = "Average tcp-received-bytes-total by Source Cluster, Namespace and Code (Top 10)"
      width                   = 6
      y_axis_left_max         = 0
      y_axis_left_min         = 0
      y_axis_left_zero        = false

      nrql_query {
        account_id = var.account_id
        query      = "SELECT average(istio_tcp_received_bytes_total) FROM Metric FACET clusterName, namespaceName, source_workload TIMESERIES LIMIT 10"
      }
    }
    widget_line {
      column                  = 1
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 22
      title                   = "RX Bytes (Top 10) (envoy)"
      width                   = 6
      y_axis_left_max         = 0
      y_axis_left_min         = 0
      y_axis_left_zero        = true

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT average(envoy_cluster_upstream_cx_rx_bytes_total) WHERE label.app='istio-ingressgateway' FACET clusterName, namespaceName TIMESERIES AUTO"
      }
    }
    widget_line {
      column                  = 7
      facet_show_other_series = false
      height                  = 3
      ignore_time_range       = false
      legend_enabled          = true
      row                     = 22
      title                   = "TX Bytes (Top 10)"
      width                   = 6
      y_axis_left_max         = 0
      y_axis_left_min         = 0
      y_axis_left_zero        = true

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT average(envoy_cluster_upstream_cx_tx_bytes_total) WHERE label.app='istio-ingressgateway' FACET clusterName, namespaceName  TIMESERIES AUTO "
      }
    }

    widget_pie {
      column                   = 1
      facet_show_other_series  = false
      filter_current_dashboard = false
      height                   = 3
      ignore_time_range        = false
      legend_enabled           = false
      linked_entity_guids      = []
      row                      = 1
      title                    = "Requests % by cluster"
      width                    = 4
      y_axis_left_max          = 0
      y_axis_left_min          = 0

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT rate(sum(istio_requests_total), 1 SECONDS) WHERE label.app='istio-ingressgateway' FACET clusterName LIMIT MAX "
      }
    }
    widget_pie {
      column                   = 1
      facet_show_other_series  = false
      filter_current_dashboard = false
      height                   = 3
      ignore_time_range        = false
      legend_enabled           = false
      linked_entity_guids      = []
      row                      = 4
      title                    = "Requests % by namespace"
      width                    = 4
      y_axis_left_max          = 0
      y_axis_left_min          = 0

      nrql_query {
        account_id = var.account_id
        query      = "FROM Metric SELECT rate(sum(istio_requests_total), 1 SECONDS) WHERE label.app='istio-ingressgateway' FACET namespaceName LIMIT MAX "
      }
    }
  }
}