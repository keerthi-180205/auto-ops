# 🏗️ Infrastructure (Terraform)

## Owner

**Member 3** (Optional for Phase 1)

## Purpose

This directory contains Terraform configurations for provisioning AWS infrastructure as code. In Phase 1, the primary EC2 creation is done via boto3 in `backend/infra/aws/ec2.py`. Terraform is provided here as an optional, more production-grade alternative for infrastructure provisioning.

## Directory Structure

```
infrastructure/
├── README.md
└── terraform/
    └── ec2_basic/
        ├── main.tf          # EC2 instance + security group resource definitions
        ├── variables.tf     # Input variables (instance_type, ami_id, region, etc.)
        └── outputs.tf       # Output values (instance_id, public_ip, public_dns)
```

## Usage

```bash
cd infrastructure/terraform/ec2_basic

# Initialize Terraform
terraform init

# Preview changes
terraform plan -var-file="terraform.tfvars"

# Apply (create EC2 instance)
terraform apply -var-file="terraform.tfvars"

# Destroy (tear down)
terraform destroy -var-file="terraform.tfvars"
```

## Variables

| Variable         | Type   | Default       | Description              |
|------------------|--------|---------------|--------------------------|
| `instance_type`  | string | `t2.micro`    | EC2 instance type        |
| `ami_id`         | string | —             | Ubuntu 22.04 AMI ID      |
| `region`         | string | `ap-south-1`  | AWS region               |
| `key_name`       | string | —             | SSH key pair name        |

## Outputs

| Output           | Description                    |
|------------------|--------------------------------|
| `instance_id`    | The EC2 instance ID            |
| `public_ip`      | The public IPv4 address        |
| `public_dns`     | The public DNS name            |

## Phase 1 vs Phase 2

- **Phase 1**: EC2 creation via boto3 (simpler, faster to build)
- **Phase 2**: Migrate to Terraform for all infrastructure (more robust, state management, team collaboration)
