# 🤖 Planner Agent — Module Ownership

## Owner
**Member 1 (Team Lead)**

## What This Module Does
The Planner Agent is the brain of AutoOps AI. It takes a raw natural language instruction from a user and converts it into a structured Plan JSON using two ML models:
1. **Intent Classifier** — classifies what the user wants (e.g., `deploy_ec2`, `terminate_ec2`)
2. **NER Extractor** — extracts entities (instance type, region, app, port) from the instruction

## Files You Own
| File | Purpose |
|------|---------|
| `intent_classifier.py` | scikit-learn / transformer intent classification model |
| `ner_extractor.py` | spaCy NER model for entity extraction |

## Input / Output Contract
- **Input:** `instruction: str` — raw natural language from the user
- **Output:** Plan JSON — see `CONTRACTS.md` Section 2 for exact schema

## 🚫 Boundary Rules
- Members 2 & 3: **DO NOT edit any files in this folder**
- If you encounter a bug here, open a GitHub Issue and tag Member 1

## 🐛 Found a Bug? Report It Like This
```
Title: [BUG] planner — <short description>
Body:
  - Input instruction: "..."
  - Expected plan JSON: { ... }
  - Actual output / error: ...
  - Your environment: Python X.X, OS
```

## Done Means
- `IntentClassifier.predict("Deploy a t2.micro with nginx")` returns `"deploy_ec2"`
- `NERExtractor.extract("Deploy a t2.micro with nginx in us-east-1")` returns `{"instance_type": "t2.micro", "region": "us-east-1", "app": "nginx"}`
- Model accuracy ≥ 85% on held-out test set
