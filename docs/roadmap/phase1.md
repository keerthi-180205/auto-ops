# 📅 Phase 1 — Working E2E Pipeline

## Timeline: Month 1–2

## Goal
Build a working end-to-end deployment pipeline: User types "deploy flask app" → EC2 created → Flask running → Public URL returned.

## Deliverables

### Member 1 (API + Orchestrator)
- [ ] FastAPI app with POST /deploy endpoint
- [ ] Orchestrator engine that calls Planner → Executor
- [ ] Request validation and error handling
- [ ] Basic logging

### Member 2 (Agents)
- [ ] Planner Agent: rule-based prompt → plan conversion
- [ ] Executor Agent: calls infra modules to deploy
- [ ] Error handling in both agents

### Member 3 (Infrastructure)
- [ ] EC2 creation via boto3 (create_instance, get_public_ip)
- [ ] Flask deployment via SSH (Paramiko)
- [ ] Security group configuration (ports 22, 5000)
- [ ] deploy_flask.sh script
- [ ] Terraform config (optional)

### Member 4 (Frontend + Testing)
- [ ] Basic React UI with prompt input and result display (optional)
- [ ] End-to-end test cases with pytest
- [ ] API testing with Postman
- [ ] Documentation of test results

## Success Criteria
- User sends POST /deploy with prompt "deploy flask app"
- EC2 instance is created on AWS
- Flask app is deployed and running
- Public URL is returned and accessible in browser
