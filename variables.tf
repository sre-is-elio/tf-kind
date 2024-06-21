variable "application" {
  description = "Application Name"
  type        = string
  default     = "dev"
}

variable "environment" {
  description = "Environment Name. Which runtime owns the resource? This is used for cost analysis and support."
  type        = string
  validation {
    condition = anytrue([
      var.environment == "sharedtools",
      var.environment == "dev",
      var.environment == "demo",
      var.environment == "data",
      var.environment == "prod",
    ])
    error_message = "Must have a valid environment, can be dev, demo, data, prod."
  }
  default = "dev"
}

variable "market" {
  description = "Market Name. Which market owns the resource? This is used for cost analysis and support."
  type        = string
  validation {
    condition = anytrue([
      var.market == "us" || var.market == "US",
    ])
    error_message = "Must have a valid market code, can be us|US."
  }
  default = "us"
}

variable "priority_class" {
  description = "Customize a priority class for addons"
  type = object({
    create = optional(bool, true)
    name   = optional(string, "kubernetes-addons")
    value  = optional(string, "9000")
  })
  default = {}
}

variable "priority_class_ds" {
  description = "Customize a priority class for addons daemonsets"
  type = object({
    create = optional(bool, true)
    name   = optional(string, "kubernetes-addons-ds")
    value  = optional(string, "10000")
  })
  default = {}
}

variable "random_password" {
  description = "Jenkins Random Password"
  type = object({
    length           = optional(number, 50)
    min_numeric      = optional(number, 10)
    min_special      = optional(number, 10)
    min_upper        = optional(number, 10)
    min_lower        = optional(number, 20)
    special          = optional(bool, true)
    override_special = optional(string, "!#$%&*()-_=+[]{}<>:?Çç")
  })
  default = {}
}

variable "actions_runner_controller" {
  description = "Helm GitHub Actions Runner Controller Configuration"
  type = object({
    enabled                    = optional(bool, true)
    enable_ha                  = optional(bool, false)
    atomic                     = optional(bool, false)
    chart                      = optional(string, "actions-runner-controller")
    cleanup_on_fail            = optional(bool, false)
    create_namespace           = optional(bool, true)
    dependency_update          = optional(bool, false)
    disable_crd_hooks          = optional(bool, false)
    disable_openapi_validation = optional(bool, false)
    disable_webhooks           = optional(bool, false)
    force_update               = optional(bool, false)
    lint                       = optional(bool, false)
    max_history                = optional(string, 30)
    name                       = optional(string, "actions-runner-controller")
    namespace                  = optional(string, "tools")
    pass_credentials           = optional(bool, false)
    recreate_pods              = optional(bool, false)
    render_subchart_notes      = optional(bool, true)
    replace                    = optional(bool, false)
    repository                 = optional(string, "https://actions-runner-controller.github.io/actions-runner-controller")
    reset_values               = optional(bool, false)
    reuse_values               = optional(bool, false)
    skip_crds                  = optional(bool, false)
    timeout                    = optional(number, 300)
    verify                     = optional(bool, false)
    version                    = optional(string, "0.23.7")
    wait                       = optional(bool, true)
    wait_for_jobs              = optional(bool, false)
    sets = optional(map(object({
      name  = string
      value = string
    })), {})
    set_sensitives = optional(map(object({
      name  = string
      value = string
    })), {})
    set_strings = optional(map(object({
      name  = string
      value = string
    })), {})
  })
  default = {}
}

