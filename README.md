# new-relic-as-code


## How to create dashboard:
1. Create dashboard in the UI
2. Create template for it in the code 
```
resource "newrelic_one_dashboard" "dashboard" {
  name = "DB"
  page {
    name = "Page"
  }
}
```
2. import dashboard to the state `terraform import newrelic_one_dashboard.dashboard <guid>`
3. Get the code for state `terraform show`
4. Replace code in the resource
4. Sanitize code until terraform plan will show no diff or errors.