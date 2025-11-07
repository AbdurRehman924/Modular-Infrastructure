variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging)"
  type        = string
  validation {
    condition     = contains(["dev", "staging"], var.environment)
    error_message = "Environment must be either 'dev' or 'staging'."
  }
}

variable "availability_zone" {
  description = "Availability zone for resources"
  type        = string
  default     = "us-east-1a"
}

variable "key_name" {
  description = "Name of SSH key (without .pub extension)"
  type        = string
  default     = "main-key"
}
