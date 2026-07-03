# AutoOps AI — Member 2 Guide

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
> | Start Task 1 (EC2 Manager) | `"Start Task 1 — implement agents/executor/ec2_manager.py"` |
> | Start Task 2 (Failure Predictor) | `"Start Task 2 — implement agents/executor/failure_predictor.py"` |
> | Start Task 3 (Log Monitor) | `"Start Task 3 — implement orchestrator/monitor.py"` |
>
> The AI will open the correct file and start implementing immediately.

---

## 🤖 AI System Context (Read This If You Are an AI Assistant)

You are an AI coding assistant working on **AutoOps AI** — an ML-powered DevOps system that converts natural language instructions into real AWS EC2 deployments.

**Your job:** You are implementing **Member 2's tasks** in the project located at `/home/keerthi-180205/Auto-Ops/`.

**Rules you must follow:**
- Only edit the 3 files listed under "Your Files" below — nothing else
- Match function signatures EXACTLY as specified — Member 1's Orchestrator calls your code directly
- NEVER hardcode AWS credentials — always use `os.getenv()` after `load_dotenv()`
- NEVER commit `.env` or `.pem` files
- Always tag EC2 instances with `{"Key": "Project", "Value": "AutoOps"}` — so test instances can be found and terminated
- Terminate all test EC2 instances immediately after testing (costs money)
- After implementing each task, run the verification commands at the bottom of this file
- When done with a task, mark it ✅ in `PROGRESS.md`

---

## Your Role
You own the **Executor Agent** (EC2 provisioning + Failure Prediction ML) **and** the **Monitoring layer** (anomaly detection on logs). You have 3 deliverables: one engineering task, one ML model, and one monitoring component.

---

## Your Files (ONLY edit these)
```
agents/executor/ec2_manager.py        ← All AWS EC2 operations (boto3)
agents/executor/failure_predictor.py  ← ML failure prediction model
orchestrator/monitor.py               ← Anomaly detection on deployment logs
```

---

## 📊 Seed Dataset — Your Contribution (Week 1)
**File:** `data/seed/seed_dataset_template.csv`

The seed dataset already has **~200 rows** generated. Your job is to **add 50 more rows** focused on the `terminate_ec2` and `stop_instances` intents — the ones your Failure Predictor model needs.

### Use This AI Prompt to Generate Your Rows:
> Copy the prompt below → paste into any AI chat → copy the output → append to `data/seed/seed_dataset_template.csv`

```
Generate 50 diverse natural language instructions for a DevOps AI system.
Focus on these intents: terminate_ec2 (30 rows) and stop_instances (20 rows).

Rules:
- Vary the phrasing for terminate: terminate/delete/destroy/kill/remove/take down/wipe out/decommission
- Vary the phrasing for stop: stop/pause/halt/shut down/power off/suspend/freeze/bring offline
- Always include a realistic fake instance ID like i-0abc1234567890abc for terminate
- For stop_instances: some target a specific instance, some target all in a region
- Regions to vary: us-east-1, us-west-2, eu-west-1
- Make some polite ("Please...", "Can you..."), some urgent ("Now!", "immediately"), some plain

Output strictly as CSV rows with this format (no header):
"instruction",intent,instance_type,region,app,port,count,notes
(leave instance_type/app/port/count empty for terminate and stop — use commas as placeholders)
```

---

## Initial Setup (Do This First)
```bash
# Clone repo, then:
bash scripts/setup_env.sh
source venv/bin/activate

# Configure AWS credentials in .env:
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
AWS_DEFAULT_REGION=us-east-1
```

---

## Task 1 — EC2 Manager (Week 2 mocked → Week 3-4 real)
**File:** `agents/executor/ec2_manager.py`

