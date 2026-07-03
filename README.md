# AutoOps AI 🤖
> **ML-powered DevOps assistant — natural language instructions to real AWS EC2 deployments.**

---

## What It Does
You type: `"Deploy a t2.micro EC2 with nginx in us-east-1"`
AutoOps AI:
1. **Understands your intent** using a trained ML classifier
2. **Extracts parameters** (instance type, region, app) using NER
3. **Predicts if it'll fail** before executing
4. **Provisions the EC2 instance** on AWS via boto3
5. **SSHes in and deploys** your app via Paramiko

---

## Team

| Member | Role | Owns | ML Deliverable |
|--------|------|------|----------------|
| Member 1 (Team Lead) | NLP/ML + Orchestrator + API | `agents/planner/`, `orchestrator/pipeline.py`, `api/` | Intent Classifier + NER |
| Member 2 | AWS Execution + Failure ML + Monitoring | `agents/executor/`, `orchestrator/monitor.py` | Failure Predictor + Anomaly Detector |
| Member 3 | SSH Deployment + Resource ML + Tests | `agents/ssh/`, `orchestrator/resource_predictor.py`, `tests/` | Resource Predictor (regression) |

---

## Project Structure

```
Auto-Ops/
├── agents/
│   ├── planner/          ← Intent Classification + NER (Member 1)
│   ├── executor/         ← EC2 via boto3 + Failure Prediction (Member 2)
│   └── ssh/              ← SSH deployment via Paramiko (Member 3)
├── orchestrator/
│   ├── pipeline.py       ← Pipeline coordinator (Member 1)
│   ├── monitor.py        ← Anomaly detection on logs (Member 2)
│   └── resource_predictor.py  ← Instance recommendation ML (Member 3)
├── api/                  ← FastAPI REST endpoints (Member 1)
├── models/               ← Saved ML model files (git-ignored)
├── data/seed/            ← Labelled NL training dataset (all members contribute)
├── tests/                ← Full test suite (Member 3)
├── scripts/              ← Setup scripts
├── docs/                 ← Member-specific task guides
├── CONTRACTS.md          ← ⭐ Data contracts between all agents
├── OWNERSHIP.md          ← Who owns what
└── PROGRESS.md           ← Weekly progress tracker
```

---

## ⚡ Quick Start (Every Team Member Does This)

### Step 1 — Clone
```bash
git clone <repo-url>
cd Auto-Ops
```

### Step 2 — Setup Environment
```bash
bash scripts/setup_env.sh
```
This will:
- Check Python 3.10+
- Create a `venv/` virtual environment
- Install all dependencies from `requirements.txt`
- Download the spaCy English model
- Create your `.env` from `.env.example`

### Step 3 — Configure AWS Credentials
Edit the `.env` file (created in Step 2):
```
AWS_ACCESS_KEY_ID=your_key_here
AWS_SECRET_ACCESS_KEY=your_secret_here
AWS_DEFAULT_REGION=us-east-1
EC2_KEY_NAME=your-key-pair-name
EC2_KEY_PATH=~/.ssh/your-key.pem
EC2_SECURITY_GROUP=your-security-group-id
```
> ⚠️ Never commit `.env` — it's in `.gitignore`

### Step 4 — Activate Environment (Every Session)
```bash
source venv/bin/activate
```

### Step 5 — Run the API
```bash
uvicorn api.main:app --reload
```
Visit: http://localhost:8000/docs

### Step 6 — Run Tests
```bash
pytest tests/ -v -m "not integration and not requires_model"
```

---

## 📚 Your Personal Guide

Each member has a detailed task guide in `docs/`:

| You Are | Read This First |
|---------|----------------|
| Member 1 (Team Lead) | [`docs/README_MEMBER1.md`](docs/README_MEMBER1.md) |
| Member 2 | [`docs/README_MEMBER2.md`](docs/README_MEMBER2.md) |
| Member 3 | [`docs/README_MEMBER3.md`](docs/README_MEMBER3.md) |

> **These guides are written so that an AI assistant can read them and implement your tasks.** Open your guide, share it with your AI tool, and start building.

---

## 📋 Key Documents (Read in This Order)

1. `README.md` — this file (project overview + setup)
2. `CONTRACTS.md` — ⭐ data schemas between all agents (read before writing ANY code)
3. `OWNERSHIP.md` — who owns what module
4. `PROGRESS.md` — weekly task tracker
5. `docs/README_MEMBER[1/2/3].md` — your personal implementation guide

---

## Tech Stack

| Tool | Purpose |
|------|---------|
| FastAPI | REST API |
| scikit-learn | Intent classification + failure/resource prediction |
| spaCy | Named Entity Recognition (NER) |
| boto3 | AWS EC2 provisioning |
| Paramiko | SSH deployment |
| pandas | Dataset management |
| pytest | Testing |

---

## Data Contract (Quick Reference)

A **Plan JSON** looks like this (full spec in `CONTRACTS.md`):
```json
{
  "intent": "deploy_ec2",
  "instance_type": "t2.micro",
  "region": "us-east-1",
  "app": "nginx",
  "port": 80,
  "count": 1,
  "confidence": 0.94
}
```

---

## Contributing

1. Work only in your own files — see `OWNERSHIP.md`
2. If you find a bug outside your module → open a GitHub Issue, tag the owner
3. Update `PROGRESS.md` when you complete a task
4. Never commit: `.env`, `.pem` files, `models/*.pkl`, `venv/`
