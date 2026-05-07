# 📜 Scripts

## Owner

**Member 3**

## Purpose

Shell scripts for deployment automation and development environment setup. These scripts can be executed manually or called by the deployment modules to set up the Flask application on EC2 instances.

## Files

| Script             | Purpose                                           |
|--------------------|---------------------------------------------------|
| `deploy_flask.sh`  | Runs on EC2 to install dependencies and start Flask app |
| `setup.sh`         | Local development environment setup script         |

## deploy_flask.sh

This script is designed to run on the EC2 instance (either via SSH or as user_data). It performs the following steps:

1. Update system packages (`apt update`)
2. Install Python 3 and pip
3. Install Flask via pip
4. Create a basic Flask app (or clone from repo)
5. Start the Flask server on `0.0.0.0:5000`

```bash
# Usage (on EC2 instance):
chmod +x deploy_flask.sh
./deploy_flask.sh
```

## setup.sh

Local development setup script that:

1. Creates Python virtual environment
2. Installs dependencies from requirements.txt
3. Copies .env.example to .env
4. Prints setup instructions

```bash
# Usage (on local machine):
chmod +x scripts/setup.sh
./scripts/setup.sh
```
