module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "assignment-instance"
  
  ami                    = "ami-091a58610910a87a9"
  associate_public_ip_address = true
  instance_type          = "t2.micro"
  key_name               = module.key_pair.key_pair_name
  monitoring             = true
  vpc_security_group_ids = [module.server_sg.security_group_id]
  subnet_id              = element(module.vpc.public_subnets, 0)
  tags = var.tags
  
  user_data = <<EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install wget
    sudo amazon-linux-extras install java-openjdk11
    sudo amazon-linux-extras install epel -y
    sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    sudo yum install jenkins -y
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
    sudo systemctl status jenkins
  EOF
}