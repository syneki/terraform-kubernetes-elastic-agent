<!-- BEGIN_TF_DOCS -->

<p align="center">
<img alt="GitHub release (latest SemVer)" src="https://img.shields.io/github/v/release/syneki/terraform-kubernetes-elastic-agent">
<img alt="GitHub contributors" src="https://img.shields.io/github/contributors/syneki/terraform-kubernetes-elastic-agent">
<img alt="GitHub issues" src="https://img.shields.io/github/issues/syneki/terraform-kubernetes-elastic-agent">
<img alt="GitHub followers" src="https://img.shields.io/github/followers/syneki?style=social">
</p>

# Terraform Kubernetes Elastic Agent

Terraform module which create Elastic Agent, this module is perfect if you want to run a Fleet server or run an Elastic Agent on Fleet.

## Usage

### Fleet Server

```hcl
module "fleet_server" {
  source = "../.."

  name      = "fleet-server"
  namespace = "monitoring"

  fleet_server_enable             = true
  fleet_server_elasticsearch_host = "https://elasticsearch:9200"
  fleet_server_service_token      = "my-service-token"
  fleet_server_policy_id          = "fleet-server-policy"
  fleet_server_elasticsearch_ca   = "elasticsearch-coordinating-crt"
}
```

### Elastic Agent managed by Fleet

