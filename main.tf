data "strcase" "application" {
  string = var.application
}

locals {
  name       = data.strcase.application.to_kebab
  name_camel = data.strcase.application.to_camel

  tags = {
    Name       = local.name
    GitHubRepo = "kind"
    GitHubOrg  = "sre-is-elio"
    Managed_by = "Terraform"
    Workspace  = "Local"
  }
}

resource "kind_cluster" "default" {
  name           = local.name
  wait_for_ready = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      labels = {
        name       = "controlplane"
        managed_by = "Terraform"
      }
      role = "control-plane"
      kubeadm_config_patches = [
        yamlencode({
          kind = "ClusterConfiguration"
          apiServer = {
            extraArgs = {
              enable-admission-plugins = "NodeRestriction,MutatingAdmissionWebhook,ValidatingAdmissionWebhook"
            }
          }
          controllerManager = {
            extraArgs = {
              bind-address = "0.0.0.0"
            }
          }
          etcd = {
            local = {
              extraArgs = {
                listen-metrics-urls = "http://0.0.0.0:2381"
              }
            }
          }
          scheduler = {
            extraArgs = {
              bind-address = "0.0.0.0"
            }
          }
        }),
        yamlencode({
          kind = "InitConfiguration"
          nodeRegistration = {
            kubeletExtraArgs = {
              node-labels = "ingress-ready=true"
            }
          }
        }),
        yamlencode({
          kind = "KubeProxyConfiguration"
          metricsBindAddress = "0.0.0.0"
        }),
      ]

      extra_port_mappings {
        container_port = 80
        host_port      = 80
      }

      extra_port_mappings {
        container_port = 443
        host_port      = 443
      }
    }

    node {
      kubeadm_config_patches = null
      labels = {
        name       = "node01"
        managed_by = "Terraform"
      }
      role = "worker"
    }

    node {

      kubeadm_config_patches = null
      labels = {
        name       = "node02"
        managed_by = "Terraform"
      }
      role = "worker"
    }

    runtime_config = {}
  }
}
