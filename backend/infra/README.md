# 🏗️ Infrastructure Layer

## Owner

**Member 3**

## Responsibility

The Infrastructure layer handles all AWS operations and application deployment. It provides the low-level modules that the Executor Agent calls to provision cloud resources and deploy applications. This layer contains two sub-modules: `aws/` for EC2 instance creation via boto3, and `deploy/` for Flask application deployment via SSH (Paramiko). Member 3 is the sole owner of this layer — no other member should write AWS or deployment code.

## Modules

| Module                | Purpose                          | File                  |
|-----------------------|----------------------------------|-----------------------|
| **AWS EC2**           | Create EC2 instance via boto3    | `aws/ec2.py`          |
| **Flask Deployment**  | Deploy Flask app via SSH         | `deploy/flask_deployer.py` |

## Directory Structure

```
infra/
├── README.md
├── aws/
│   ├── README.md
│   └── ec2.py              # EC2 creation: create_instance(), get_public_ip()
└── deploy/
    ├── README.md
    └── flask_deployer.py   # SSH into EC2 + install Python + deploy Flask
```

## Flow

```
Executor Agent calls:
    ↓
1. infra/aws/ec2.py → create_instance(plan)
   → Launches EC2, configures security group, returns instance_id + public_ip
    ↓
2. infra/deploy/flask_deployer.py → deploy_flask(ip)
   → SSH into EC2, install Python/pip, install Flask, start app
    ↓
3. Flask app running on public IP:5000
```

## Tasks for Member 3

1. Build `ec2.py` — create EC2 instances using boto3
2. Build `flask_deployer.py` — deploy Flask via SSH using Paramiko
3. Ensure both modules expose clean function interfaces for the Executor Agent
4. Handle AWS errors (instance launch failure, timeout, etc.)
5. Handle SSH errors (connection refused, command failure, etc.)

## Do NOT

- ❌ Handle API requests (that's Member 1's job)
- ❌ Write agent logic (that's Member 2's job)
- ❌ Parse user prompts