variable "actions_runner_controller_provisioner" {
  description = "Helm GitHub Actions Runner Controller Provisioner Configuration"
  type = object({
    enabled                    = optional(bool, true)
    enable_ha                  = optional(bool, false)
    atomic                     = optional(bool, false)
    chart                      = optional(string, "charts/actions-runner-controller-provisioner")
    cleanup_on_fail            = optional(bool, false)
    create_namespace           = optional(bool, true)
    dependency_update          = optional(bool, false)
    disable_crd_hooks          = optional(bool, false)
    disable_openapi_validation = optional(bool, false)
    disable_webhooks           = optional(bool, false)
    force_update               = optional(bool, false)
    lint                       = optional(bool, false)
    max_history                = optional(string, 30)
    name                       = optional(string, "arc-runner")
    namespace                  = optional(string, "tools")
    pass_credentials           = optional(bool, false)
    recreate_pods              = optional(bool, false)
    render_subchart_notes      = optional(bool, true)
    replace                    = optional(bool, false)
    repository                 = optional(string, "")
    reset_values               = optional(bool, false)
    reuse_values               = optional(bool, false)
    skip_crds                  = optional(bool, false)
    timeout                    = optional(number, 300)
    verify                     = optional(bool, false)
    version                    = optional(string, "0.1.0")
    wait                       = optional(bool, true)
    wait_for_jobs              = optional(bool, false)
    sets = optional(map(object({
      name  = string
      value = string
    })), {})
    set_sensitives = optional(map(object({
      name  = string
      value = string
    })), {})
    set_strings = optional(map(object({
      name  = string
      value = string
    })), {})
  })
  default = {}
}

variable "cert_manager" {
  description = "Cert Mananger Helm Chart Configuration"
  type = object({
    enabled                    = optional(bool, true)
    atomic                     = optional(bool, false)
    chart                      = optional(string, "cert-manager")
    cleanup_on_fail            = optional(bool, false)
    create_namespace           = optional(bool, false)
    dependency_update          = optional(bool, false)
    disable_crd_hooks          = optional(bool, false)
    disable_openapi_validation = optional(bool, false)
    disable_webhooks           = optional(bool, false)
    force_update               = optional(bool, false)
    lint                       = optional(bool, false)
    max_history                = optional(string, 30)
    name                       = optional(string, "cert-manager")
    namespace                  = optional(string, "cert-manager")
    pass_credentials           = optional(bool, false)
    recreate_pods              = optional(bool, false)
    render_subchart_notes      = optional(bool, true)
    replace                    = optional(bool, false)
    repository                 = optional(string, "https://charts.jetstack.io")
    reset_values               = optional(bool, false)
    reuse_values               = optional(bool, false)
    skip_crds                  = optional(bool, false)
    tag                        = optional(string, null)
    timeout                    = optional(number, 300)
    verify                     = optional(bool, false)
    version                    = optional(string, "1.14.5")
    wait                       = optional(bool, true)
    wait_for_jobs              = optional(bool, false)
    sets = optional(map(object({
      name  = string
      value = string
      })), {
      "installCRDs" = {
        name  = "installCRDs"
        value = true
      }
    })
    set_sensitives = optional(map(object({
      name  = string
      value = string
    })), {})
    set_strings = optional(map(object({
      name  = string
      value = string
    })), {})
  })
  default = {}
}

variable "jenkins" {
  description = "Helm Jenkins Configuration"
  type = object({
    enabled                    = optional(bool, true)
    atomic                     = optional(bool, false)
    chart                      = optional(string, "jenkins")
    cleanup_on_fail            = optional(bool, false)
    create_namespace           = optional(bool, true)
    dependency_update          = optional(bool, false)
    disable_crd_hooks          = optional(bool, false)
    disable_openapi_validation = optional(bool, false)
    disable_webhooks           = optional(bool, false)
    force_update               = optional(bool, false)
    lint                       = optional(bool, false)
    max_history                = optional(string, 30)
    name                       = optional(string, "jenkins")
    namespace                  = optional(string, "tools")
    pass_credentials           = optional(bool, false)
    recreate_pods              = optional(bool, false)
    render_subchart_notes      = optional(bool, true)
    replace                    = optional(bool, false)
    repository                 = optional(string, "https://charts.jenkins.io")
    reset_values               = optional(bool, false)
    reuse_values               = optional(bool, false)
    skip_crds                  = optional(bool, false)
    tag                        = optional(string, "jdk17")
    timeout                    = optional(number, 1000)
    use_efs_volume             = optional(bool, true)
    verify                     = optional(bool, false)
    version                    = optional(string, "5.1.1")
    wait                       = optional(bool, true)
    wait_for_jobs              = optional(bool, false)
    sets = optional(map(object({
      name  = string
      value = string
    })), {})
    set_sensitives = optional(map(object({
      name  = string
      value = string
    })), {})
    set_strings = optional(map(object({
      name  = string
      value = string
    })), {})
  })
  default = {}
}

