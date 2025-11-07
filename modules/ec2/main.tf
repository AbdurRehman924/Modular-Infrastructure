# Key Pair
resource "aws_key_pair" "main" {
  key_name   = "${var.environment}-${var.key_name}"
  public_key = file(pathexpand("~/.ssh/${var.key_name}.pub"))

  tags = {
    Name        = "${var.environment}-${var.key_name}-key"
    Environment = var.environment
  }
}

# Latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Instance
resource "aws_instance" "main" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.main.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  associate_public_ip_address = true
  user_data                   = var.user_data

  tags = {
    Name        = "${var.environment}-${var.instance_name}"
    Environment = var.environment
    Type        = "web-server"
  }
}
