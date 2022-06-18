terraform {
  required_version = ">= 0.13.1"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "syneki"
}
