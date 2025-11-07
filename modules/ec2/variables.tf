variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name for the EC2 instance"
  type        = string
  default     = "web-server"
}

variable "key_name" {
  description = "Name of SSH key (without .pub extension)"
  type        = string
}

variable "subnet_id" {
  description = "ID of subnet to launch instance in"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "user_data" {
  description = "User data script for instance"
  type        = string
  default     = ""
}
