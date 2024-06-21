resource "kubernetes_namespace" "monitoring" {
  for_each = toset(["enabled"])
  metadata {
    labels = {
      name      = "monitoring"
      managedBy = "Terraform"
    }
    name = "monitoring"
  }

  depends_on = [
    kind_cluster.default,
  ]
}

resource "helm_release" "prometheus_stack" {
  for_each      = var.prometheus_stack.enabled ? toset(["enabled"]) : toset([])
  name          = var.prometheus_stack.name
  repository    = var.prometheus_stack.repository
  chart         = var.prometheus_stack.chart
  version       = var.prometheus_stack.version
  namespace     = kubernetes_namespace.monitoring["enabled"].id
  wait          = var.prometheus_stack.wait
  wait_for_jobs = var.prometheus_stack.wait_for_jobs

  values = [
    "${file("values/prometheus.yaml")}"
  ]

  set {
    name  = "nameOverride"
    value = "${var.environment}-kube-prometheus-stack"
    type  = "string"
  }

  set {
    name  = "fullnameOverride"
    value = "${var.environment}-kube-prometheus-stack"
    type  = "string"
  }

  set {
    name  = "prometheus-node-exporter.fullnameOverride"
    value = "${var.environment}-kube-prometheus-stack-node-exporter"
    type  = "string"
  }

  set {
    name  = "prometheus-node-exporter.nameOverride"
    value = "${var.environment}-kube-prometheus-stack-stack-node-exporter"
    type  = "string"
  }

  set {
    name  = "kube-state-metrics.fullnameOverride"
    value = "${var.environment}-kube-prometheus-stack-state-metrics"
    type  = "string"
  }

  set {
    name  = "kube-state-metrics.nameOverride"
    value = "${var.environment}-kube-prometheus-stack-state-metrics"
    type  = "string"
  }

  set {
    name  = "prometheus.fullnameOverride"
    value = "${var.environment}-kube-prometheus-stack"
    type  = "string"
  }

  set {
    name  = "prometheus.nameOverride"
    value = "${var.environment}-kube-prometheus-stack"
    type  = "string"
  }

  depends_on = [
    kind_cluster.default,
    kubernetes_namespace.monitoring,
  ]
}

resource "helm_release" "grafana" {
  for_each      = var.grafana.enabled ? toset(["enabled"]) : toset([])
  name          = var.grafana.name
  repository    = var.grafana.repository
  chart         = var.grafana.chart
  version       = var.grafana.version
  namespace     = kubernetes_namespace.monitoring["enabled"].id
  wait          = var.grafana.wait
  wait_for_jobs = var.grafana.wait_for_jobs

  values = [
    "${file("values/grafana.yaml")}"
  ]

  set {
    name  = "nameOverride"
    value = "${var.environment}-grafana"
    type  = "string"
  }

  set {
    name  = "fullnameOverride"
    value = "${var.environment}-grafana"
    type  = "string"
  }

  depends_on = [
    kind_cluster.default,
    helm_release.cert_manager,
    kubernetes_namespace.monitoring,
    helm_release.prometheus_stack,
  ]
}

resource "helm_release" "loki" {
  for_each      = var.loki.enabled ? toset(["enabled"]) : toset([])
  name          = var.loki.name
  repository    = var.loki.repository
  chart         = var.loki.chart
  version       = var.loki.version
  namespace     = kubernetes_namespace.monitoring["enabled"].id
  wait          = var.loki.wait
  wait_for_jobs = var.loki.wait_for_jobs
  timeout       = 600

  values = [
    "${file("values/loki.yaml")}"
  ]

  set {
    name  = "nameOverride"
    value = "${var.environment}-loki"
    type  = "string"
  }

  set {
    name  = "fullnameOverride"
    value = "${var.environment}-loki"
    type  = "string"
  }

  depends_on = [
    kind_cluster.default,
    helm_release.grafana,
    helm_release.cert_manager,
    kubernetes_namespace.monitoring,
    helm_release.prometheus_stack,
  ]
}

resource "helm_release" "promtail" {
  for_each      = var.promtail.enabled ? toset(["enabled"]) : toset([])
  name          = var.promtail.name
  repository    = var.promtail.repository
  chart         = var.promtail.chart
  version       = var.promtail.version
  namespace     = kubernetes_namespace.monitoring["enabled"].id
  wait          = var.promtail.wait
  wait_for_jobs = var.promtail.wait_for_jobs

  values = [
    "${file("values/promtail.yaml")}"
  ]

  set {
    name  = "nameOverride"
    value = "${var.environment}-promtail"
    type  = "string"
  }

  set {
    name  = "fullnameOverride"
    value = "${var.environment}-promtail"
    type  = "string"
  }

  depends_on = [
    kind_cluster.default,
    helm_release.grafana,
    helm_release.loki,
    helm_release.cert_manager,
    kubernetes_namespace.monitoring,
    helm_release.prometheus_stack,
  ]
}

# resource "helm_release" "internal_tempo" {
#   for_each      = toset(["enabled"])
#   name          = "internal-tempo-distributed"
#   repository    = "https://grafana.github.io/helm-charts"
#   chart         = "tempo-distributed"
#   version       = "2.3.1"
#   namespace     = kubernetes_namespace.monitoring["enabled"].id
#   wait          = true
#   wait_for_jobs = true

#   set {
#     name  = "nameOverride"
#     value = "${var.environment}-internal-tempo"
#     type  = "string"
#   }

#   set {
#     name  = "fullnameOverride"
#     value = "${var.environment}-internal-tempo"
#     type  = "string"
#   }

#   depends_on = [
#     kind_cluster.default,
#     helm_release.grafana,
#     helm_release.loki,
#     helm_release.cert_manager,
#     kubernetes_namespace.monitoring,
#     helm_release.prometheus_stack,
#   ]
# }

# resource "helm_release" "external_tempo" {
#   for_each      = toset(["enabled"])
#   name          = "external-tempo-distributed"
#   repository    = "https://grafana.github.io/helm-charts"
#   chart         = "tempo-distributed"
#   version       = "2.3.1"
#   namespace     = kubernetes_namespace.monitoring["enabled"].id
#   wait          = true
#   wait_for_jobs = true

#   set {
#     name  = "nameOverride"
#     value = "${var.environment}-external-tempo"
#     type  = "string"
#   }

#   set {
#     name  = "fullnameOverride"
#     value = "${var.environment}-external-tempo"
#     type  = "string"
#   }

#   depends_on = [
#     kind_cluster.default,
#     helm_release.grafana,
#     helm_release.loki,
#     helm_release.cert_manager,
#     kubernetes_namespace.monitoring,
#     helm_release.prometheus_stack,
#   ]
# }
