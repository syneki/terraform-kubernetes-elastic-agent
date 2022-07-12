module "fleet_server" {
  source = "../.."

  name      = "fleet-server"
  namespace = "monitoring"

  elastic_version = "8.2.3"

  fleet_server_enable             = true
  fleet_server_elasticsearch_host = "https://elasticsearch:9200"
  fleet_server_service_token      = "my-service-token"
  fleet_server_policy_id          = "fleet-server-policy"
  fleet_server_elasticsearch_ca   = "elasticsearch-coordinating-crt"
}
