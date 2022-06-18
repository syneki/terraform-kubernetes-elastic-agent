module "rbac" {
  source = "syneki/rbac/kubernetes"

  name      = var.name
  namespace = var.namespace

  labels = merge({
    app = "elastic-agent"
  }, var.labels)

  cluster_role = {
    rules = [
      {
        api_groups = [""]
        resources  = ["nodes", "namespaces", "events", "pods", "services", "configmaps", "serviceaccounts", "peristentvolumes", "persistentvolumeclaims"]
        verbs      = ["get", "list", "watch"]
      },
      {
        api_groups = ["extensions"]
        resources  = ["replicasets"]
        verbs      = ["get", "list", "watch"]

      },
      {
        api_groups = ["apps"]
        resources  = ["statefulsets", "deployments", "replicasets", "daemonsets"]
      verbs = ["get", "list", "watch"] },
      {
        api_groups = [""]
        resources  = ["nodes/stats"]
        verbs      = ["get"]
      },
      {
        api_groups = ["batch"]
        resources  = ["jobs", "cronjobs"]
        verbs      = ["get", "list", "watch"]
      },
      {
        non_resource_urls = ["/metrics"]
        verbs             = ["get"]
      },
      {
        api_groups = ["rbac.authorization.k8s.io"]
        resources  = ["clusterrolebindings", "clusterroles", "rolebindings", "roles"]
        verbs      = ["get", "list", "watch"]
      },
      {
        api_groups = ["policy"]
        resources  = ["podsecuritypolicies"]
        verbs      = ["get", "list", "watch"]
      }
    ]
  }

  roles = [
    {
      name = "kubeadm-config" # The name will be rbac-example-kubeadm-config
      rules = [
        {
          api_groups     = [""]
          resources      = ["configmaps"]
          resource_names = ["kubeadm-config"]
          verbs          = ["get"]
        },
      ]
    },
    {
      name = "" # The name will be rbac-example-kubeadm-config
      rules = [
        {
          api_groups = ["coordination.k8s.io"]
          resources  = ["leases"]
          verbs      = ["get", "create", "update"]
        },
      ]
    }
  ]
}

resource "kubernetes_secret" "elastic_agent" {

  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = var.labels
  }

  data = {
    "ELASTICSEARCH_PASSWORD" = var.elasticsearch_password
    "KIBANA_PASSWORD"        = var.kibana_password
    "KIBANA_FLEET_PASSWORD"  = var.kibana_fleet_password
    "FLEET_ENROLLMENT_TOKEN" = var.fleet_enrollment_token
  }
}

