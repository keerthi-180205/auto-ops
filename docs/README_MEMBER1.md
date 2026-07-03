# AutoOps AI — Member 1 (Team Lead) Guide

---

## ⚡ How to Use This With an AI Assistant

> **Your teammate instructions — do this before anything else:**
>
> 1. Open this file in VS Code
> 2. Select All (`Ctrl+A`) → Copy (`Ctrl+C`)
> 3. Open your AI assistant (Cursor, Copilot Chat, Claude, ChatGPT, etc.)
> 4. Paste the entire file as your first message
> 5. Then type one of these trigger prompts:
>
> | What you want to do | What to type |
> |---------------------|--------------|
> | Start Task 1 (FastAPI) | `"Start Task 1 — implement api/main.py"` |
> | Start Task 2 (Intent Classifier) | `"Start Task 2 — implement agents/planner/intent_classifier.py"` |
> | Start Task 3 (NER Extractor) | `"Start Task 3 — implement agents/planner/ner_extractor.py"` |
> | Start Task 4 (Orchestrator) | `"Start Task 4 — implement orchestrator/pipeline.py"` |
> | Start Task 5 (Resource Predictor) | `"Start Task 5 — implement orchestrator/resource_predictor.py"` |
>
> The AI will open the correct file and start implementing immediately.

---

## 🤖 AI System Context (Read This If You Are an AI Assistant)

You are an AI coding assistant working on **AutoOps AI** — an ML-powered DevOps system that converts natural language instructions into real AWS EC2 deployments.

**Your job:** You are implementing **Member 1's tasks** in the project located at `/home/keerthi-180205/Auto-Ops/`.

**Rules you must follow:**
- Only edit files listed under "Your Files" below
- Match function signatures EXACTLY as specified — other team members depend on them
- Follow the data contracts in `CONTRACTS.md` — do not invent your own schemas
- Use `python-dotenv` for all credentials — never hardcode secrets
- After implementing each task, run the verification commands listed at the end
- When done with a task, mark it ✅ in `PROGRESS.md`

---

## Your Role
You own the **Planner Agent**, the **Orchestrator pipeline**, and the **FastAPI**. You are the team lead.

---

## Your Files (ONLY edit these)
```
agents/planner/intent_classifier.py   ← ML intent classification
agents/planner/ner_extractor.py       ← NER entity extraction
orchestrator/pipeline.py              ← Pipeline coordinator
orchestrator/resource_predictor.py   ← Instance type recommendation
orchestrator/monitor.py               ← Log anomaly detection
api/main.py                           ← FastAPI endpoints
```

---

## 📊 Seed Dataset — Your Contribution (Week 1)
**File:** `data/seed/seed_dataset_template.csv`

The seed dataset already has **~200 rows** generated. Your job is to **add 50 more rows** focused on the `deploy_ec2` and `list_instances` intents — the ones your Planner ML model needs most.

### Use This AI Prompt to Generate Your Rows:
> Copy the prompt below → paste into any AI chat → copy the output → append to `data/seed/seed_dataset_template.csv`

```
Generate 50 diverse natural language instructions for a DevOps AI system.
Focus on these intents: deploy_ec2 (35 rows) and list_instances (15 rows).

Rules:
- Vary the phrasing heavily (launch/create/spin up/deploy/start/provision/bring up/fire up)
- Vary instance types: t2.nano, t2.micro, t2.small, t3.small, t3.medium
- Vary regions: us-east-1, us-west-2, eu-west-1
- Vary apps: nginx, apache, flask, nodejs
- Vary ports: 80, 443, 3000, 5000, 8000, 8080
- Some rows should have counts (2, 3 instances)
- Make some polite ("Can you...", "Please..."), some direct ("Deploy..."), some conversational ("I need...")

Output strictly as CSV rows with this format (no header):
"instruction",intent,instance_type,region,app,port,count,notes
```

---

## Task 1 — FastAPI Skeleton (Week 2)
**File:** `api/main.py`

Implement a FastAPI app with exactly these endpoints:

```python
GET  /health   → returns {"status": "ok", "version": "0.1.0"}
POST /deploy   → accepts DeployRequest, returns DeployResponse
```

**Pydantic models to define:**
```python
class DeployRequest(BaseModel):
    instruction: str

class DeployResponse(BaseModel):
    status: str       # "success" | "failed" | "predicted_failure"
    plan: dict
    instance_id: str
    public_ip: str
    logs: str
```

**Week 2:** `/deploy` should return a hardcoded stub response.
**Week 5:** `/deploy` calls `Pipeline().run(request.instruction)`.

**How to run and test:**
```bash
uvicorn api.main:app --reload
curl http://localhost:8000/health
```

---

## Task 2 — Intent Classifier (Week 2-3)
**File:** `agents/planner/intent_classifier.py`

### Exact Class Interface Required
```python
class IntentClassifier:
    def __init__(self):
        self.model = None
        self.label_encoder = None

    def train(self, texts: list[str], labels: list[str]) -> dict:
        # Train a TF-IDF + LogisticRegression pipeline
        # Returns: {"accuracy": float, "report": str}

    def predict(self, instruction: str) -> tuple[str, float]:
        # Returns: (intent_label, confidence_score)
        # Example: ("deploy_ec2", 0.94)

    def save(self, path: str = "models/intent_classifier.pkl") -> None:
        # Save model using joblib

    def load(self, path: str = "models/intent_classifier.pkl") -> None:
        # Load model using joblib
```

