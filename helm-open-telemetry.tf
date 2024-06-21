resource "helm_release" "open_telemetry_operator" {
  for_each      = toset(["enabled"])
  name          = "opentelemetry-operator"
  repository    = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart         = "opentelemetry-operator"
  version       = "0.60.0"
  namespace     = kubernetes_namespace.monitoring["enabled"].id
  wait          = true
  wait_for_jobs = true

  values = [
    yamlencode({
      manager = {
        collectorImage = {
          repository = "otel/opentelemetry-collector-k8s"
        }
      }
      admissionWebhooks = {
        certManager = {
          enabled = true
        }
      }
    })
  ]

  set {
    name  = "nameOverride"
    value = "${var.environment}-otel-operator"
    type  = "string"
  }

  set {
    name  = "fullnameOverride"
    value = "${var.environment}-otel-operator"
    type  = "string"
  }

  depends_on = [
    kind_cluster.default,
    helm_release.metrics_server,
    helm_release.cert_manager,
    kubernetes_namespace.monitoring,
    helm_release.prometheus_stack,
  ]
}

resource "helm_release" "open_telemetry_collector" {
  for_each      = toset(["enabled"])
  name          = "opentelemetry-collector"
  repository    = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart         = "opentelemetry-collector"
  version       = "0.92.0"
  namespace     = kubernetes_namespace.monitoring["enabled"].id
  wait          = true
  wait_for_jobs = true

  values = [
    yamlencode({
      image = {
        repository = "otel/opentelemetry-collector-k8s"
      }
      mode = "statefulset"
    })
  ]

  set {
    name  = "nameOverride"
    value = "${var.environment}-otel-collector"
    type  = "string"
  }

  set {
    name  = "fullnameOverride"
    value = "${var.environment}-otel-collector"
    type  = "string"
  }

  depends_on = [
    kind_cluster.default,
    helm_release.metrics_server,
    helm_release.cert_manager,
    kubernetes_namespace.monitoring,
    helm_release.prometheus_stack,
  ]
}
