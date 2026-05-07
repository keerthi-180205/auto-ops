# 🎨 Frontend

## Owner

**Member 4** (Optional for Phase 1)

## Responsibility

Provide a simple web-based UI for interacting with AutoOps AI. In Phase 1, the frontend is optional — the primary interface is the REST API (tested via Postman or curl). If built, the frontend should provide a minimal interface with an input field for the user prompt and a results area to display the deployment output.

## Features (Phase 1)

- ✅ Input field for natural language prompt (e.g., "deploy flask app")
- ✅ Submit button to trigger the deployment
- ✅ Results display showing deployment status, IP address, and URL
- ❌ No authentication (Phase 2)
- ❌ No monitoring dashboard (Phase 2)
- ❌ No cost tracking (Phase 2)

## API Integration

The frontend communicates with a single backend endpoint:

```
POST http://localhost:8000/deploy
Content-Type: application/json

{
  "prompt": "deploy flask app"
}
```

**Response:**
```json
{
  "status": "success",
  "ip": "54.xxx.xxx.xxx",
  "url": "http://54.xxx.xxx.xxx:5000"
}
```

## Directory Structure

```
frontend/
├── README.md
├── src/
│   ├── pages/           # Page-level views (DeployPage, ResultPage)
│   ├── components/      # Reusable UI components (InputField, ResultCard)
│   └── services/        # API client (calls POST /deploy)
└── public/              # Static assets (favicon, etc.)
```

## Tasks for Member 4

1. Create a simple React app (use Vite)
2. Build a deploy page with a text input and submit button
3. Call `POST /deploy` when user submits
4. Display the result (status, IP, URL) on screen
5. Handle loading and error states

## Do NOT

- ❌ Write backend logic
- ❌ Call AWS directly
- ❌ Implement complex features (keep it minimal for Phase 1)
