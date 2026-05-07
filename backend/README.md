# 🔧 Backend — AutoOps AI

## Overview

The backend is a FastAPI application that serves as the brain of AutoOps AI. It receives user requests, orchestrates the multi-agent pipeline, and returns deployment results. In Phase 1, the entire flow is: User sends a prompt → API receives it → Orchestrator coordinates the agents → Planner converts intent to a plan → Executor provisions AWS infrastructure and deploys the Flask app → Public IP is returned to the user.

## Architecture

```
POST /deploy  →  API (deploy.py)
                    ↓
              Orchestrator (engine.py)
                    ↓
              Planner Agent (planner.py)
                    ↓
              Executor Agent (executor.py)
                    ↓
         ┌─────────┴──────────┐
     AWS EC2 (ec2.py)    Flask Deploy (flask_deployer.py)
         └─────────┬──────────┘
                    ↓
              Return public IP + URL
```

## Directory Structure

```
backend/
├── main.py                     # FastAPI app entry point
├── api/                        # 👤 Member 1 — API routes
│   ├── README.md
│   └── deploy.py               # POST /deploy endpoint
├── orchestrator/               # 👤 Member 1 — Workflow engine
│   ├── README.md
│   └── engine.py               # Controls Planner → Executor flow
├── agents/                     # 👤 Member 2 — Agent system
│   ├── README.md
│   ├── planner/
│   │   ├── README.md
│   │   └── planner.py          # Convert prompt → structured plan
│   └── executor/
│       ├── README.md
│       └── executor.py         # Execute plan → call AWS + deploy
├── infra/                      # 👤 Member 3 — Infrastructure layer
│   ├── README.md
│   ├── aws/
│   │   ├── README.md
│   │   └── ec2.py              # EC2 instance creation via boto3
│   └── deploy/
│       ├── README.md
│       └── flask_deployer.py   # SSH into EC2 + deploy Flask app
├── config/
│   └── settings.py             # App settings & env variable loading
└── utils/
    └── logger.py               # Structured logging utility
```

## How to Run

```bash
cd backend
python -m venv venv && source venv/bin/activate
pip install -r ../requirements.txt
cp ../.env.example .env   # Fill in your AWS credentials
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

## Team Ownership

| Directory       | Owner      | Responsibility                    |
|-----------------|------------|-----------------------------------|
| `api/`          | Member 1   | API endpoint, request validation  |
| `orchestrator/` | Member 1   | Workflow control between agents   |
| `agents/`       | Member 2   | Planner + Executor agent logic    |
| `infra/`        | Member 3   | AWS operations + Flask deployment |
| `config/`       | Shared     | Settings and environment config   |
| `utils/`        | Shared     | Logging and common utilities      |
