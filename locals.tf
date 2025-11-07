locals {
  # Environment-specific VPC configurations
  vpc_config = {
    dev = {
      vpc_cidr           = "10.0.0.0/16"
      public_subnet_cidr = "10.0.1.0/24"
    }
    staging = {
      vpc_cidr           = "10.1.0.0/16"
      public_subnet_cidr = "10.1.1.0/24"
    }
  }

  # Environment-specific instance configurations
  instance_config = {
    dev = {
      instance_type = "t2.micro"
    }
    staging = {
      instance_type = "t2.small"
    }
  }
}
