# 🤖 Tests — Module Ownership

## Owner
**Member 3**

## What This Module Does
All automated tests for the project. Member 3 writes tests for every module — including modules owned by Member 1 and Member 2.

## Files You Own
| File | Tests |
|------|-------|
| `test_planner.py` | Tests for `agents/planner/` (Member 1's code) |
| `test_executor.py` | Tests for `agents/executor/` (Member 2's code) |
| `test_pipeline.py` | Integration tests for the full pipeline |

## Rules
- Use `pytest` for all tests
- Mark tests that require AWS credentials with `@pytest.mark.integration`
- Mark tests that require trained models with `@pytest.mark.requires_model`
- Unit tests (no external calls) must always pass: `pytest tests/ -m "not integration and not requires_model"`

## Running Tests
```bash
# All tests
pytest tests/ -v

# Unit tests only (no AWS needed)
pytest tests/ -v -m "not integration and not requires_model"

# With coverage report
pytest tests/ --cov=agents --cov=orchestrator --cov=api
```
