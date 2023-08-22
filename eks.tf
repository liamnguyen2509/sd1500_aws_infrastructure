module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  create                         = true
  cluster_name                   = var.cluster_name
  cluster_version                = "1.27"
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.public_subnets
  cluster_endpoint_public_access   = true
  attach_cluster_encryption_policy = false
  cluster_encryption_config        = {}
  create_cloudwatch_log_group      = false

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  one = {
    name         = "mixed-1"
    max_size     = 5
    desired_size = 2

    use_mixed_instances_policy = true
    mixed_instances_policy = {
      instances_distribution = {
        on_demand_base_capacity                  = 0
        on_demand_percentage_above_base_capacity = 10
        spot_allocation_strategy                 = "capacity-optimized"
      }

      override = [
        {
          instance_type     = "t3a.micro"
          weighted_capacity = "1"
        },
        {
          instance_type     = "t3a.medium"
          weighted_capacity = "2"
        },
        {
          instance_type     = "t3a.large"
          weighted_capacity = "3"
        },
      ]
    }
  }
}