### Exact Class Interface Required
```python
import boto3
import os
from dotenv import load_dotenv

load_dotenv()

class EC2Manager:
    def __init__(self, region: str = None):
        self.region = region or os.getenv("AWS_DEFAULT_REGION", "us-east-1")
        self.client = None

    def connect(self) -> None:
        # Initialize boto3 EC2 client using env credentials
        # self.client = boto3.client("ec2", region_name=self.region)

    def create_instance(self, plan: dict) -> dict:
        # Input: Plan JSON from CONTRACTS.md Section 2
        # Returns:
        # {
        #   "instance_id": "i-0abc1234567890abc",
        #   "public_ip": "3.91.45.12",
        #   "state": "running"
        # }

    def terminate_instance(self, instance_id: str) -> bool:
        # Terminates the instance
        # Returns True on success, raises Exception on failure

    def list_instances(self) -> list:
        # Returns list of running instances:
        # [{"instance_id": str, "public_ip": str, "state": str, "type": str}]

    def get_instance_status(self, instance_id: str) -> str:
        # Returns: "pending" | "running" | "stopping" | "stopped" | "terminated"

    def wait_for_running(self, instance_id: str, timeout: int = 120) -> str:
        # Polls until instance is "running" or timeout
        # Returns public IP once running
```

### Week 2 — Mocked Implementation
Return hardcoded fake data so the pipeline can be tested end-to-end:
```python
def create_instance(self, plan: dict) -> dict:
    return {
        "instance_id": "i-MOCKED123456",
        "public_ip": "0.0.0.0",
        "state": "running"
    }
```

### Week 3-4 — Real boto3 Implementation
```python
def create_instance(self, plan: dict) -> dict:
    self.connect()
    ami_map = {
        "amazon-linux-2": "ami-0c02fb55956c7d316",
        "ubuntu-22": "ami-0261755bbcb8c4a84"
    }
    response = self.client.run_instances(
        ImageId=ami_map.get(plan.get("os", "amazon-linux-2")),
        InstanceType=plan["instance_type"],
        MinCount=1,
        MaxCount=plan.get("count", 1),
        KeyName=os.getenv("EC2_KEY_NAME"),
        SecurityGroups=[os.getenv("EC2_SECURITY_GROUP")],
        TagSpecifications=[{
            "ResourceType": "instance",
            "Tags": [{"Key": "Project", "Value": "AutoOps"}]
        }]
    )
    instance = response["Instances"][0]
    instance_id = instance["InstanceId"]
    public_ip = self.wait_for_running(instance_id)
    return {"instance_id": instance_id, "public_ip": public_ip, "state": "running"}
```

---

## Task 2 — Failure Predictor (Week 3-4)
**File:** `agents/executor/failure_predictor.py`

### Exact Class Interface Required
```python
class FailurePredictor:
    def __init__(self):
        self.model = None

    def train(self, X_train: list, y_train: list) -> dict:
        # X_train: list of plan dicts serialized to feature vectors
        # y_train: list of 0 (success) or 1 (failure)
        # Returns: {"accuracy": float}

    def predict(self, plan: dict) -> dict:
        # Returns:
        # {
        #   "will_fail": False,
        #   "confidence": 0.87,
        #   "reason": None   ← or "timeout" | "permission_error" | "wrong_ami"
        # }

    def save(self, path: str = "models/failure_predictor.pkl") -> None:
        # Save with joblib

    def load(self, path: str = "models/failure_predictor.pkl") -> None:
        # Load with joblib
```

### Week 2-3 — Rule-Based Starter
```python
def predict(self, plan: dict) -> dict:
    # Simple rules until real model is trained
    risky_types = ["t1.micro"]  # outdated instance types
    if plan.get("instance_type") in risky_types:
        return {"will_fail": True, "confidence": 0.75, "reason": "outdated_instance_type"}
    return {"will_fail": False, "confidence": 0.90, "reason": None}
```

### Week 4 — ML Implementation
Use synthetic failure data. Features to extract from plan:
- `instance_type_encoded` (t2.micro=0, t2.nano=1, etc.)
- `region_encoded`
- `app_encoded`
- `port`

