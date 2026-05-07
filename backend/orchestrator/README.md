# 🎛️ Orchestrator

## Owner

**Member 1**

## Responsibility

The Orchestrator is the workflow engine that controls the flow between system components. It acts as the central coordinator — it receives the user's prompt from the API layer, calls the Planner Agent to generate a structured plan, then passes that plan to the Executor Agent for deployment. It returns the final result back to the API. The Orchestrator does NOT contain any AWS code, deployment logic, or intent parsing — it only manages the sequence of agent calls.

## Flow

```
API calls orchestrator.run(prompt)
    ↓
Orchestrator calls planner.run(prompt)
    ↓
Planner returns structured plan
    ↓
Orchestrator calls executor.run(plan)
    ↓
Executor returns deployment result
    ↓
Orchestrator returns result to API
```

## Input

User prompt (string) — e.g., `"deploy flask app"`

## Output

Deployment result (dict) — e.g.:
```json
{
  "status": "success",
  "ip": "54.xxx.xxx.xxx",
  "url": "http://54.xxx.xxx.xxx:5000"
}
```

## File

| File        | Purpose                                         |
|-------------|--------------------------------------------------|
| `engine.py` | Main orchestration engine with `run()` function  |

## Example Logic

```python
# engine.py (pseudocode)
from agents.planner.planner import PlannerAgent
from agents.executor.executor import ExecutorAgent

def run(prompt: str) -> dict:
    planner = PlannerAgent()
    executor = ExecutorAgent()

    plan = planner.run(prompt)      # Step 1: Convert prompt → plan
    result = executor.run(plan)     # Step 2: Execute plan → deploy
    return result                   # Step 3: Return result to API
```

## Tasks for Member 1

1. Create the `run()` function in `engine.py`
2. Import and call `PlannerAgent.run(prompt)` to get the plan
3. Pass the plan to `ExecutorAgent.run(plan)` to execute it
4. Return the final deployment result
5. Add error handling — if planner fails, don't call executor
6. Add logging at each step for debugging

## Do NOT

- ❌ Write AWS code (that's `infra/aws/`)
- ❌ Write deployment logic (that's `infra/deploy/`)
- ❌ Parse user prompts (that's the Planner Agent's job)
- ❌ Call boto3 or Paramiko directly
