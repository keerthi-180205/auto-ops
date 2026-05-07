# 🌐 API Layer

## Owner

**Member 1**

## Responsibility

Handle incoming HTTP requests from the user and trigger the system workflow. The API layer is the entry point for all user interactions with AutoOps AI. It receives the user's natural language prompt, validates the request format, and passes it to the Orchestrator for processing. It does NOT contain any business logic, AWS code, or agent logic — it is a thin routing layer only.

## Endpoint to Build

### `POST /deploy`

This is the primary endpoint for Phase 1. It accepts a JSON body with a user prompt, triggers the full deployment pipeline through the Orchestrator, and returns the deployment result including the EC2 public IP and application URL.

**Input:**
```json
{
  "prompt": "deploy flask app"
}
```

**Output (Success):**
```json
{
  "status": "success",
  "ip": "54.xxx.xxx.xxx",
  "url": "http://54.xxx.xxx.xxx:5000"
}
```

**Output (Error):**
```json
{
  "status": "error",
  "message": "Failed to create EC2 instance"
}
```

## Flow

```
User → POST /deploy → deploy.py → orchestrator.engine.run() → return result
```

## File

| File        | Purpose                                             |
|-------------|-----------------------------------------------------|
| `deploy.py` | Defines the POST /deploy endpoint using FastAPI router |

## Tasks for Member 1

1. Create the `/deploy` POST endpoint in `deploy.py`
2. Validate that the request body contains a `prompt` field
3. Import and call the Orchestrator's `run()` function
4. Return the result as JSON response
5. Handle errors gracefully with proper HTTP status codes

## Do NOT

- ❌ Write AWS logic (that's Member 3's job in `infra/`)
- ❌ Write agent logic (that's Member 2's job in `agents/`)
- ❌ Call boto3 or Paramiko directly
- ❌ Put business logic in the endpoint — delegate everything to the Orchestrator
