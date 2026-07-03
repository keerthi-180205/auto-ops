# AutoOps AI — Data Contracts
> **This is the most important document in the repo.**
> All 3 members must agree on these contracts before writing any code.
> If you change a contract, inform ALL team members immediately.

---

## 1. API Request / Response (Member 1 → Everyone)

### POST /deploy

**Request:**
```json
{
  "instruction": "Deploy a t2.micro EC2 instance with nginx in us-east-1"
}
```

**Response:**
```json
{
  "status": "success",
  "plan": { },
  "instance_id": "i-0abc1234567890abc",
  "public_ip": "3.91.45.12",
  "logs": "Instance launched. nginx installed. Service started on port 80."
}
```

**Status values:** `"success"` | `"failed"` | `"predicted_failure"`

---

## 2. Plan JSON — Planner → Orchestrator → Executor

This is the structured plan the Planner Agent outputs and the Executor consumes.

```json
{
  "intent": "deploy_ec2",
  "instance_type": "t2.micro",
  "region": "us-east-1",
  "app": "nginx",
  "port": 80,
  "count": 1,
  "os": "amazon-linux-2",
  "confidence": 0.94
}
```

### Field Definitions

| Field | Type | Required | Allowed Values | Default |
|-------|------|----------|----------------|---------|
| `intent` | string | ✅ Yes | `deploy_ec2`, `terminate_ec2`, `list_instances`, `restart_service`, `stop_instances` | — |
| `instance_type` | string | ✅ for deploy | `t2.micro`, `t2.nano`, `t2.small`, `t3.small`, `t3.medium` | `t2.micro` |
| `region` | string | ✅ for deploy | `us-east-1`, `us-west-2`, `eu-west-1` | `us-east-1` |
| `app` | string | ✅ for deploy | `nginx`, `apache`, `flask`, `nodejs`, `none` | `none` |
| `port` | integer | ✅ for deploy | 1–65535 | `80` |
| `count` | integer | No | 1–10 | `1` |
| `os` | string | No | `amazon-linux-2`, `ubuntu-22` | `amazon-linux-2` |
| `confidence` | float | ✅ | 0.0–1.0 | — |

### Validation Rule
The Orchestrator MUST reject any plan where:
- `intent` is missing
- `intent == "deploy_ec2"` but `instance_type` or `region` is missing
- `confidence < 0.5` (flag for manual review — do not execute)

---

## 3. Executor → SSH Deployer Contract

```json
{
  "instance_id": "i-0abc1234567890abc",
  "public_ip": "3.91.45.12",
  "username": "ec2-user",
  "key_path": "~/.ssh/autoops.pem",
  "app": "nginx",
  "port": 80,
  "install_cmd": "sudo yum install -y nginx",
  "start_cmd": "sudo systemctl start nginx && sudo systemctl enable nginx"
}
```

---

## 4. SSH Deployer → Orchestrator Result

```json
{
  "success": true,
  "logs": "nginx installed successfully. Service started on port 80.",
  "error": null
}
```

---

## 5. Failure Predictor Input / Output

**Input:**
```json
{
  "plan": { },
  "historical_errors": []
}
```

**Output:**
```json
{
  "will_fail": false,
  "confidence": 0.87,
  "reason": null
}
```

---

## 6. Intent Labels (for ML training)

| Label | Description | Example instruction |
|-------|-------------|---------------------|
| `deploy_ec2` | Launch new EC2 instance | "Deploy a t2.micro with nginx" |
| `terminate_ec2` | Terminate an instance | "Terminate instance i-0abc" |
| `list_instances` | List running instances | "Show all running EC2s" |
| `restart_service` | Restart a service on an instance | "Restart nginx on i-0abc" |
| `stop_instances` | Stop (not terminate) instances | "Stop all instances in us-east-1" |

---

## ⚠️ Contract Change Process
1. Open a GitHub Issue titled `[CONTRACT CHANGE] <field>`
2. Tag all 3 members
3. Get agreement before merging any change
