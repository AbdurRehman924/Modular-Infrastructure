# Modular Infrastructure

## Project Overview
Build and reuse Terraform modules for reproducible infrastructure. This project converts EC2 + VPC setup into reusable modules that can be deployed across different environments (dev, staging) with different parameters.

## Architecture & Service Connections

### How Services Work Together

**VPC Module Creates the Network Foundation:**
- **VPC** → Isolated network environment (10.0.0.0/16 for dev, 10.1.0.0/16 for staging)
- **Public Subnet** → Attached to VPC, enables internet access for resources
- **Internet Gateway** → Attached to VPC, provides internet connectivity
- **Route Table** → Routes traffic from subnet (0.0.0.0/0) to Internet Gateway
- **Route Table Association** → Links public subnet to route table
- **Security Groups** → Attached to VPC, act as virtual firewalls
  - Web SG: Allows HTTP (80) and HTTPS (443) inbound
  - SSH SG: Allows SSH (22) inbound

**EC2 Module Uses VPC Resources:**
- **Key Pair** → Created for SSH access to instance
- **AMI Data Source** → Finds latest Ubuntu 22.04 image
- **EC2 Instance** → Deployed into:
  - VPC subnet (from VPC module output)
  - Security groups (from VPC module outputs)
  - Uses key pair for SSH access
  - Runs user-data script on boot

**Root Configuration Orchestrates Everything:**
- Calls VPC module first (creates network)
- Passes VPC outputs to EC2 module inputs
- Uses locals for environment-specific configs
- Applies different settings per environment

### Data Flow:
```
Internet → Internet Gateway → Route Table → Public Subnet → EC2 Instance
                                                         ↑
                                              Security Groups filter traffic
```

### Module Dependencies:
```
VPC Module (independent) → outputs: vpc_id, subnet_id, security_group_ids
                          ↓
EC2 Module (dependent) ← inputs: subnet_id, security_group_ids
```

## Key Features
- ✅ Reusable modules for VPC and EC2
- ✅ Environment-specific configurations (dev/staging)
- ✅ DRY patterns using locals
- ✅ Variable validation
- ✅ Comprehensive outputs

## Prerequisites
- AWS CLI configured with appropriate credentials
- SSH key pair generated (`ssh-keygen -t rsa -b 2048 -f ~/.ssh/main-key`)
- Terraform installed (>= 1.0)

## Usage

### Deploy Development Environment
```bash
terraform init
terraform plan -var-file="terraform.tfvars.dev"
terraform apply -var-file="terraform.tfvars.dev"
```

### Deploy Staging Environment
```bash
terraform plan -var-file="terraform.tfvars.staging"
terraform apply -var-file="terraform.tfvars.staging"
```

## Environment Differences
- **Dev**: t2.micro instance, 10.0.0.0/16 VPC CIDR
- **Staging**: t2.small instance, 10.1.0.0/16 VPC CIDR

## Module Structure
```
modules/
├── vpc/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── ec2/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

## Testing
After deployment, test the infrastructure:
```bash
# Get the public IP from outputs
terraform output instance_public_ip

# Test web server
curl http://<public_ip>

# SSH into instance
ssh -i ~/.ssh/main-key ubuntu@<public_ip>
```

## Cleanup
```bash
terraform destroy -var-file="terraform.tfvars.dev"
terraform destroy -var-file="terraform.tfvars.staging"
```