```hcl
module "fleet_elastic_agent" {
  source = "../.."

  name      = "fleet-server"
  namespace = "monitoring"

  fleet_enroll           = true
  fleet_url              = "https://fleet.syneki.com"
  fleet_enrollment_token = "myenrollmenttoken"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.11.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rbac"></a> [rbac](#module\_rbac) | syneki/rbac/kubernetes | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_daemonset.elastic_agent](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/daemonset) | resource |
| [kubernetes_secret.elastic_agent](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_elasticsearch_ca"></a> [elasticsearch\_ca](#input\_elasticsearch\_ca) | The path to a certificate authority. | `string` | `null` | no |
| <a name="input_elasticsearch_host"></a> [elasticsearch\_host](#input\_elasticsearch\_host) | The Elasticsearch host to communicate with | `string` | `"http://elasticsearch:9200"` | no |
| <a name="input_elasticsearch_password"></a> [elasticsearch\_password](#input\_elasticsearch\_password) | The basic authentication password used to connect to Kibana and retrieve a service\_token for Fleet. | `string` | `"changeme"` | no |
| <a name="input_elasticsearch_username"></a> [elasticsearch\_username](#input\_elasticsearch\_username) | basic authentication username used to connect to Kibana and retrieve a service\_token for Fleet. | `string` | `"elastic"` | no |
| <a name="input_fleet_ca"></a> [fleet\_ca](#input\_fleet\_ca) | The path to a certificate authority. Overrides ELASTICSEARCH\_CA when set. | `string` | `null` | no |
| <a name="input_fleet_enroll"></a> [fleet\_enroll](#input\_fleet\_enroll) | Set to 1 to enroll the Elastic Agent into Fleet Server. | `bool` | `false` | no |
| <a name="input_fleet_enrollment_token"></a> [fleet\_enrollment\_token](#input\_fleet\_enrollment\_token) | The token to use for enrollment. | `string` | `""` | no |
| <a name="input_fleet_insecure"></a> [fleet\_insecure](#input\_fleet\_insecure) | When true, Elastic Agent communicates with Fleet Server over insecure or unverified HTTP. Setting this to true is not recommended. | `bool` | `false` | no |
| <a name="input_fleet_server_cert"></a> [fleet\_server\_cert](#input\_fleet\_server\_cert) | The path to the certificate to use for HTTPS. | `string` | `null` | no |
| <a name="input_fleet_server_elasticsearch_ca"></a> [fleet\_server\_elasticsearch\_ca](#input\_fleet\_server\_elasticsearch\_ca) | The path to a certificate authority. Overrides ELASTICSEARCH\_CA when set. | `string` | `null` | no |
| <a name="input_fleet_server_elasticsearch_host"></a> [fleet\_server\_elasticsearch\_host](#input\_fleet\_server\_elasticsearch\_host) | The Elasticsearch host for Fleet Server to communicate with. Overrides ELASTICSEARCH\_HOST when set. | `string` | `null` | no |
| <a name="input_fleet_server_enable"></a> [fleet\_server\_enable](#input\_fleet\_server\_enable) | Set to 1 to bootstrap Fleet Server on this Elastic Agent. When set to 1, this automatically forces Fleet enrollment as well. | `bool` | `false` | no |
| <a name="input_fleet_server_host"></a> [fleet\_server\_host](#input\_fleet\_server\_host) | The binding host for Fleet Server HTTP. Overrides the host defined in the policy. | `string` | `null` | no |
| <a name="input_fleet_server_insecure_http"></a> [fleet\_server\_insecure\_http](#input\_fleet\_server\_insecure\_http) | When true, exposes Fleet Server over HTTP (insecure). Setting this to true is not recommended. | `bool` | `false` | no |
| <a name="input_fleet_server_policy_id"></a> [fleet\_server\_policy\_id](#input\_fleet\_server\_policy\_id) | The policy ID for Fleet Server to use on itself. | `string` | `null` | no |
| <a name="input_fleet_server_policy_name"></a> [fleet\_server\_policy\_name](#input\_fleet\_server\_policy\_name) | The name of the policy for Fleet Server to use on itself. Overrides FLEET\_TOKEN\_POLICY\_NAME when set. | `string` | `null` | no |
| <a name="input_fleet_server_port"></a> [fleet\_server\_port](#input\_fleet\_server\_port) | The binding port for Fleet Server HTTP. Overrides the port defined in the policy. | `string` | `null` | no |
| <a name="input_fleet_server_service_token"></a> [fleet\_server\_service\_token](#input\_fleet\_server\_service\_token) | Service token to use for communication with Elasticsearch. | `string` | `null` | no |
| <a name="input_fleet_token_name"></a> [fleet\_token\_name](#input\_fleet\_token\_name) | The token name to use to fetch the token from Kibana. | `string` | `null` | no |
| <a name="input_fleet_token_policy_name"></a> [fleet\_token\_policy\_name](#input\_fleet\_token\_policy\_name) | The token policy name to use to fetch the token from Kibana. | `string` | `null` | no |
| <a name="input_fleet_url"></a> [fleet\_url](#input\_fleet\_url) | URL to enroll the Fleet Server into. | `string` | `""` | no |
| <a name="input_kibana_ca"></a> [kibana\_ca](#input\_kibana\_ca) | The path to a certificate authority. | `string` | `null` | no |
| <a name="input_kibana_fleet_ca"></a> [kibana\_fleet\_ca](#input\_kibana\_fleet\_ca) | The path to a certificate authority. Overrides KIBANA\_CA when set. | `string` | `null` | no |
| <a name="input_kibana_fleet_host"></a> [kibana\_fleet\_host](#input\_kibana\_fleet\_host) | The Kibana host to enable Fleet on. Overrides FLEET\_HOST when set. | `string` | `null` | no |
| <a name="input_kibana_fleet_password"></a> [kibana\_fleet\_password](#input\_kibana\_fleet\_password) | The basic authentication password used to connect to Kibana and retrieve a service\_token to enable Fleet. Overrides ELASTICSEARCH\_PASSWORD when set. | `string` | `null` | no |
| <a name="input_kibana_fleet_setup"></a> [kibana\_fleet\_setup](#input\_kibana\_fleet\_setup) | Enabling Fleet is required before Fleet Server will start. When this action is not performed, a user must manually log in to Kibana and visit the Fleet page to enable setup. | `bool` | `false` | no |
| <a name="input_kibana_fleet_username"></a> [kibana\_fleet\_username](#input\_kibana\_fleet\_username) | The basic authentication username used to connect to Kibana and retrieve a service\_token to enable Fleet. Overrides ELASTICSEARCH\_USERNAME when set. | `string` | `null` | no |
| <a name="input_kibana_host"></a> [kibana\_host](#input\_kibana\_host) | The Kibana host. | `string` | `"http://kibana:5601"` | no |
| <a name="input_kibana_password"></a> [kibana\_password](#input\_kibana\_password) | The basic authentication password used to connect to Kibana to retrieve a service\_token. | `string` | `"changeme"` | no |
| <a name="input_kibana_username"></a> [kibana\_username](#input\_kibana\_username) | The basic authentication username used to connect to Kibana to retrieve a service\_token. | `string` | `"elastic"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels append to resources created | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name used to create resources | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace where resources will be created | `string` | `"default"` | no |

## Outputs

No outputs.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an issue, or submit a pull request with your contribution.

## Issues

If you encountered a problem running this container, you can file an issue. For us to provide better support, be sure to include the following information in your issue:
- Host OS and version
- Terraform version (`terraform version`)
- Providers and modules version (`terraform version` in the module directory)

## License

Copyright © 2022 Syneki

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
```
http://www.apache.org/licenses/LICENSE-2.0
```
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
<!-- END_TF_DOCS -->
