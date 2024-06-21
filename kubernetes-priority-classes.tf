locals {
  priority_class_ds = merge(
    {
      create = true
      name   = "kubernetes-addons-ds"
      value  = "10000"

    },
    var.priority_class_ds
  )
  priority_class = merge(
    {
      create = true
      name   = "kubernetes-addons"
      value  = "9000"

    },
    var.priority_class
  )
}

resource "kubernetes_priority_class" "kubernetes_addons_ds" {
  for_each = local.priority_class_ds["create"] ? toset(["enabled"]) : toset([])
  metadata {
    name = local.priority_class_ds["name"]
  }
  value      = local.priority_class_ds["value"]
  depends_on = [kind_cluster.default]
}

resource "kubernetes_priority_class" "kubernetes_addons" {
  for_each = local.priority_class["create"] ? toset(["enabled"]) : toset([])
  metadata {
    name = local.priority_class["name"]
  }
  value      = local.priority_class["value"]
  depends_on = [kind_cluster.default]
}
