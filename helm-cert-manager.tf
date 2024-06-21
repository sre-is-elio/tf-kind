############################################################
## Cert Manager Helm Charts
############################################################
resource "kubernetes_namespace" "cert_manager" {
  for_each = var.cert_manager.enabled ? toset(["enabled"]) : toset([])
  metadata {
    annotations = {
      name = var.cert_manager.namespace
    }
    labels = {
      "certmanager.k8s.io/disable-validation" = "true"
      "type"                                  = "system"
      "name"                                  = "cert-manager"
    }
    name = var.cert_manager.namespace
  }
  depends_on = [kind_cluster.default]
}

resource "helm_release" "cert_manager" {
  for_each                   = var.cert_manager.enabled ? toset(["enabled"]) : toset([])
  name                       = var.cert_manager.name
  namespace                  = var.cert_manager.namespace
  chart                      = var.cert_manager.chart
  atomic                     = var.cert_manager.atomic
  cleanup_on_fail            = var.cert_manager.cleanup_on_fail
  create_namespace           = var.cert_manager.create_namespace
  dependency_update          = var.cert_manager.dependency_update
  disable_crd_hooks          = var.cert_manager.disable_crd_hooks
  disable_openapi_validation = var.cert_manager.disable_openapi_validation
  disable_webhooks           = var.cert_manager.disable_webhooks
  force_update               = var.cert_manager.force_update
  lint                       = var.cert_manager.lint
  max_history                = var.cert_manager.max_history
  pass_credentials           = var.cert_manager.pass_credentials
  recreate_pods              = var.cert_manager.recreate_pods
  render_subchart_notes      = var.cert_manager.render_subchart_notes
  replace                    = var.cert_manager.replace
  repository                 = var.cert_manager.repository
  reset_values               = var.cert_manager.reset_values
  reuse_values               = var.cert_manager.reuse_values
  skip_crds                  = var.cert_manager.skip_crds
  timeout                    = var.cert_manager.timeout
  verify                     = var.cert_manager.verify
  version                    = var.cert_manager.version
  wait                       = var.cert_manager.wait
  wait_for_jobs              = var.cert_manager.wait_for_jobs

  set {
    name  = "prometheus.enabled"
    value = true
    type  = "auto"
  }

  set {
    name  = "prometheus.servicemonitor.enabled"
    value = true
    type  = "auto"
  }

  set {
    name  = "securityContext.fsGroup"
    value = 1001
    type  = "auto"
  }

  dynamic "set" {
    for_each = var.cert_manager.sets
    iterator = item
    content {
      name  = item.value.name
      value = item.value.value
    }
  }

  dynamic "set_sensitive" {
    for_each = var.cert_manager.set_sensitives
    iterator = item
    content {
      name  = item.value.name
      value = item.value.value
    }
  }

  depends_on = [kind_cluster.default, helm_release.metrics_server, helm_release.prometheus_stack, kubernetes_namespace.cert_manager]
}
