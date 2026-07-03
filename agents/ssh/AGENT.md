# 🤖 SSH Agent — Module Ownership

## Owner
**Member 3**

## What This Module Does
The SSH Agent connects to a newly created EC2 instance via SSH (using Paramiko) and:
1. **Deploys the application** — runs install commands and starts the app
2. Returns deployment logs back to the Orchestrator

## Files You Own
| File | Purpose |
|------|---------|
| `deployer.py` | SSH connection + deployment logic using Paramiko |

## Input / Output Contract
- **Input:** EC2 connection info from Executor — see `CONTRACTS.md` Section 3
- **Output:** Deployment result — see `CONTRACTS.md` Section 4

## 🚫 Boundary Rules
- Members 1 & 2: **DO NOT edit any files in this folder**
- You do NOT write AWS/boto3 code — that's `agents/executor/` (Member 2)
- You do NOT write ML models — ML lives in `agents/planner/` and `agents/executor/`
- If you encounter a bug here, open a GitHub Issue and tag Member 3

## 🐛 Found a Bug? Report It Like This
```
Title: [BUG] ssh — <short description>
Body:
  - EC2 IP attempted: x.x.x.x
  - SSH key path used: ...
  - Command that failed: ...
  - Full error output: ...
```

## Done Means
- `SSHDeployer.connect(host, username, key_path)` opens SSH session without error
- `SSHDeployer.deploy(plan, host)` installs + starts the app and returns `{"success": True, "logs": "..."}`
- `SSHDeployer.run_command("uptime")` returns `(stdout, stderr)` tuple
- Works reliably for apps: `nginx`, `apache`, `flask`, `nodejs`