### Training Data
Use `data/seed/seed_dataset_template.csv`. The columns are:
- `instruction` → input text (X)
- `intent` → label (y)

### Recommended Implementation
```python
from sklearn.pipeline import Pipeline
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
import joblib

# Build pipeline
model = Pipeline([
    ("tfidf", TfidfVectorizer(ngram_range=(1,2))),
    ("clf", LogisticRegression(max_iter=1000))
])
```

### Acceptance Criteria
- `predict("Deploy a t2.micro EC2 with nginx")` → `("deploy_ec2", confidence > 0.8)`
- `predict("Terminate instance i-0abc")` → `("terminate_ec2", confidence > 0.8)`
- Test set accuracy ≥ 85%

---

## Task 3 — NER Extractor (Week 3)
**File:** `agents/planner/ner_extractor.py`

### Exact Class Interface Required
```python
class NERExtractor:
    def __init__(self):
        self.nlp = None  # spaCy model

    def load_model(self, model_name: str = "en_core_web_sm") -> None:
        # Load spaCy model

    def extract(self, instruction: str) -> dict:
        # Returns entities dict — missing fields default to None
        # Example return:
        # {
        #   "instance_type": "t2.micro",
        #   "region": "us-east-1",
        #   "app": "nginx",
        #   "port": 80,
        #   "count": 1,
        #   "instance_id": None
        # }
```

### Approach (Week 2: rule-based → Week 3: spaCy NER)
**Week 2 — start with regex rules:**
```python
import re

INSTANCE_TYPES = ["t2.micro", "t2.nano", "t2.small", "t3.small", "t3.medium"]
REGIONS = ["us-east-1", "us-west-2", "eu-west-1"]
APPS = ["nginx", "apache", "flask", "nodejs"]

def extract(self, instruction: str) -> dict:
    result = {"instance_type": None, "region": None, "app": None,
              "port": None, "count": 1, "instance_id": None}
    for it in INSTANCE_TYPES:
        if it in instruction: result["instance_type"] = it
    # ... etc
    return result
```

**Week 3 — upgrade to spaCy custom NER** using labelled training data.

---

## Task 4 — Orchestrator Pipeline (Week 2 stub → Week 5 full)
**File:** `orchestrator/pipeline.py`

### Exact Class Interface Required
```python
class Pipeline:
    def __init__(self):
        # Initialize all agents here

    def run(self, instruction: str) -> dict:
        # Full pipeline:
        # 1. Planner: classify intent + extract entities
        # 2. Build + validate plan JSON (see CONTRACTS.md)
        # 3. Failure prediction (call Member 2's FailurePredictor)
        # 4. If predicted failure confidence > 0.8 → return status="predicted_failure"
        # 5. EC2 provision (call Member 2's EC2Manager)
        # 6. SSH deploy (call Member 3's SSHDeployer)
        # 7. Return full result dict

    def _build_plan(self, instruction: str) -> dict:
        # Call IntentClassifier + NERExtractor
        # Return Plan JSON per CONTRACTS.md Section 2

    def _validate_plan(self, plan: dict) -> bool:
        # Validate required fields per CONTRACTS.md
        # Return True/False
```

**Week 2:** `run()` raises `NotImplementedError`
**Week 5:** Full implementation

---

## Task 5 — Resource Predictor (Week 3-4)
**File:** `orchestrator/resource_predictor.py`

### Exact Interface
```python
class ResourcePredictor:
    def recommend(self, app_type: str, expected_users: int = 10) -> dict:
        # Returns: {"recommended_instance": "t2.micro", "estimated_cost_per_hour": 0.0116}
```

**Week 3:** Rule-based lookup table is fine:
```python
RULES = {
    "nginx":   {"users": 100, "instance": "t2.micro",  "cost": 0.0116},
    "flask":   {"users": 50,  "instance": "t2.micro",  "cost": 0.0116},
    "nodejs":  {"users": 200, "instance": "t3.small",  "cost": 0.0208},
}
```

---

## How to Verify Your Work Is Done

```bash
# 1. API health check
uvicorn api.main:app --reload &
curl http://localhost:8000/health
# Expected: {"status": "ok", "version": "0.1.0"}

# 2. Test intent classifier
python3 -c "
from agents.planner.intent_classifier import IntentClassifier
clf = IntentClassifier()
clf.load()
print(clf.predict('Deploy a t2.micro EC2 with nginx'))
"
# Expected: ('deploy_ec2', 0.9+)

# 3. Test NER
python3 -c "
from agents.planner.ner_extractor import NERExtractor
ner = NERExtractor()
ner.load_model()
print(ner.extract('Deploy a t2.micro EC2 with nginx in us-east-1'))
"
# Expected: {'instance_type': 't2.micro', 'region': 'us-east-1', 'app': 'nginx', ...}

# 4. Run tests
pytest tests/test_planner.py -v
```

---

## Important Rules
- Never hardcode AWS credentials — use `python-dotenv` and load from `.env`
- Never commit `.env` or model `.pkl` files
- Update `PROGRESS.md` when you complete each task
- If Member 2 or 3 reports a bug in your code, fix it within 24 hours
