############################################################
## Metrics Helm Charts
############################################################
locals {
  values_metrics_server = yamlencode({
    replicas = 3
    metrics = {
      enabled = true
    }
    apiService = {
      create = true
    }
    args = [
      "--kubelet-insecure-tls"
    ]
    serviceMonitor = {
      enabled = true
    }
    priorityClassName = local.priority_class.create ? local.priority_class["name"] : ""
    updateStrategy = {
      type = "RollingUpdate"
      rollingUpdate = {
        maxSurge       = 0
        maxUnavailable = 1
      }
    }
  })
}

resource "kubernetes_namespace" "metrics_server" {
  for_each = var.metrics_server["enabled"] && var.metrics_server.namespace != "kube-system" ? toset(["enabled"]) : toset([])
  metadata {
    labels = {
      name = var.metrics_server["name"]
    }

    name = var.metrics_server["namespace"]
  }
  depends_on = [
    kind_cluster.default,
    kubernetes_priority_class.kubernetes_addons,
    kubernetes_priority_class.kubernetes_addons_ds,
  ]
}

resource "helm_release" "metrics_server" {
  for_each                   = var.metrics_server.enabled ? toset(["enabled"]) : toset([])
  name                       = var.metrics_server.name
  namespace                  = var.metrics_server.namespace
  chart                      = var.metrics_server.chart
  atomic                     = var.metrics_server.atomic
  cleanup_on_fail            = var.metrics_server.cleanup_on_fail
  create_namespace           = var.metrics_server.create_namespace
  dependency_update          = var.metrics_server.dependency_update
  disable_crd_hooks          = var.metrics_server.disable_crd_hooks
  disable_openapi_validation = var.metrics_server.disable_openapi_validation
  disable_webhooks           = var.metrics_server.disable_webhooks
  force_update               = var.metrics_server.force_update
  lint                       = var.metrics_server.lint
  max_history                = var.metrics_server.max_history
  pass_credentials           = var.metrics_server.pass_credentials
  recreate_pods              = var.metrics_server.recreate_pods
  render_subchart_notes      = var.metrics_server.render_subchart_notes
  replace                    = var.metrics_server.replace
  repository                 = var.metrics_server.repository
  reset_values               = var.metrics_server.reset_values
  reuse_values               = var.metrics_server.reuse_values
  skip_crds                  = var.metrics_server.skip_crds
  timeout                    = var.metrics_server.timeout
  verify                     = var.metrics_server.verify
  version                    = var.metrics_server.version
  wait                       = var.metrics_server.wait
  wait_for_jobs              = var.metrics_server.wait_for_jobs

  values = [
    local.values_metrics_server,
    var.metrics_server["extra_values"]
  ]
  depends_on = [
    kind_cluster.default,
    kubernetes_namespace.metrics_server,
    kubernetes_priority_class.kubernetes_addons,
    kubernetes_priority_class.kubernetes_addons_ds,
    helm_release.prometheus_stack,
  ]
}

resource "kubernetes_network_policy" "metrics_server_default_deny" {
  for_each = var.metrics_server["enabled"] && var.metrics_server["default_network_policy"] ? toset(["enabled"]) : toset([])
  metadata {
    name      = "${var.metrics_server.name}-default-deny"
    namespace = var.metrics_server.namespace
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress"]
  }

  depends_on = [
    kind_cluster.default,
    kubernetes_namespace.metrics_server,
    kubernetes_priority_class.kubernetes_addons,
    kubernetes_priority_class.kubernetes_addons_ds,
    helm_release.prometheus_stack,
  ]
}

resource "kubernetes_network_policy" "metrics_server_allow_namespace" {
  for_each = var.metrics_server["enabled"] && var.metrics_server["default_network_policy"] ? toset(["enabled"]) : toset([])
  metadata {
    name      = "${var.metrics_server.name}-allow-namespace"
    namespace = var.metrics_server.namespace
  }

  spec {
    pod_selector {}

    ingress {
      from {
        namespace_selector {
          match_labels = {
            name = var.metrics_server.namespace
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }

  depends_on = [
    kind_cluster.default,
    kubernetes_namespace.metrics_server,
    kubernetes_priority_class.kubernetes_addons,
    kubernetes_priority_class.kubernetes_addons_ds,
    helm_release.prometheus_stack,
  ]
}

resource "kubernetes_network_policy" "metrics_server_allow_control_plane" {
  for_each = var.metrics_server["enabled"] && var.metrics_server["default_network_policy"] ? toset(["enabled"]) : toset([])
  metadata {
    name      = "${var.metrics_server.name}-allow-control-plane"
    namespace = var.metrics_server.namespace
  }

  spec {
    pod_selector {
      match_expressions {
        key      = "app.kubernetes.io/name"
        operator = "In"
        values   = ["metrics-server"]
      }
    }

    ingress {
      ports {
        port     = "4443"
        protocol = "TCP"
      }

      dynamic "from" {
        for_each = var.metrics_server["allowed_cidrs"]
        content {
          ip_block {
            cidr = from.value
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }

  depends_on = [
    kind_cluster.default,
    kubernetes_namespace.metrics_server,
    kubernetes_priority_class.kubernetes_addons,
    kubernetes_priority_class.kubernetes_addons_ds,
    helm_release.prometheus_stack,
  ]
}
