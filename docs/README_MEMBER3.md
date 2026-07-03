# AutoOps AI — Member 3 Guide

---

## ⚡ How to Use This With an AI Assistant

> **Your teammate instructions — do this before anything else:**
>
> 1. Open this file in VS Code
> 2. Select All (`Ctrl+A`) → Copy (`Ctrl+C`)
> 3. Open your AI assistant (Cursor, Copilot Chat, Claude, ChatGPT, etc.)
> 4. Paste the entire file as your first message
> 5. Then type one of these trigger prompts:
>
> | What you want to do | What to type |
> |---------------------|--------------|
> | Start Task 1 (SSH Deployer) | `"Start Task 1 — implement agents/ssh/deployer.py"` |
> | Start Task 2 (Resource Predictor ML) | `"Start Task 2 — implement orchestrator/resource_predictor.py"` |
> | Start Task 3 (Test Suite) | `"Start Task 3 — implement tests/ for [planner/executor/pipeline]"` |
>
> The AI will open the correct file and start implementing immediately.

---

## 🤖 AI System Context (Read This If You Are an AI Assistant)

You are an AI coding assistant working on **AutoOps AI** — an ML-powered DevOps system that converts natural language instructions into real AWS EC2 deployments.

**Your job:** You are implementing **Member 3's tasks** in the project located at `/home/keerthi-180205/Auto-Ops/`.

**Rules you must follow:**
- Only edit the files listed under "Your Files" below — nothing else
- Match function signatures EXACTLY as specified — Member 1's Orchestrator calls `SSHDeployer.deploy()` and `ResourcePredictor.recommend()` directly
- For SSH: never skip the `disconnect()` call — always close connections after use
- For tests: unit tests must NEVER make real AWS calls — use mocked return values for those
- Mark any test needing real AWS with `@pytest.mark.integration`
- Mark any test needing a trained model with `@pytest.mark.requires_model`
- After implementing each task, run the verification commands at the bottom of this file
- When done with a task, mark it ✅ in `PROGRESS.md`

---

## Your Role
You own the **SSH Agent** (Paramiko deployment), the **Resource Predictor ML model** (your ML contribution), and the **entire test suite**. You have 3 deliverables: engineering + ML + testing.

---

## Your Files (ONLY edit these)
```
agents/ssh/deployer.py                  ← SSH connection + app deployment
orchestrator/resource_predictor.py      ← ML model: recommends optimal instance type
tests/test_planner.py                   ← Unit tests for Member 1's code
tests/test_executor.py                  ← Unit tests for Member 2's code
tests/test_pipeline.py                  ← Integration tests
```

---

## 📊 Seed Dataset — Your Contribution (Week 1)
**File:** `data/seed/seed_dataset_template.csv`

The seed dataset already has **~200 rows** generated. Your job is to **add 50 more rows** focused on the `restart_service` intent — the one most relevant to SSH/service management work.

### Use This AI Prompt to Generate Your Rows:
> Copy the prompt below → paste into any AI chat → copy the output → append to `data/seed/seed_dataset_template.csv`

```
Generate 50 diverse natural language instructions for a DevOps AI system.
Focus on the intent: restart_service (all 50 rows).

Rules:
- Vary the phrasing: restart/reboot/reload/cycle/bounce/reset/refresh/force restart
- Always include a realistic fake instance ID like i-0abc1234567890abc
- Vary the service/app: nginx, apache, flask, nodejs
- Some rows should NOT specify the service (just "restart the server/app/process on i-xxxx")
- Make some polite ("Please restart...", "Can you reload..."), some direct ("Restart nginx on i-xxxx"), some urgent ("Immediately reboot...")

Output strictly as CSV rows with this format (no header):
"instruction",intent,instance_type,region,app,port,count,notes
(leave instance_type/region/port/count empty — use commas as placeholders)
Example: "Restart nginx on instance i-0abc1234567890abc",restart_service,,,,nginx,,""
```

---

## Initial Setup (Do This First)
```bash
bash scripts/setup_env.sh
source venv/bin/activate
# Make sure you have a .pem key file for SSH access to EC2
# Set EC2_KEY_PATH in your .env
```

