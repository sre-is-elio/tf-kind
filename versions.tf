terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4"
    }
    http = {
      source  = "terraform-aws-modules/http"
      version = ">= 2.0"
    }
    kind = {
      source  = "tehcyx/kind"
      version = ">= 0.2.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
    shell = {
      source  = "scottwinkler/shell"
      version = ">= 1.7.10"
    }
    strcase = {
      source  = "elioseverojunior/strcase"
      version = ">= 1.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.0"
    }
  }
}
