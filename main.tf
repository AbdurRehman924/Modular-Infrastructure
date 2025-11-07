terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  environment          = var.environment
  vpc_cidr            = local.vpc_config[var.environment].vpc_cidr
  public_subnet_cidr  = local.vpc_config[var.environment].public_subnet_cidr
  availability_zone   = var.availability_zone
}

# EC2 Module
module "ec2" {
  source = "./modules/ec2"

  environment        = var.environment
  instance_type     = local.instance_config[var.environment].instance_type
  instance_name     = "web-server"
  key_name          = var.key_name
  subnet_id         = module.vpc.public_subnet_id
  security_group_ids = [
    module.vpc.web_security_group_id,
    module.vpc.ssh_security_group_id
  ]
  user_data = file("${path.module}/user-data.sh")
}
