# 📅 Phase 2 — Intelligence & Monitoring

## Timeline: Month 3–5

## Goal
Add intelligent agents (Validation, FinOps, Monitoring) and build a production-grade dashboard. Transform the basic pipeline into a smart, cost-aware, observable system.

## New Features

### Validation Agent
- [ ] Validate deployment plans before execution
- [ ] Check instance type availability in target region
- [ ] Verify security group rules are safe
- [ ] Return pass/fail with specific error messages

### FinOps Agent
- [ ] Estimate deployment cost before execution
- [ ] Suggest cheaper alternatives (Spot Instances, smaller types)
- [ ] Compare On-Demand vs Reserved pricing
- [ ] Show cost breakdown (compute, storage, data transfer)

### Monitoring Agent
- [ ] Track CPU, memory, disk usage on deployed instances
- [ ] Collect application logs
- [ ] Health check monitoring (HTTP uptime)
- [ ] Alert on threshold breaches

### Human-in-the-Loop Approval
- [ ] Risk scoring (Low / Medium / High)
- [ ] Auto-approve low-risk operations
- [ ] Require manual approval for medium/high risk
- [ ] Approval UI in dashboard

### Dashboard (React)
- [ ] Deployment list with status
- [ ] Deployment detail view (logs, metrics)
- [ ] Cost overview
- [ ] Approval queue

### Database
- [ ] PostgreSQL for storing deployments, tasks, logs
- [ ] SQLAlchemy ORM models
- [ ] Alembic migrations

## Success Criteria
- Multiple agents working in a pipeline
- Cost shown before deployment
- Monitoring dashboard live
- Approval flow for risky operations
