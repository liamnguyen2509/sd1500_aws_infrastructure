module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "assignment-instance"

  instance_type          = "t2.micro"
  key_name               = module.key_pair.key_pair_name
  monitoring             = true
  vpc_security_group_ids = module.server_sg.security_group_id
  subnet_id              = element(module.vpc.public_subnets, 0)

  tags = var.tags
}

module "jenkins" {
  source              = "cn-terraform/jenkins/aws"
  name_prefix         = "jenkins"
  region              = var.region
  vpc_id              = module.vpc.vpc_id
  public_subnets_ids  = module.vpc.public_subnets
  private_subnets_ids = module.vpc.private_subnets
}