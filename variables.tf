variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "cluster_name" {
  type    = string
  default = "assignment-eks-cluster"
}

variable "tags" {
  type = map(string)
  default = {
    "Terraform"   = "true"
    "Environment" = "dev"
  }
}