---

## Task 1 — SSH Deployer (Week 2 mocked → Week 3-4 real)
**File:** `agents/ssh/deployer.py`

### Exact Class Interface Required
```python
import paramiko
import os
from dotenv import load_dotenv

load_dotenv()

class SSHDeployer:
    def __init__(self):
        self.client = None

    def connect(self, host: str, username: str = "ec2-user", key_path: str = None) -> None:
        # Establish SSH connection using Paramiko
        # key_path defaults to EC2_KEY_PATH from .env
        # Sets self.client = paramiko.SSHClient()

    def run_command(self, command: str) -> tuple:
        # Run a shell command on the remote host
        # Returns: (stdout: str, stderr: str)
        # Raises: RuntimeError if not connected

    def deploy(self, plan: dict, host: str) -> dict:
        # Full deployment sequence:
        # 1. connect(host)
        # 2. run_command(install_cmd for plan["app"])
        # 3. run_command(start_cmd for plan["app"])
        # 4. disconnect()
        # Returns: {"success": True, "logs": "...", "error": None}
        # See CONTRACTS.md Section 4 for exact return shape

    def disconnect(self) -> None:
        # Close SSH connection if open
```

### Install & Start Commands by App
```python
APP_COMMANDS = {
    "nginx": {
        "install": "sudo yum install -y nginx",
        "start": "sudo systemctl start nginx && sudo systemctl enable nginx"
    },
    "apache": {
        "install": "sudo yum install -y httpd",
        "start": "sudo systemctl start httpd && sudo systemctl enable httpd"
    },
    "flask": {
        "install": "sudo yum install -y python3 pip && pip install flask",
        "start": "nohup python3 app.py &"
    },
    "nodejs": {
        "install": "curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash - && sudo yum install -y nodejs",
        "start": "nohup node app.js &"
    }
}
```

### Week 2 — Mocked Implementation
```python
def connect(self, host, username="ec2-user", key_path=None):
    print(f"[MOCK] SSH connect to {host}")
    self.client = "MOCKED"

def deploy(self, plan, host):
    return {
        "success": True,
        "logs": f"[MOCK] {plan['app']} deployed on {host}:{plan['port']}",
        "error": None
    }
```

### Week 3-4 — Real Paramiko Implementation
```python
def connect(self, host, username="ec2-user", key_path=None):
    key_path = key_path or os.getenv("EC2_KEY_PATH")
    self.client = paramiko.SSHClient()
    self.client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    pkey = paramiko.RSAKey.from_private_key_file(key_path)
    self.client.connect(hostname=host, username=username, pkey=pkey, timeout=30)

def run_command(self, command):
    if not self.client:
        raise RuntimeError("Not connected. Call connect() first.")
    stdin, stdout, stderr = self.client.exec_command(command)
    return stdout.read().decode(), stderr.read().decode()
```

---

## Task 2 — Resource Predictor ML (Week 3-4)
**File:** `orchestrator/resource_predictor.py`

This is your **ML contribution** — a model that recommends the optimal EC2 instance type based on the app type and expected load.

### Exact Class Interface Required
```python
import joblib

class ResourcePredictor:
    def __init__(self):
        self.model = None

    def recommend(self, app_type: str, expected_users: int = 10) -> dict:
        # Returns:
        # {
        #   "recommended_instance": "t2.micro",
        #   "estimated_cost_per_hour": 0.0116
        # }

    def train(self, X_train: list, y_train: list) -> dict:
        # X_train: feature vectors (app_type encoded, expected_users)
        # y_train: instance type labels
        # Returns: {"accuracy": float}

    def save(self, path: str = "models/resource_predictor.pkl") -> None:
        # Save with joblib

    def load(self, path: str = "models/resource_predictor.pkl") -> None:
        # Load with joblib
```

