# Resource
terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.22.0"
    }
  }
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
}

# Provider
provider "aws" {
  region     = var.region
  access_key = "AKIAVPVVBN5J6DYG766X"
  secret_key = "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"
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

# Data source
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}