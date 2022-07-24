variable "name" {
  type        = string
  description = "Name used to create resources"
}

variable "namespace" {
  type        = string
  default     = "default"
  description = "Namespace where resources will be created"
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Labels append to resources created"
}

variable "elastic_version" {
  type        = string
  description = "The elastic agent version"
}

variable "deployment" {
  type        = bool
  default     = false
  description = "Creates a Deployment or a DaemonSet"
}

# ELASTICSEARCH CONFIGURATION

variable "elasticsearch_host" {
  type        = string
  default     = "http://elasticsearch:9200"
  description = "The Elasticsearch host to communicate with"
}

variable "elasticsearch_username" {
  type        = string
  default     = "elastic"
  description = " basic authentication username used to connect to Kibana and retrieve a service_token for Fleet."
}

variable "elasticsearch_password" {
  type        = string
  default     = "changeme"
  sensitive   = true
  description = "The basic authentication password used to connect to Kibana and retrieve a service_token for Fleet."
}

variable "elasticsearch_ca" {
  type        = string
  default     = null
  nullable    = true
  description = "The path to a certificate authority."
}

# KIBANA CONFIGURATION

variable "kibana_host" {
  type        = string
  default     = "http://kibana:5601"
  description = "The Kibana host."
}

variable "kibana_username" {
  type        = string
  default     = "elastic"
  description = "The basic authentication username used to connect to Kibana to retrieve a service_token."
}

variable "kibana_password" {
  type        = string
  default     = "changeme"
  sensitive   = true
  description = "The basic authentication password used to connect to Kibana to retrieve a service_token."
}

variable "kibana_ca" {
  type        = string
  nullable    = true
  default     = null
  description = "The path to a certificate authority."
}

# KIBANA FLEET CONFIGURATION

variable "kibana_fleet_setup" {
  type        = bool
  default     = false
  description = "Enabling Fleet is required before Fleet Server will start. When this action is not performed, a user must manually log in to Kibana and visit the Fleet page to enable setup."
}

variable "kibana_fleet_host" {
  type        = string
  nullable    = true
  default     = null
  description = "The Kibana host to enable Fleet on. Overrides FLEET_HOST when set."
}

variable "kibana_fleet_username" {
  type        = string
  nullable    = true
  default     = null
  description = "The basic authentication username used to connect to Kibana and retrieve a service_token to enable Fleet. Overrides ELASTICSEARCH_USERNAME when set."
}

variable "kibana_fleet_password" {
  type      = string
  nullable  = true
  default   = null
  sensitive = true

  description = "The basic authentication password used to connect to Kibana and retrieve a service_token to enable Fleet. Overrides ELASTICSEARCH_PASSWORD when set."
}

variable "kibana_fleet_ca" {
  type        = string
  default     = null
  nullable    = true
  description = "The path to a certificate authority. Overrides KIBANA_CA when set."
}

# BOOTSRAP FLEET SERVER CONFIGURATION

variable "fleet_server_enable" {
  type        = bool
  default     = false
  description = "Set to 1 to bootstrap Fleet Server on this Elastic Agent. When set to 1, this automatically forces Fleet enrollment as well."
}

variable "fleet_server_elasticsearch_host" {
  type        = string
  nullable    = true
  default     = null
  description = "The Elasticsearch host for Fleet Server to communicate with. Overrides ELASTICSEARCH_HOST when set."
}

variable "fleet_server_elasticsearch_ca" {
  type        = string
  nullable    = true
  default     = null
  description = "The path to a certificate authority. Overrides ELASTICSEARCH_CA when set."
}

variable "fleet_server_service_token" {
  type        = string
  nullable    = true
  default     = null
  description = "Service token to use for communication with Elasticsearch."
}

variable "fleet_server_policy_name" {
  type        = string
  nullable    = true
  default     = null
  description = "The name of the policy for Fleet Server to use on itself. Overrides FLEET_TOKEN_POLICY_NAME when set."
}

variable "fleet_server_policy_id" {
  type        = string
  nullable    = true
  default     = null
  description = "The policy ID for Fleet Server to use on itself."
}

variable "fleet_server_host" {
  type        = string
  nullable    = true
  default     = null
  description = "The binding host for Fleet Server HTTP. Overrides the host defined in the policy."
}

variable "fleet_server_port" {
  type        = string
  nullable    = true
  default     = null
  description = "The binding port for Fleet Server HTTP. Overrides the port defined in the policy."
}

variable "fleet_server_cert" {
  type        = string
  nullable    = true
  default     = null
  description = "The path to the certificate to use for HTTPS."
}

variable "fleet_server_insecure_http" {
  type        = bool
  default     = false
  description = "When true, exposes Fleet Server over HTTP (insecure). Setting this to true is not recommended."
}

# Enrollment Configuration

variable "fleet_enroll" {
  type        = bool
  default     = false
  description = "Set to 1 to enroll the Elastic Agent into Fleet Server."
}

variable "fleet_url" {
  type        = string
  default     = ""
  description = "URL to enroll the Fleet Server into."
}

variable "fleet_enrollment_token" {
  type        = string
  default     = ""
  sensitive   = true
  description = "The token to use for enrollment."
}

variable "fleet_token_name" {
  type        = string
  nullable    = true
  default     = null
  description = "The token name to use to fetch the token from Kibana."
}

variable "fleet_token_policy_name" {
  type        = string
  nullable    = true
  default     = null
  description = "The token policy name to use to fetch the token from Kibana."
}

variable "fleet_ca" {
  type        = string
  nullable    = true
  default     = null
  description = "The path to a certificate authority. Overrides ELASTICSEARCH_CA when set."
}

variable "fleet_insecure" {
  type        = bool
  default     = false
  description = "When true, Elastic Agent communicates with Fleet Server over insecure or unverified HTTP. Setting this to true is not recommended."
}