### Week 3 — Rule-Based Lookup Table (Start Here)
```python
INSTANCE_RULES = {
    "nginx":   {"max_users": 500,  "instance": "t2.micro",  "cost": 0.0116},
    "apache":  {"max_users": 400,  "instance": "t2.micro",  "cost": 0.0116},
    "flask":   {"max_users": 200,  "instance": "t2.micro",  "cost": 0.0116},
    "nodejs":  {"max_users": 1000, "instance": "t3.small",  "cost": 0.0208},
    "default": {"max_users": 100,  "instance": "t2.nano",   "cost": 0.0058},
}

def recommend(self, app_type: str, expected_users: int = 10) -> dict:
    rule = INSTANCE_RULES.get(app_type, INSTANCE_RULES["default"])
    # Upgrade instance if expected_users exceeds rule threshold
    if expected_users > rule["max_users"]:
        return {"recommended_instance": "t3.medium", "estimated_cost_per_hour": 0.0416}
    return {"recommended_instance": rule["instance"], "estimated_cost_per_hour": rule["cost"]}
```

### Week 4 — ML Upgrade
Train a `RandomForestClassifier` or simple `LinearRegression` using historical deployment data:
- Feature 1: `app_type` (label-encoded)
- Feature 2: `expected_users` (integer)
- Label: `instance_type` (e.g., t2.micro, t3.small)

---

## Task 3 — Test Suite (Week 2 skeleton → Week 6 full coverage)
**Files:** `tests/test_planner.py`, `tests/test_executor.py`, `tests/test_pipeline.py`

### Test Markers to Use
```python
import pytest

@pytest.mark.integration      # requires real AWS — skip in CI
@pytest.mark.requires_model   # requires trained .pkl — skip until model exists
```

### test_planner.py — What to Test
```python
# These tests run without AWS or trained models (use mocked data):
def test_validate_plan_passes():
    from orchestrator.pipeline import Pipeline
    p = Pipeline()
    valid_plan = {"intent": "deploy_ec2", "instance_type": "t2.micro",
                  "region": "us-east-1", "app": "nginx", "port": 80}
    assert p._validate_plan(valid_plan) is True

def test_validate_plan_fails_missing_intent():
    from orchestrator.pipeline import Pipeline
    p = Pipeline()
    assert p._validate_plan({"instance_type": "t2.micro"}) is False

# These need trained model — mark them:
@pytest.mark.requires_model
def test_intent_deploy():
    from agents.planner.intent_classifier import IntentClassifier
    clf = IntentClassifier()
    clf.load()
    label, conf = clf.predict("Deploy a t2.micro EC2 with nginx")
    assert label == "deploy_ec2"
    assert conf > 0.8
```

### test_executor.py — What to Test
```python
def test_ec2_manager_mock_create():
    from agents.executor.ec2_manager import EC2Manager
    m = EC2Manager()
    result = m.create_instance({"instance_type": "t2.micro", "region": "us-east-1",
                                 "app": "nginx", "port": 80})
    assert "instance_id" in result
    assert "public_ip" in result

def test_failure_predictor_returns_correct_shape():
    from agents.executor.failure_predictor import FailurePredictor
    fp = FailurePredictor()
    result = fp.predict({"instance_type": "t2.micro", "region": "us-east-1"})
    assert "will_fail" in result
    assert "confidence" in result
    assert isinstance(result["confidence"], float)
```

### test_pipeline.py — What to Test
```python
def test_validate_plan_with_all_required_fields():
    # Test Orchestrator validation logic (no AWS needed)
    pass

@pytest.mark.integration
def test_full_pipeline_end_to_end():
    # Full NL → EC2 deployed (requires real AWS)
    pass
```

---

## How to Run Tests

```bash
# Unit tests only (always should pass — no external dependencies)
pytest tests/ -v -m "not integration and not requires_model"

# All tests (requires .env + trained models)
pytest tests/ -v

# With coverage
pytest tests/ --cov=agents --cov=orchestrator --cov=api --cov-report=term-missing
```

### Target Coverage
- Week 2: 30% (just structure + validation tests)
- Week 6: 70%+ (unit + integration)

---

## Important Rules
- Unit tests must **never make real AWS calls** — use mocks for those
- Every test function name starts with `test_`
- Use `pytest.mark.integration` for any test that touches real AWS
- Update `PROGRESS.md` when you complete each task
- If you find a bug in Member 1 or 2's code — open a GitHub Issue with the exact failing test, don't edit their files
