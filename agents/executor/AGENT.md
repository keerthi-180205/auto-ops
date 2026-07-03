# 🤖 Executor Agent — Module Ownership

## Owner
**Member 2**

## What This Module Does
The Executor Agent takes the validated Plan JSON from the Orchestrator and:
1. **Provisions EC2 instances** on AWS using boto3
2. **Predicts failures** before executing using an ML model trained on deployment logs

## Files You Own
| File | Purpose |
|------|---------|
| `ec2_manager.py` | All boto3 EC2 operations (create, terminate, list, status) |
| `failure_predictor.py` | ML model: predicts if a deployment will fail before executing |

## Input / Output Contract
- **Input:** Plan JSON from Orchestrator — see `CONTRACTS.md` Section 2
- **Output to SSH Agent:** EC2 connection info — see `CONTRACTS.md` Section 3
- **Failure Predictor output:** see `CONTRACTS.md` Section 5

## 🚫 Boundary Rules
- Members 1 & 3: **DO NOT edit any files in this folder**
- If you encounter a bug here, open a GitHub Issue and tag Member 2
- You do NOT write SSH logic — that belongs to `agents/ssh/` (Member 3)
- You do NOT write the Orchestrator — that belongs to `orchestrator/` (Member 1)

## 🐛 Found a Bug? Report It Like This
```
Title: [BUG] executor — <short description>
Body:
  - Plan JSON passed in: { ... }
  - Expected result: ...
  - Actual error: ...
  - AWS region: ...
```

## Done Means
- `EC2Manager.create_instance(plan)` returns `{"instance_id": "i-xxx", "public_ip": "x.x.x.x", "state": "running"}`
- `EC2Manager.terminate_instance("i-xxx")` returns `True`
- `FailurePredictor.predict(plan)` returns `{"will_fail": bool, "confidence": float, "reason": str}`
- All calls use credentials from `.env` — no hardcoded keys ever
