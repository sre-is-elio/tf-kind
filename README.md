# Terraform KinD Local Deployment

## KinD Cluster Creation

```bash
kind create cluster --name dev --config kind.yaml
```

## GO Template Command

### Getting Kubernetes Configuration

```bash
kubectl config view --minify --flatten -o go-template-file=tfvars.gotemplate > terraform.auto.tfvars
```

### Getting Kubernetes Configuration with Context

```bash
kubectl config view --minify --flatten --context=kind-dev -o go-template-file=tfvars.gotemplate > terraform.auto.tfvars
```

## Manual Open Telemetry Helm Chart Installation

```bash
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
```

```bash
helm upgrade --install --wait opentelemetry-operator open-telemetry/opentelemetry-operator --set "manager.collectorImage.repository=otel/opentelemetry-collector-k8s" --set admissionWebhooks.certManager.enabled=true --set nameOverride=dev-otel-operator --set fullnameOverride=dev-otel-operator -n monitoring

helm upgrade --install --wait opentelemetry-collector open-telemetry/opentelemetry-collector --set image.repository="otel/opentelemetry-collector-k8s" --set mode=statefulset --set nameOverride=dev-otel-collector --set fullnameOverride=dev-otel-collector -n monitoring
```

## Ingress-Nginx Installation

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
```

### Installing application sample

```bash
kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/usage.yaml
```

## Terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.4 |
| <a name="requirement_http"></a> [http](#requirement\_http) | >= 2.0 |
| <a name="requirement_kind"></a> [kind](#requirement\_kind) | >= 0.2.1 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0 |
| <a name="requirement_shell"></a> [shell](#requirement\_shell) | >= 1.7.10 |
| <a name="requirement_strcase"></a> [strcase](#requirement\_strcase) | >= 1.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.0 |

## Resources

| Name | Type |
|------|------|
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.grafana](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.loki](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.metrics_server](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.open_telemetry_collector](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.open_telemetry_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.prometheus_stack](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.promtail](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kind_cluster.default](https://registry.terraform.io/providers/tehcyx/kind/latest/docs/resources/cluster) | resource |
| [kubernetes_namespace.cert_manager](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.metrics_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.monitoring](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_network_policy.metrics_server_allow_control_plane](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/network_policy) | resource |
| [kubernetes_network_policy.metrics_server_allow_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/network_policy) | resource |
| [kubernetes_network_policy.metrics_server_default_deny](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/network_policy) | resource |
| [kubernetes_priority_class.kubernetes_addons](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/priority_class) | resource |
| [kubernetes_priority_class.kubernetes_addons_ds](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/priority_class) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [strcase_strcase.application](https://registry.terraform.io/providers/elioseverojunior/strcase/latest/docs/data-sources/strcase) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_actions_runner_controller"></a> [actions\_runner\_controller](#input\_actions\_runner\_controller) | Helm GitHub Actions Runner Controller Configuration | <pre>object({<br>    enabled                    = optional(bool, true)<br>    enable_ha                  = optional(bool, false)<br>    atomic                     = optional(bool, false)<br>    chart                      = optional(string, "actions-runner-controller")<br>    cleanup_on_fail            = optional(bool, false)<br>    create_namespace           = optional(bool, true)<br>    dependency_update          = optional(bool, false)<br>    disable_crd_hooks          = optional(bool, false)<br>    disable_openapi_validation = optional(bool, false)<br>    disable_webhooks           = optional(bool, false)<br>    force_update               = optional(bool, false)<br>    lint                       = optional(bool, false)<br>    max_history                = optional(string, 30)<br>    name                       = optional(string, "actions-runner-controller")<br>    namespace                  = optional(string, "tools")<br>    pass_credentials           = optional(bool, false)<br>    recreate_pods              = optional(bool, false)<br>    render_subchart_notes      = optional(bool, true)<br>    replace                    = optional(bool, false)<br>    repository                 = optional(string, "https://actions-runner-controller.github.io/actions-runner-controller")<br>    reset_values               = optional(bool, false)<br>    reuse_values               = optional(bool, false)<br>    skip_crds                  = optional(bool, false)<br>    timeout                    = optional(number, 300)<br>    verify                     = optional(bool, false)<br>    version                    = optional(string, "0.23.7")<br>    wait                       = optional(bool, true)<br>    wait_for_jobs              = optional(bool, false)<br>    sets = optional(map(object({<br>      name  = string<br>      value = string<br>    })), {})<br>    set_sensitives = optional(map(object({<br>      name  = string<br>      value = string<br>    })), {})<br>    set_strings = optional(map(object({<br>      name  = string<br>      value = string<br>    })), {})<br>  })</pre> | `{}` | no |
| <a name="input_actions_runner_controller_provisioner"></a> [actions\_runner\_controller\_provisioner](#input\_actions\_runner\_controller\_provisioner) | Helm GitHub Actions Runner Controller Provisioner Configuration | <pre>object({<br>    enabled                    = optional(bool, true)<br>    enable_ha                  = optional(bool, false)<br>    atomic                     = optional(bool, false)<br>    chart                      = optional(string, "charts/actions-runner-controller-provisioner")<br>    cleanup_on_fail            = optional(bool, false)<br>    create_namespace           = optional(bool, true)<br>    dependency_update          = optional(bool, false)<br>    disable_crd_hooks          = optional(bool, false)<br>    disable_openapi_validation = optional(bool, false)<br>    disable_webhooks           = optional(bool, false)<br>    force_update               = optional(bool, false)<br>    lint                       = optional(bool, false)<br>    max_history                = optional(string, 30)<br>    name                       = optional(string, "arc-runner")<br>    namespace                  = optional(string, "tools")<br>    pass_credentials           = optional(bool, false)<br>    recreate_pods              = optional(bool, false)<br>    render_subchart_notes      = optional(bool, true)<br>    replace                    = optional(bool, false)<br>    repository                 = optional(string, "")<br>    reset_values               = optional(bool, false)<br>    reuse_values               = optional(bool, false)<br>    skip_crds                  = optional(bool, false)<br>    timeout                    = optional(number, 300)<br>    verify                     = optional(bool, false)<br>    version                    = optional(string, "0.1.0")<br>    wait                       = optional(bool, true)<br>    wait_for_jobs              = optional(bool, false)<br>    sets = optional(map(object({<br>      name  = string<br>      value = string<br>    })), {})<br>    set_sensitives = optional(map(object({<br>      name  = string<br>      value = string<br>    })), {})<br>    set_strings = optional(map(object({<br>      name  = string<br>      value = string<br>    })), {})<br>  })</pre> | `{}` | no |
| <a name="input_application"></a> [application](#input\_application) | Application Name | `string` | `"dev"` | no |
| <a name="input_cert_manager"></a> [cert\_manager](#input\_cert\_manager) | Cert Mananger Helm Chart Configuration | <pre>object({<br>    enabled                    = optional(bool, true)<br>    atomic                     = optional(bool, false)<br>    chart                      = optional(string, "cert-manager")<br>    cleanup_on_fail            = optional(bool, false)<br>    create_namespace           = optional(bool, false)<br>    dependency_update          = optional(bool, false)<br>    disable_crd_hooks          = optional(bool, false)<br>    disable_openapi_validation = optional(bool, false)<br>    disable_webhooks           = optional(bool, false)<br>    force_update               = optional(bool, false)<br>    lint                       = optional(bool, false)<br>    max_history                = optional(string, 30)<br>    name                       = optional(string, "cert-manager")<br>    namespace                  = optional(string, "cert-manager")<br>    pass_credentials           = optional(bool, false)<br>    recreate_pods              = optional(bool, false)<br>    render_subchart_notes      = optional(bool, true)<br>    replace                    = optional(bool, false)<br>    repository                 = optional(string, "https://charts.jetstack.io")<br>    reset_values               = optional(bool, false)<br>    reuse_values               = optional(bool, false)<br>    skip_crds                  = optional(bool, false)<br>    tag                        = optional(string, null)<br>    timeout                    = optional(number, 300)<br>    verify                     = optional(bool, false)<br>    version                    = optional(string, "1.14.5")<br>    wait                       = optional(bool, true)<br>    wait_for_jobs              = optional(bool, false)<br>    sets = optional(map(object({<br>      name  = string<br>      value = string<br>      })), {<br>      "installCRDs" = {<br>        name  = "installCRDs"<br>        value = true<br>      }<br>    })<br>    set_sensitives = optional(map(object({<br>      name  = string<br>      value = string<br>    })), {})<br>    set_strings = optional(map(object({<br>      name  = string<br>      value = string<br>    })), {})<br>  })</pre> | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment Name. Which runtime owns the resource? This is used for cost analysis and support. | `string` | `"dev"` | no |
| <a name="input_grafana"></a> [grafana](#input\_grafana) | n/a | <pre>object({<br>    enabled       = optional(bool, true)<br>    name          = optional(string, "grafana")<br>    repository    = optional(string, "https://grafana.github.io/helm-charts")<br>    chart         = optional(string, "grafana")<br>    version       = optional(string, "7.3.11")<br>    wait          = optional(bool, true)<br>    wait_for_jobs = optional(bool, true)<br>  })</pre> | `{}` | no |
| <a name="input_jenkins"></a> [jenkins](#input\_jenkins) | Helm Jenkins Configuration | <pre>object({<br>    enabled                    = optional(bool, true)<br>    atomic                     = optional(bool, false)<br>    chart                      = optional(string, "jenkins")<br>    cleanup_on_fail            = optional(bool, false)<br>    create_namespace           = optional(bool, true)<br>    dependency_update          = optional(bool, false)<br>    disable_crd_hooks          = optional(bool, false)<br>    disable_openapi_validation = optional(bool, false)<br>    disable_webhooks           = optional(bool, false)<br>    force_update               = optional(bool, false)<br>    lint                       = optional(bool, false)<br>    max_history                = optional(string, 30)<br>    name                       = optional(string, "jenkins")<br>    namespace                  = optional(string, "tools")<br>    pass_credentials           = optional(bool, false)<br>    recreate_pods              = optional(bool, false)<br>    render_subchart_notes      = optional(bool, true)<br>    replace                    = optional(bool, false)<br>    repository                 = optional(string, "https://charts.jenkins.io")<br>    reset_values               = optional(bool, false)<br>    reuse_values               = optional(bool, false)<br>    skip_crds                  = optional(bool, false)<br>    tag                        = optional(string, "jdk17")<br>    timeout                    = optional(number, 1000)<br>    use_efs_volume             = optional(bool, true)<br>    verify                     = optional(bool, false)<br>    version                    = optional(string, "5.1.1")<br>    wait                       = optional(bool, true)<br>    wait_for_jobs              = optional(bool, false)<br>    sets = optional(map(object({<br>      name  = string<br>      value = string<br>    })), {})<br>    set_sensitives = optional(map(object({<br>      name  = string<br>      value = string<br>    })), {})<br>    set_strings = optional(map(object({<br>      name  = string<br>      value = string<br>    })), {})<br>  })</pre> | `{}` | no |
| <a name="input_loki"></a> [loki](#input\_loki) | n/a | <pre>object({<br>    enabled       = optional(bool, true)<br>    name          = optional(string, "loki")<br>    repository    = optional(string, "https://grafana.github.io/helm-charts")<br>    chart         = optional(string, "loki")<br>    version       = optional(string, "6.5.2")<br>    wait          = optional(bool, true)<br>    wait_for_jobs = optional(bool, true)<br>  })</pre> | `{}` | no |
| <a name="input_market"></a> [market](#input\_market) | Market Name. Which market owns the resource? This is used for cost analysis and support. | `string` | `"us"` | no |
| <a name="input_metrics_server"></a> [metrics\_server](#input\_metrics\_server) | Helm Metrics Server Configuration | <pre>object({<br>    enabled                    = optional(bool, true)<br>    allowed_cidrs              = optional(list(string), ["0.0.0.0/0"])<br>    atomic                     = optional(bool, false)<br>    chart                      = optional(string, "metrics-server")<br>    cleanup_on_fail            = optional(bool, false)<br>    create_namespace           = optional(bool, true)<br>    default_network_policy     = optional(bool, true)<br>    dependency_update          = optional(bool, false)<br>    disable_crd_hooks          = optional(bool, false)<br>    disable_openapi_validation = optional(bool, false)<br>    disable_webhooks           = optional(bool, false)<br>    extra_values               = optional(string, "")<br>    force_update               = optional(bool, false)<br>    lint                       = optional(bool, false)<br>    max_history                = optional(string, 30)<br>    name                       = optional(string, "metrics-server")<br>    namespace                  = optional(string, "kube-system")<br>    pass_credentials           = optional(bool, false)<br>    recreate_pods              = optional(bool, false)<br>    render_subchart_notes      = optional(bool, true)<br>    replace                    = optional(bool, false)<br>    repository                 = optional(string, "https://kubernetes-sigs.github.io/metrics-server")<br>    reset_values               = optional(bool, false)<br>    reuse_values               = optional(bool, false)<br>    skip_crds                  = optional(bool, false)<br>    timeout                    = optional(number, 1800)<br>    verify                     = optional(bool, false)<br>    version                    = optional(string, "3.12.1")<br>    wait                       = optional(bool, true)<br>    wait_for_jobs              = optional(bool, false)<br>    sets = optional(map(object({<br>      name  = string<br>      value = string<br>    })), {})<br>    set_sensitives = optional(map(object({<br>      name  = string<br>      value = string<br>    })), {})<br>    set_strings = optional(map(object({<br>      name  = string<br>      value = string<br>    })), {})<br>  })</pre> | `{}` | no |
| <a name="input_priority_class"></a> [priority\_class](#input\_priority\_class) | Customize a priority class for addons | <pre>object({<br>    create = optional(bool, true)<br>    name   = optional(string, "kubernetes-addons")<br>    value  = optional(string, "9000")<br>  })</pre> | `{}` | no |
| <a name="input_priority_class_ds"></a> [priority\_class\_ds](#input\_priority\_class\_ds) | Customize a priority class for addons daemonsets | <pre>object({<br>    create = optional(bool, true)<br>    name   = optional(string, "kubernetes-addons-ds")<br>    value  = optional(string, "10000")<br>  })</pre> | `{}` | no |
| <a name="input_prometheus_stack"></a> [prometheus\_stack](#input\_prometheus\_stack) | n/a | <pre>object({<br>    enabled       = optional(bool, true)<br>    name          = optional(string, "kube-prometheus-stack")<br>    repository    = optional(string, "https://prometheus-community.github.io/helm-charts")<br>    chart         = optional(string, "kube-prometheus-stack")<br>    version       = optional(string, "58.6.0")<br>    wait          = optional(bool, true)<br>    wait_for_jobs = optional(bool, true)<br>  })</pre> | `{}` | no |
| <a name="input_promtail"></a> [promtail](#input\_promtail) | n/a | <pre>object({<br>    enabled       = optional(bool, true)<br>    name          = optional(string, "promtail")<br>    repository    = optional(string, "https://grafana.github.io/helm-charts")<br>    chart         = optional(string, "promtail")<br>    version       = optional(string, "6.15.5")<br>    wait          = optional(bool, true)<br>    wait_for_jobs = optional(bool, true)<br>  })</pre> | `{}` | no |
| <a name="input_random_password"></a> [random\_password](#input\_random\_password) | Jenkins Random Password | <pre>object({<br>    length           = optional(number, 50)<br>    min_numeric      = optional(number, 10)<br>    min_special      = optional(number, 10)<br>    min_upper        = optional(number, 10)<br>    min_lower        = optional(number, 20)<br>    special          = optional(bool, true)<br>    override_special = optional(string, "!#$%&*()-_=+[]{}<>:?Çç")<br>  })</pre> | `{}` | no |
| <a name="input_tls"></a> [tls](#input\_tls) | Private Key Configuration | <pre>object({<br>    rsa = optional(object({<br>      algorithm = optional(string, "RSA")<br>      rsa_bits  = optional(number, 4096)<br>    }), {})<br>    ed25519 = optional(object({<br>      algorithm = optional(string, "ED25519")<br>    }), {})<br>    ecdsa_p384 = optional(object({<br>      algorithm   = optional(string, "ECDSA")<br>      ecdsa_curve = optional(string, "P384")<br>    }), {})<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kind_cluster"></a> [kind\_cluster](#output\_kind\_cluster) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
