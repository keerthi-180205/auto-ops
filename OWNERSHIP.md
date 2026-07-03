# AutoOps AI — Module Ownership Map

> One person owns each module. If you find a bug outside your module, **do not fix it yourself**.
> Open an issue, tag the owner, and describe the problem clearly.

---

## Ownership Table

| Path | Owner | Do NOT touch if you're not the owner |
|------|-------|--------------------------------------|
| `agents/planner/` | **Member 1 (Team Lead)** | ❌ Members 2 & 3 |
| `agents/executor/` | **Member 2** | ❌ Members 1 & 3 |
| `agents/ssh/` | **Member 3** | ❌ Members 1 & 2 |
| `orchestrator/pipeline.py` | **Member 1 (Team Lead)** | ❌ Members 2 & 3 |
| `orchestrator/monitor.py` | **Member 2** | ❌ Members 1 & 3 |
| `orchestrator/resource_predictor.py` | **Member 3** | ❌ Members 1 & 2 |
| `api/` | **Member 1 (Team Lead)** | ❌ Members 2 & 3 |
| `tests/` | **Member 3** | Members 1 & 2 may add test cases but not restructure |
| `data/seed/` | **All 3 members** | Shared — anyone adds rows to CSV |
| `CONTRACTS.md` | **All 3 members** | Changes need full team agreement |
| `requirements.txt` | **Member 1** | Others request additions via issue |
| `scripts/` | **Member 1** | ❌ Members 2 & 3 |
| `docs/` | **All 3 members** | Each member updates their own README |

---

## Bug Reporting Protocol

If you find a bug in someone else's module:

```
1. Open a GitHub Issue
2. Title: [BUG] <module_name> — <short description>
3. Tag the owner
4. Include:
   - Exact error message
   - Input you passed to the module
   - Expected output vs actual output
   - Your Python environment details
```

---

## File-level Ownership

| File | Owner |
|------|-------|
| `agents/planner/intent_classifier.py` | Member 1 |
| `agents/planner/ner_extractor.py` | Member 1 |
| `agents/executor/ec2_manager.py` | Member 2 |
| `agents/executor/failure_predictor.py` | Member 2 |
| `agents/ssh/deployer.py` | Member 3 |
| `orchestrator/pipeline.py` | Member 1 |
| `orchestrator/monitor.py` | **Member 2** ← anomaly detection on execution logs |
| `orchestrator/resource_predictor.py` | **Member 3** ← regression ML for instance recommendation |
| `api/main.py` | Member 1 |
| `tests/test_planner.py` | Member 3 (writes tests for Member 1's code) |
| `tests/test_executor.py` | Member 3 (writes tests for Member 2's code) |
| `tests/test_pipeline.py` | Member 3 (integration tests) |