resource "kubernetes_daemonset" "elastic_agent" {
  metadata {
    name      = var.name
    namespace = var.namespace

    labels = merge({
      app = "elastic-agent"
    }, var.labels)
  }

  spec {
    selector {
      match_labels = {
        app = var.name
      }
    }

    template {
      metadata {
        labels = {
          app = var.name
        }
      }

      spec {
        service_account_name = module.rbac.service_account

        container {
          name  = var.name
          image = "docker.elastic.co/beats/elastic-agent:8.2.2"

          env {
            name  = "ELASTICSEARCH_HOST"
            value = var.elasticsearch_host
          }

          env {
            name  = "ELASTICSEARCH_USERNAME"
            value = var.elasticsearch_username
          }

          env {
            name = "ELASTICSEARCH_PASSWORD"
          }

          env {
            name  = "ELASTICSEARCH_CA"
            value = "/certs/elasticsearch/ca.crt"
          }

          env {
            name  = "KIBANA_HOST"
            value = var.kibana_host
          }

          env {
            name  = "KIBANA_USERNAME"
            value = var.kibana_username
          }

          env {
            name = "KIBANA_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.elastic_agent.metadata[0].name
                key  = "KIBANA_PASSWORD"
              }
            }
          }

          env {
            name  = "KIBANA_CA"
            value = "/certs/kibana/ca.crt"
          }

          env {
            name  = "KIBANA_FLEET_SETUP"
            value = var.kibana_fleet_setup
          }

          dynamic "env" {
            for_each = var.kibana_fleet_host != null ? [1] : []
            content {
              name  = "KIBANA_FLEET_HOST"
              value = var.kibana_fleet_host
            }
          }

          dynamic "env" {
            for_each = var.kibana_fleet_username != null ? [1] : []
            content {
              name  = "KIBANA_FLEET_USERNAME"
              value = var.kibana_fleet_username
            }
          }

          dynamic "env" {
            for_each = var.kibana_fleet_password != null ? [1] : []
            content {
              name = "KIBANA_FLEET_PASSWORD"
              value_from {
                secret_key_ref {
                  name = kubernetes_secret.elastic_agent.metadata[0].name
                  key  = "KIBANA_FLEET_PASSWORD"
                }
              }
            }
          }

          dynamic "env" {
            for_each = var.kibana_fleet_ca != null ? [1] : []
            content {
              name  = "KIBANA_FLEET_CA"
              value = "/certs/kibana-fleet/ca.crt"
            }
          }

          env {
            name  = "FLEET_SERVER_ENABLE"
            value = var.fleet_server_enable ? "1" : "0"
          }

          dynamic "env" {
            for_each = var.fleet_server_elasticsearch_host != null ? [1] : []
            content {
              name  = "FLEET_SERVER_ELASTICSEARCH_HOST"
              value = var.fleet_server_elasticsearch_host
            }
          }

          dynamic "env" {
            for_each = var.fleet_server_elasticsearch_ca != null ? [1] : []
            content {
              name  = "FLEET_SERVER_ELASTICSEARCH_CA"
              value = "/certs/fleet-server-elasticsearch/ca.crt"
            }
          }

          dynamic "env" {
            for_each = var.fleet_server_service_token != null ? [1] : []
            content {
              name  = "FLEET_SERVER_SERVICE_TOKEN"
              value = var.fleet_server_service_token
            }
          }

          dynamic "env" {
            for_each = var.fleet_server_policy_name != null ? [1] : []
            content {
              name  = "FLEET_SERVER_POLICY_NAME"
              value = var.fleet_server_policy_name
            }
          }

          dynamic "env" {
            for_each = var.fleet_server_policy_id != null ? [1] : []
            content {
              name  = "FLEET_SERVER_POLICY_ID"
              value = var.fleet_server_policy_id
            }
          }

          dynamic "env" {
            for_each = var.fleet_server_host != null ? [1] : []
            content {
              name  = "FLEET_SERVER_HOST"
              value = var.fleet_server_host
            }
          }

          dynamic "env" {
            for_each = var.fleet_server_port != null ? [1] : []
            content {
              name  = "FLEET_SERVER_PORT"
              value = var.fleet_server_port
            }
          }

          dynamic "env" {
            for_each = var.fleet_server_cert != null ? [1] : []
            content {
              name  = "FLEET_SERVER_CERT"
              value = "/certs/fleet-server-cert/ca.crt"
            }
          }

          env {
            name  = "FLEET_SERVER_INSECURE_HTTP"
            value = var.fleet_server_insecure_http
          }

          env {
            name  = "FLEET_ENROLL"
            value = var.fleet_enroll
          }

          env {
            name  = "FLEET_URL"
            value = var.fleet_url
          }

          env {
            name = "FLEET_ENROLLMENT_TOKEN"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.elastic_agent.metadata[0].name
                key  = "FLEET_ENROLLMENT_TOKEN"
              }
            }
          }

          dynamic "env" {
            for_each = var.fleet_token_name != null ? [1] : []
            content {
              name  = "FLEET_TOKEN_NAME"
              value = var.fleet_token_name
            }
          }

          dynamic "env" {
            for_each = var.fleet_token_policy_name != null ? [1] : []
            content {
              name  = "FLEET_TOKEN_POLICY_NAME"
              value = var.fleet_token_policy_name
            }
          }

          dynamic "env" {
            for_each = var.fleet_ca != null ? [1] : []
            content {
              name  = "FLEET_CA"
              value = "/certs/fleet/ca.crt"
            }
          }

          env {
            name  = "FLEET_INSECURE"
            value = var.fleet_insecure
          }

          env {
            name = "NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          security_context {
            run_as_user = 0
          }

          volume_mount {
            name       = "proc"
            mount_path = "/hostfs/proc"
            read_only  = true
          }

          volume_mount {
            name       = "cgroup"
            mount_path = "/hostfs/sys/fs/cgroup"
            read_only  = true
          }

          volume_mount {
            name       = "varlibdockercontainers"
            mount_path = "/var/lib/docker/containers"
            read_only  = true
          }

          volume_mount {
            name       = "varlog"
            mount_path = "/var/log"
            read_only  = true
          }

          volume_mount {
            name       = "etc-kubernetes"
            mount_path = "/hostfs/etc/kubernetes"
            read_only  = true
          }

          volume_mount {
            name       = "var-lib"
            mount_path = "/hostfs/var/lib"
            read_only  = true
          }

          volume_mount {
            name       = "passwd"
            mount_path = "/hostfs/etc/passwd"
            read_only  = true
          }

          volume_mount {
            name       = "group"
            mount_path = "/hostfs/etc/group"
            read_only  = true
          }

          volume_mount {
            name       = "etcsysmd"
            mount_path = "/hostfs/etc/systemd"
            read_only  = true
          }

          dynamic "volume_mount" {
            for_each = var.elasticsearch_ca != null ? [1] : []
            content {
              name       = "elasticsearch-certificate"
              mount_path = "/certs/elasticsearch"
            }
          }


          dynamic "volume_mount" {
            for_each = var.kibana_ca != null ? [1] : []
            content {
              name       = "kibana-certificate"
              mount_path = "/certs/kibana"
            }
          }

          dynamic "volume_mount" {
            for_each = var.kibana_fleet_ca != null ? [1] : []
            content {
              name       = "kibana-fleet-certificate"
              mount_path = "/certs/kibana-fleet"
            }
          }

          dynamic "volume_mount" {
            for_each = var.fleet_server_elasticsearch_ca != null ? [1] : []
            content {
              name       = "fleet-server-elasticsearch-certificate"
              mount_path = "/certs/fleet-server-elasticsearch"
            }
          }

          dynamic "volume_mount" {
            for_each = var.fleet_ca != null ? [1] : []
            content {
              name       = "fleet-certificate"
              mount_path = "/certs/fleet"
            }
          }
        }

        volume {
          name = "proc"
          host_path {
            path = "/proc"
          }
        }

        volume {
          name = "cgroup"
          host_path {
            path = "/sys/fs/cgroup"
          }
        }

        volume {
          name = "varlibdockercontainers"
          host_path {
            path = "/var/lib/docker/containers"
          }
        }

        volume {
          name = "varlog"
          host_path {
            path = "/var/log"
          }
        }

        volume {
          name = "etc-kubernetes"
          host_path {
            path = "/etc/kubernetes"
          }
        }

        volume {
          name = "var-lib"
          host_path {
            path = "/var/lib"
          }
        }

        volume {
          name = "passwd"
          host_path {
            path = "/etc/passwd"
          }
        }

        volume {
          name = "group"
          host_path {
            path = "/etc/group"
          }
        }

        volume {
          name = "etcsysmd"
          host_path {
            path = "/etc/systemd"
          }
        }

        dynamic "volume" {
          for_each = var.elasticsearch_ca != null ? [1] : []
          content {
            name = "elasticsearch-certificate"
            secret {
              secret_name = var.elasticsearch_ca
            }
          }
        }

        dynamic "volume" {
          for_each = var.kibana_ca != null ? [1] : []
          content {
            name = "kibana-certificate"
            secret {
              secret_name = var.kibana_ca
            }
          }
        }

        dynamic "volume" {
          for_each = var.kibana_fleet_ca != null ? [1] : []
          content {
            name = "kibana-fleet-certificate"
            secret {
              secret_name = var.kibana_fleet_ca
            }
          }
        }

        dynamic "volume" {
          for_each = var.fleet_server_elasticsearch_ca != null ? [1] : []
          content {
            name = "fleet-server-elasticsearch-certificate"
            secret {
              secret_name = var.fleet_server_elasticsearch_ca
            }
          }
        }

        dynamic "volume" {
          for_each = var.fleet_ca != null ? [1] : []
          content {
            name = "fleet-certificate"
            secret {
              secret_name = var.fleet_ca
            }
          }
        }
      }
    }
  }
}