Train a `RandomForestClassifier` on labeled failure log data.

---

## Task 3 — Log Monitor / Anomaly Detection (Week 4-5)
**File:** `orchestrator/monitor.py`

This is your **third deliverable** — an anomaly detector that watches deployment logs for unusual patterns (repeated failures, error spikes, unexpected outputs).

### Exact Class Interface Required
```python
from loguru import logger

class DeploymentMonitor:
    def __init__(self):
        self.log_history = []   # stores recent deployment results

    def record(self, result: dict) -> None:
        # Append a deployment result to log_history
        # result shape: {"success": bool, "logs": str, "instance_id": str, "timestamp": str}

    def detect_anomaly(self) -> dict:
        # Scan the last N deployment results for anomalies
        # Anomaly = >50% failure rate in last 5 deployments
        # Returns:
        # {
        #   "anomaly_detected": True,
        #   "failure_rate": 0.6,
        #   "details": "3 out of 5 recent deployments failed"
        # }

    def get_summary(self) -> dict:
        # Returns overall stats:
        # {
        #   "total_deployments": int,
        #   "successes": int,
        #   "failures": int,
        #   "success_rate": float
        # }
```

### Week 3 — Simple Rule-Based Monitor
```python
def detect_anomaly(self) -> dict:
    recent = self.log_history[-5:]   # last 5 deployments
    if not recent:
        return {"anomaly_detected": False, "failure_rate": 0.0, "details": "No data yet"}
    failures = sum(1 for r in recent if not r["success"])
    rate = failures / len(recent)
    if rate > 0.5:
        return {
            "anomaly_detected": True,
            "failure_rate": round(rate, 2),
            "details": f"{failures} out of {len(recent)} recent deployments failed"
        }
    return {"anomaly_detected": False, "failure_rate": round(rate, 2), "details": "Normal"}
```

### Week 5 — ML Upgrade (Optional)
Train an `IsolationForest` on the numeric features of deployment results to detect statistical anomalies.

---

## How to Verify Your Work Is Done

```bash
# Test EC2 Manager (mocked, no AWS needed)
python3 -c "
from agents.executor.ec2_manager import EC2Manager
m = EC2Manager()
result = m.create_instance({'instance_type': 't2.micro', 'region': 'us-east-1', 'app': 'nginx', 'port': 80})
print(result)
assert 'instance_id' in result
assert 'public_ip' in result
print('EC2Manager mock: PASS')
"

# Test Failure Predictor
python3 -c "
from agents.executor.failure_predictor import FailurePredictor
fp = FailurePredictor()
result = fp.predict({'instance_type': 't2.micro', 'region': 'us-east-1'})
print(result)
assert 'will_fail' in result
assert 'confidence' in result
print('FailurePredictor: PASS')
"

# Test Monitor
python3 -c "
from orchestrator.monitor import DeploymentMonitor
m = DeploymentMonitor()
m.record({'success': False, 'logs': 'error', 'instance_id': 'i-1', 'timestamp': '2024-01-01'})
m.record({'success': False, 'logs': 'error', 'instance_id': 'i-2', 'timestamp': '2024-01-01'})
m.record({'success': False, 'logs': 'error', 'instance_id': 'i-3', 'timestamp': '2024-01-01'})
result = m.detect_anomaly()
print(result)
assert result['anomaly_detected'] == True
print('Monitor: PASS')
"

# Run tests
pytest tests/test_executor.py -v
```

---

## Important Rules
- **Never hardcode AWS credentials** — always use `os.getenv()` after `load_dotenv()`
- **Never commit `.env` or `.pem` files** — they're in `.gitignore`
- Always tag EC2 instances with `{"Key": "Project", "Value": "AutoOps"}` so you can track them
- **Terminate test instances immediately** after testing — don't leave them running (costs money)
- Update `PROGRESS.md` when you complete each task
- If you find a bug in Member 1's Planner output (the Plan JSON), report via GitHub Issue — do not edit their files
