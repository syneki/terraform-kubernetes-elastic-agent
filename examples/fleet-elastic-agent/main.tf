module "fleet_elastic_agent" {
  source = "../.."

  name      = "fleet-server"
  namespace = "monitoring"

  elastic_version = "8.2.3"

  fleet_enroll           = true
  fleet_url              = "https://fleet.syneki.com"
  fleet_enrollment_token = "myenrollmenttoken"
}