variable "metrics_server" {
  description = "Helm Metrics Server Configuration"
  type = object({
    enabled                    = optional(bool, true)
    allowed_cidrs              = optional(list(string), ["0.0.0.0/0"])
    atomic                     = optional(bool, false)
    chart                      = optional(string, "metrics-server")
    cleanup_on_fail            = optional(bool, false)
    create_namespace           = optional(bool, true)
    default_network_policy     = optional(bool, true)
    dependency_update          = optional(bool, false)
    disable_crd_hooks          = optional(bool, false)
    disable_openapi_validation = optional(bool, false)
    disable_webhooks           = optional(bool, false)
    extra_values               = optional(string, "")
    force_update               = optional(bool, false)
    lint                       = optional(bool, false)
    max_history                = optional(string, 30)
    name                       = optional(string, "metrics-server")
    namespace                  = optional(string, "kube-system")
    pass_credentials           = optional(bool, false)
    recreate_pods              = optional(bool, false)
    render_subchart_notes      = optional(bool, true)
    replace                    = optional(bool, false)
    repository                 = optional(string, "https://kubernetes-sigs.github.io/metrics-server")
    reset_values               = optional(bool, false)
    reuse_values               = optional(bool, false)
    skip_crds                  = optional(bool, false)
    timeout                    = optional(number, 1800)
    verify                     = optional(bool, false)
    version                    = optional(string, "3.12.1")
    wait                       = optional(bool, true)
    wait_for_jobs              = optional(bool, false)
    sets = optional(map(object({
      name  = string
      value = string
    })), {})
    set_sensitives = optional(map(object({
      name  = string
      value = string
    })), {})
    set_strings = optional(map(object({
      name  = string
      value = string
    })), {})
  })
  default = {}
}

variable "prometheus_stack" {
  type = object({
    enabled       = optional(bool, true)
    name          = optional(string, "kube-prometheus-stack")
    repository    = optional(string, "https://prometheus-community.github.io/helm-charts")
    chart         = optional(string, "kube-prometheus-stack")
    version       = optional(string, "58.6.0")
    wait          = optional(bool, true)
    wait_for_jobs = optional(bool, true)
  })
  default = {}
}

variable "grafana" {
  type = object({
    enabled       = optional(bool, true)
    name          = optional(string, "grafana")
    repository    = optional(string, "https://grafana.github.io/helm-charts")
    chart         = optional(string, "grafana")
    version       = optional(string, "7.3.11")
    wait          = optional(bool, true)
    wait_for_jobs = optional(bool, true)
  })
  default = {}
}

variable "loki" {
  type = object({
    enabled       = optional(bool, true)
    name          = optional(string, "loki")
    repository    = optional(string, "https://grafana.github.io/helm-charts")
    chart         = optional(string, "loki")
    version       = optional(string, "6.5.2")
    wait          = optional(bool, true)
    wait_for_jobs = optional(bool, true)
  })
  default = {}
}

variable "promtail" {
  type = object({
    enabled       = optional(bool, true)
    name          = optional(string, "promtail")
    repository    = optional(string, "https://grafana.github.io/helm-charts")
    chart         = optional(string, "promtail")
    version       = optional(string, "6.15.5")
    wait          = optional(bool, true)
    wait_for_jobs = optional(bool, true)
  })
  default = {}
}

variable "tls" {
  description = "Private Key Configuration"
  type = object({
    rsa = optional(object({
      algorithm = optional(string, "RSA")
      rsa_bits  = optional(number, 4096)
    }), {})
    ed25519 = optional(object({
      algorithm = optional(string, "ED25519")
    }), {})
    ecdsa_p384 = optional(object({
      algorithm   = optional(string, "ECDSA")
      ecdsa_curve = optional(string, "P384")
    }), {})
  })
  default = {}
}
