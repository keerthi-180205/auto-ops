# 🤖 Agent System

## Owner

**Member 2**

## Responsibility

The Agent System is the intelligence layer of AutoOps AI. It converts user intent into executable actions. In Phase 1, there are two agents that work sequentially: the Planner Agent converts a natural language prompt into a structured deployment plan (JSON), and the Executor Agent takes that plan and triggers the actual AWS provisioning and application deployment by calling the infrastructure modules.

## Agents (Phase 1)

| Agent              | Purpose                                      | File                         |
|--------------------|----------------------------------------------|------------------------------|
| **Planner Agent**  | Convert user prompt → structured JSON plan   | `planner/planner.py`         |
| **Executor Agent** | Execute plan → call AWS + deploy modules     | `executor/executor.py`       |

## Flow

```
User Prompt (string)
    ↓
Planner Agent
    ↓
Structured Plan (JSON)
    ↓
Executor Agent
    ↓
Deployment Result (JSON)
```

## Example

```
Input:  "deploy flask app"
            ↓
Planner:  { "app": "flask", "instance_type": "t2.micro", "region": "ap-south-1" }
            ↓
Executor: { "status": "success", "ip": "54.xxx.xxx.xxx" }
```

## Directory Structure

```
agents/
├── README.md
├── planner/
│   ├── README.md
│   └── planner.py          # Rule-based intent → plan conversion
└── executor/
    ├── README.md
    └── executor.py          # Plan → AWS provisioning + deployment
```

## Tasks for Member 2

1. Build the Planner Agent with rule-based logic (if/else, no AI/ML)
2. Build the Executor Agent that calls `infra/aws/ec2.py` and `infra/deploy/flask_deployer.py`
3. Both agents should have a `run()` method as the main entry point
4. Add proper error handling and logging

## Do NOT

- ❌ Call AWS APIs directly — use the `infra/` modules (Member 3's code)
- ❌ Handle HTTP requests — that's the API layer (Member 1's code)
- ❌ Use AI/ML models in Phase 1 — rule-based logic only
