# 🤖 Orchestrator — Split Ownership

## Owner by File

| File | Owner | Purpose |
|------|-------|---------|
| `pipeline.py` | **Member 1 (Team Lead)** | Main coordination: Planner → Executor → SSH |
| `monitor.py` | **Member 2** | Anomaly detection on deployment logs |
| `resource_predictor.py` | **Member 3** | ML model: recommends optimal instance type |

---

## What This Module Does Overall
The orchestrator folder is the central hub. `pipeline.py` coordinates all agents. `monitor.py` and `resource_predictor.py` are ML components that the pipeline calls.

---

## pipeline.py (Member 1)
Coordinates the full pipeline:
1. Calls Planner → get Plan JSON
2. Validates plan (see CONTRACTS.md)
3. Calls FailurePredictor (Member 2's executor)
4. If safe → calls EC2Manager (Member 2's executor)
5. Calls SSHDeployer (Member 3's ssh agent)
6. Returns result to API

## monitor.py (Member 2)
- Receives deployment logs as input
- Detects anomalies (unexpected patterns, error spikes)
- Returns `{"anomaly_detected": bool, "details": str}`
- **Your ML contribution alongside failure_predictor.py**

## resource_predictor.py (Member 3)
- Input: `app_type: str`, `expected_users: int`
- Output: `{"recommended_instance": str, "estimated_cost_per_hour": float}`
- **Your ML contribution alongside deployer.py**
- Week 3: rule-based → Week 4: regression model

---

## 🚫 Boundary Rules
- Member 1: only edit `pipeline.py`
- Member 2: only edit `monitor.py`
- Member 3: only edit `resource_predictor.py`
- Cross-file bugs → GitHub Issue, tag the file owner
