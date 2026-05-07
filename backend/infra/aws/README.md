# ☁️ AWS EC2 Module

## Owner

**Member 3**

## Goal

Create an EC2 instance on AWS and return its public IP address. This module is the bridge between AutoOps AI and AWS. It uses the boto3 SDK to launch EC2 instances with the configuration specified in the deployment plan. It also configures the security group to allow inbound traffic on port 5000 (Flask) and port 22 (SSH).

## Tools

- **boto3** — AWS SDK for Python

## Functions to Build

| Function              | Input                        | Output                              |
|-----------------------|------------------------------|--------------------------------------|
| `create_instance(plan)` | Plan dict from Planner     | `{ "instance_id": "...", "ip": "..." }` |
| `get_public_ip(instance_id)` | EC2 instance ID        | Public IP string                     |

## Input (from Executor Agent)

```json
{
  "app": "flask",
  "instance_type": "t2.micro",
  "region": "ap-south-1"
}
```

## Output

```json
{
  "instance_id": "i-0abc123def456",
  "ip": "54.xxx.xxx.xxx"
}
```

## Tasks for Member 3

1. Create a `create_instance(plan)` function that:
   - Reads AWS credentials from environment variables
   - Creates a boto3 EC2 client
   - Launches an EC2 instance with the specified instance type and AMI
   - Configures or attaches a security group allowing ports 22 (SSH) and 5000 (Flask)
   - Waits for the instance to be in "running" state
   - Returns the instance ID and public IP
2. Create a `get_public_ip(instance_id)` helper function
3. Handle errors: invalid credentials, instance launch failure, timeout
4. Log all AWS operations for debugging

## AWS Configuration

| Parameter         | Source              | Default            |
|-------------------|---------------------|--------------------|
| Access Key        | `AWS_ACCESS_KEY_ID` env var | —            |
| Secret Key        | `AWS_SECRET_ACCESS_KEY` env var | —        |
| Region            | Plan or env var     | `ap-south-1`       |
| AMI ID            | `EC2_AMI_ID` env var | Ubuntu 22.04 AMI  |
| Instance Type     | Plan                | `t2.micro`         |
| Key Pair          | `EC2_KEY_PAIR_NAME` env var | —            |
| Security Group    | `EC2_SECURITY_GROUP_ID` or create new | — |

## Security Group Rules

| Type     | Protocol | Port  | Source    | Purpose          |
|----------|----------|-------|-----------|------------------|
| Inbound  | TCP      | 22    | 0.0.0.0/0 | SSH access       |
| Inbound  | TCP      | 5000  | 0.0.0.0/0 | Flask app access |
| Outbound | All      | All   | 0.0.0.0/0 | Internet access  |
