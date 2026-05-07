# 🚀 AutoOps AI

## Overview

AutoOps AI is an intelligent, agent-based DevOps automation system that converts natural language user intent into real cloud deployment and execution. Built by a 4-member team, it automates the complete DevOps lifecycle using a multi-agent architecture.

**Phase 1 focuses on building a working end-to-end pipeline:**

```
User Input → Planning → Execution → EC2 Deployment → Flask App Running
```

---

## System Architecture

```
User
 ↓
POST /deploy  (API Layer)
 ↓
Orchestrator  (Workflow Engine)
 ↓
┌─────────────┐     ┌──────────────┐
│ Planner     │ ──→ │  Executor    │
│ Agent       │     │  Agent       │
└─────────────┘     └──────┬───────┘
                           ↓
                    ┌──────────────┐
                    │  AWS (EC2)   │
                    │  + Flask     │
                    │  Deployment  │
                    └──────────────┘
                           ↓
                    Public IP + URL returned
```

---

## Core Workflow

```
User → API → Orchestrator → Planner → Executor → AWS → Deployment
```

1. User sends a natural language prompt (e.g., "deploy flask app")
2. API receives the request and passes it to the Orchestrator
3. Orchestrator calls the Planner Agent to convert intent into a structured plan
4. Orchestrator passes the plan to the Executor Agent
5. Executor calls the AWS module to create an EC2 instance
6. Executor calls the Deployment module to SSH in and deploy Flask
7. Public IP and URL are returned to the user

---

## Phase 1 Scope

- ✅ Deploy Flask app on AWS EC2 via natural language input
- ✅ Basic rule-based planner (if/else, no AI/ML)
- ✅ Simple orchestrator (sequential: Planner → Executor)
- ✅ EC2 instance creation via boto3
- ✅ Flask deployment via SSH (Paramiko)
- ✅ Public URL returned to user
- ❌ No AI/ML, no monitoring, no cost optimization (Phase 2+)

---

## Tech Stack

| Layer          | Technology                        |
|----------------|-----------------------------------|
| **Backend**    | Python 3.11+ / FastAPI            |
| **Cloud**      | AWS (EC2)                         |
| **IaC**        | Terraform (optional Phase 1)      |
| **SSH**        | Paramiko                          |
| **AWS SDK**    | boto3                             |
| **Frontend**   | React (optional Phase 1)          |
| **Database**   | PostgreSQL (Phase 2)              |

---

## Team Responsibilities

| Member     | Ownership                          | Directories                          |
|------------|------------------------------------|--------------------------------------|
| **Member 1** | API + Orchestrator              | `backend/api/`, `backend/orchestrator/` |
| **Member 2** | Agents (Planner + Executor)     | `backend/agents/`                    |
| **Member 3** | AWS Infrastructure + Deployment | `backend/infra/`, `infrastructure/`, `scripts/` |
| **Member 4** | Frontend + Testing              | `frontend/`, `tests/`                |

---

## Project Structure

```
Auto-Ops/
├── README.md
├── requirements.txt
├── .env.example
├── docker-compose.yml
├── .gitignore
│
├── backend/
│   ├── README.md
│   ├── main.py                     # FastAPI entry point
│   ├── api/                        # 👤 Member 1
│   │   ├── README.md
│   │   └── deploy.py               # POST /deploy
│   ├── orchestrator/               # 👤 Member 1
│   │   ├── README.md
│   │   └── engine.py               # Workflow control
│   ├── agents/                     # 👤 Member 2
│   │   ├── README.md
│   │   ├── planner/
│   │   │   ├── README.md
│   │   │   └── planner.py
│   │   └── executor/
│   │       ├── README.md
│   │       └── executor.py
│   ├── infra/                      # 👤 Member 3
│   │   ├── README.md
│   │   ├── aws/
│   │   │   ├── README.md
│   │   │   └── ec2.py              # EC2 creation
│   │   └── deploy/
│   │       ├── README.md
│   │       └── flask_deployer.py   # SSH + deploy
│   ├── config/
│   │   └── settings.py
│   └── utils/
│       └── logger.py
│
├── infrastructure/                 # 👤 Member 3 (optional Phase 1)
│   ├── README.md
│   └── terraform/
│       └── ec2_basic/
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
│
├── scripts/                        # 👤 Member 3
│   ├── README.md
│   ├── deploy_flask.sh
│   └── setup.sh
│
├── frontend/                       # 👤 Member 4 (optional Phase 1)
│   ├── README.md
│   ├── src/
│   │   ├── pages/
│   │   ├── components/
│   │   └── services/
│   └── public/
│
├── tests/                          # 👤 Member 4
│   ├── README.md
│   └── test_deploy_flow.py
│
├── docs/
│   └── roadmap/
│       ├── phase1.md
│       ├── phase2.md
│       └── phase3.md
│
├── data/
└── logs/
```

---

## Expected Output (Phase 1 Demo)

**Input:**
```json
{ "prompt": "deploy flask app" }
```

**Output:**
```json
{
  "status": "success",
  "ip": "54.xxx.xxx.xxx",
  "url": "http://54.xxx.xxx.xxx:5000"
}
```

**Result:**
- ✅ EC2 instance created on AWS
- ✅ Flask application deployed and running
- ✅ Public URL accessible in browser

---

## Getting Started

```bash
# 1. Clone the repository
git clone <repo-url> && cd Auto-Ops

# 2. Set up backend
cd backend
python -m venv venv && source venv/bin/activate
pip install -r ../requirements.txt
cp ../.env.example .env  # Configure AWS credentials

# 3. Run the backend
uvicorn main:app --reload --host 0.0.0.0 --port 8000

# 4. Test the deployment
curl -X POST http://localhost:8000/deploy \
  -H "Content-Type: application/json" \
  -d '{"prompt": "deploy flask app"}'
```

---

## Roadmap

| Phase   | Focus                                          | Timeline  |
|---------|------------------------------------------------|-----------|
| Phase 1 | Working E2E pipeline (Planner → EC2 → Flask)  | Month 1-2 |
| Phase 2 | Monitoring, FinOps, Validation agents          | Month 3-5 |
| Phase 3 | Self-healing, Dashboard, Multi-cloud            | Month 6-8 |

---

## Goal

Build a working end-to-end DevOps automation pipeline where a user types "deploy flask app" and gets a running Flask application on AWS EC2 with a public URL — fully automated, zero manual steps.
