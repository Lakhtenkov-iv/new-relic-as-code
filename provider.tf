# Configure the New Relic provider
provider "newrelic" {
  #account_id = # export NEW_RELIC_ACCOUNT_ID="<Enter your account ID>"
  #api_key    = "" # export NEW_RELIC_API_KEY="<your New Relic User API key>"
  region = "EU" # Valid regions are US and EU
}