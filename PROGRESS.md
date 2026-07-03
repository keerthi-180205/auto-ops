# AutoOps AI — Progress Tracker
> Update this file every time you complete a task. Use ✅ for done, 🔄 for in-progress, ⬜ for not started.

---

## Week 1 — Setup & Contracts

| Task | Owner | Status | Notes |
|------|-------|--------|-------|
| Create GitHub repo + push initial structure | Member 1 | ⬜ | |
| All members clone repo + run setup_env.sh | All | ⬜ | |
| Read and agree on CONTRACTS.md | All | ⬜ | |
| Collect seed dataset — Member 1's 100 rows | Member 1 | ⬜ | Add to `data/seed/seed_dataset_template.csv` |
| Collect seed dataset — Member 2's 100 rows | Member 2 | ⬜ | Add to `data/seed/seed_dataset_template.csv` |
| Collect seed dataset — Member 3's 100 rows | Member 3 | ⬜ | Add to `data/seed/seed_dataset_template.csv` |

---

## Week 2 — Individual Module Scaffolding

| Task | Owner | Status | Notes |
|------|-------|--------|-------|
| FastAPI skeleton (`api/main.py`) with `/health` + `/deploy` stubs | Member 1 | ⬜ | |
| Orchestrator stub (`orchestrator/pipeline.py`) | Member 1 | ⬜ | |
| Intent classifier scaffold with mocked predict() | Member 1 | ⬜ | |
| EC2 manager scaffold with mocked create/terminate | Member 2 | ⬜ | |
| SSH deployer scaffold with mocked connect/deploy | Member 3 | ⬜ | |
| Test suite skeleton (3 test files) | Member 3 | ⬜ | |

---

## Week 3-4 — Core ML + Execution Build

| Task | Owner | Status | Notes |
|------|-------|--------|-------|
| Train intent classifier on seed dataset | Member 1 | ⬜ | Target: >85% accuracy |
| Train NER extractor (spaCy) | Member 1 | ⬜ | Entities: instance_type, region, app, port |
| Planner outputs real Plan JSON from NL input | Member 1 | ⬜ | |
| Wire boto3 to real AWS (EC2 create/terminate) | Member 2 | ⬜ | |
| Failure predictor v1 (trained on synthetic errors) | Member 2 | ⬜ | |
| **Monitor v1 (anomaly detection on logs)** | **Member 2** | ⬜ | Rule-based first, ML upgrade Week 5 |
| SSH connect + run commands via Paramiko | Member 3 | ⬜ | |
| Full SSH deployment (install + start app) | Member 3 | ⬜ | |
| **Resource predictor v1 (rule-based table)** | **Member 3** | ⬜ | Upgrade to regression model Week 4 |

---

## Week 5 — Integration

| Task | Owner | Status | Notes |
|------|-------|--------|-------|
| Wire Planner → Orchestrator | Member 1 | ⬜ | |
| Wire Orchestrator → Executor | Member 1 | ⬜ | |
| Wire Executor → SSH Deployer | Member 2 | ⬜ | |
| First full end-to-end test (NL → EC2 running app) | All | ⬜ | 🎯 Major milestone |

---

## Week 6 — Testing & Hardening

| Task | Owner | Status | Notes |
|------|-------|--------|-------|
| Expand test suite (unit + integration) | Member 3 | ⬜ | |
| Improve failure handling + retry logic | Member 2 | ⬜ | |
| Improve model accuracy (re-train if needed) | Member 1 | ⬜ | |

---

## Week 7-8 — Demo Prep

| Task | Owner | Status | Notes |
|------|-------|--------|-------|
| Record demo video | All | ⬜ | |
| Write architecture doc | All | ⬜ | |
| Clean up README | Member 1 | ⬜ | |
