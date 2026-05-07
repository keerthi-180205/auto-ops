# 🚀 Flask Deployment Module

## Owner

**Member 3**

## Goal

Deploy a Flask application on an EC2 instance by SSHing into the instance, installing Python and Flask dependencies, and starting the Flask server. This module is called by the Executor Agent after the EC2 instance has been created and is in the "running" state.

## Steps

1. SSH into the EC2 instance using Paramiko
2. Update system packages (`apt update`)
3. Install Python 3 and pip
4. Install Flask (`pip install flask`)
5. Create a simple Flask app file (or upload one)
6. Run the Flask app on `0.0.0.0:5000`

## Tools

- **Paramiko** — SSH client library for Python

## Input (from Executor Agent)

- `ip` — Public IP address of the EC2 instance
- `key_path` — Path to the SSH private key (.pem file)
- `username` — SSH username (default: `ubuntu`)

## Output

Running Flask app accessible at `http://<ip>:5000`

## File

| File                 | Purpose                                     |
|----------------------|---------------------------------------------|
| `flask_deployer.py`  | `deploy_flask(ip)` function via SSH         |

## Example Logic

```python
# flask_deployer.py (pseudocode)
import paramiko

def deploy_flask(ip: str, key_path: str, username: str = "ubuntu"):
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(ip, username=username, key_filename=key_path)

    commands = [
        "sudo apt update -y",
        "sudo apt install python3 python3-pip -y",
        "pip3 install flask",
        "echo 'from flask import Flask; app = Flask(__name__); @app.route(\"/\") ...' > app.py",
        "nohup python3 app.py &"
    ]

    for cmd in commands:
        stdin, stdout, stderr = ssh.exec_command(cmd)
        stdout.channel.recv_exit_status()  # Wait for completion

    ssh.close()
```

## Tasks for Member 3

1. Create a `deploy_flask(ip, key_path, username)` function
2. SSH into the instance using Paramiko
3. Run setup commands (install Python, pip, Flask)
4. Create or upload a Flask application file
5. Start the Flask server in the background (use `nohup` or `screen`)
6. Verify the app is running (optional: check port 5000)
7. Handle SSH errors: connection timeout, command failure, key issues

## Important Notes

- Wait for the EC2 instance to be fully initialized before SSHing (may need a 30-60 second delay)
- Flask must bind to `0.0.0.0` (not `127.0.0.1`) to be accessible from outside
- Use port `5000` by default
- The SSH key (.pem file) path is loaded from the `SSH_KEY_PATH` environment variable
