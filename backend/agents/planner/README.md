# 🗺️ Planner Agent

## Owner

**Member 2**

## Goal

Convert a natural language user prompt into a structured deployment plan (JSON). The Planner Agent is the first agent in the pipeline. It receives a raw string like "deploy flask app" and outputs a structured JSON object that the Executor Agent can understand and act upon. In Phase 1, this uses simple rule-based logic (if/else and keyword matching) — no AI or ML models.

## Input

A string prompt from the user, e.g.:
```
"deploy flask app"
```

## Output

A structured JSON plan:
```json
{
  "app": "flask",
  "instance_type": "t2.micro",
  "region": "ap-south-1"
}
```

## Approach

- **Rule-based logic only** (Phase 1)
- Use if/else statements and keyword matching
- Parse the prompt for keywords like "flask", "node", "small", "large", etc.
- Map keywords to configuration values
- No AI/ML, no LLM calls, no NLP libraries

## Keyword Mapping (Examples)

| Keyword in Prompt       | Plan Field        | Value          |
|-------------------------|-------------------|----------------|
| "flask"                 | `app`             | `"flask"`      |
| "node" / "nodejs"       | `app`             | `"nodejs"`     |
| "small" / "micro"       | `instance_type`   | `"t2.micro"`   |
| "medium"                | `instance_type`   | `"t2.medium"`  |
| "large"                 | `instance_type`   | `"t2.large"`   |
| "mumbai" / "india"      | `region`          | `"ap-south-1"` |
| "us" / "virginia"       | `region`          | `"us-east-1"`  |

## Default Values

If the user doesn't specify, use sensible defaults:
- `app`: `"flask"` (default)
- `instance_type`: `"t2.micro"` (cheapest)
- `region`: `"ap-south-1"` (Mumbai)

## File

| File          | Purpose                                           |
|---------------|---------------------------------------------------|
| `planner.py`  | PlannerAgent class with `run(prompt)` method      |

## Tasks for Member 2

1. Create a `PlannerAgent` class with a `run(prompt: str) -> dict` method
2. Parse the prompt for keywords (app type, instance size, region)
3. Return a structured JSON plan with `app`, `instance_type`, and `region`
4. Use default values for any missing parameters
5. Log the generated plan for debugging

## Do NOT

- ❌ Deploy anything — the Planner only generates a plan
- ❌ Call AWS APIs or boto3
- ❌ Use AI/ML models (Phase 1 is rule-based only)
- ❌ Handle HTTP requests
