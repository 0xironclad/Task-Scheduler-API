#!/usr/bin/env bash
set -euo pipefail

REPO="0xironclad/Task-Scheduler-API"


create_issue () {
  local title="$1"
  local labels="$2"
  local body="$3"
  if [[ -n "$REPO" ]]; then
    gh issue create --repo "$REPO" --title "$title" --body "$body" ${labels:+--label "$labels"}
  else
    gh issue create --title "$title" --body "$body" ${labels:+--label "$labels"}
  fi
}

# title | labels (comma-separated) | body
# Tip: keep lines under ~10k chars
while IFS="|" read -r TITLE LABELS BODY; do
  # skip empty/comment lines
  [[ -z "${TITLE// }" || "${TITLE:0:1}" == "#" ]] && continue
  create_issue "$(echo "$TITLE" | xargs)" "$(echo "$LABELS" | xargs)" "$(echo "$BODY" | sed 's/\\n/\n/g')"
done <<'ISSUES'
# ---- Epic: Core Project Setup ----
Initialize Express app | epic,setup | Create a minimal Express server with a health check at `GET /health`. Add `src/`, basic logger, and error middleware.
Set up PostgreSQL connection | epic,setup,db | Install `pg`. Add env config (`DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`). Test with a simple `SELECT NOW()`.
Project scaffolding | setup,dx | Add `.env.example`, `.gitignore`, README outline, and optional ESLint + Prettier + nodemon.

# ---- Epic: Task Management ----
Create DB schema | db,migration | Create `tasks` table: `id SERIAL PK, name TEXT NOT NULL, description TEXT, run_at TIMESTAMP NOT NULL, status TEXT DEFAULT 'pending', created_at TIMESTAMP DEFAULT NOW()`. Optionally add migration tooling.
Implement POST /tasks | api | Validate payload (`name`, `run_at`). Insert new task. Return created task.
Implement GET /tasks with filters | api | Support `status` and `due=true` query params. Paginate with `limit` & `offset`.
Implement PATCH /tasks/:id | api | Allow rescheduling (`run_at`), updating `name/description`, or changing `status`.
Implement DELETE /tasks/:id | api | Soft delete or hard delete; document behavior in README.

# ---- Epic: Scheduler Logic ----
Integrate node-cron | scheduler | Install `node-cron`. Add a job that runs every minute.
Execute due tasks | scheduler,logic | Query `pending` tasks with `run_at <= now()`. Mark as `running`, simulate execution, then `done`. Handle failures → `failed`.
Add task_logs table | db | Create `task_logs(id SERIAL PK, task_id INT FK, executed_at TIMESTAMP DEFAULT NOW(), status TEXT, message TEXT)`. Write a log per run.
Idempotency guard | scheduler,robustness | Ensure a task can’t be double-picked by two processes. Use `FOR UPDATE SKIP LOCKED` or atomic status transition.

# ---- Epic: Testing & Quality ----
Seed script | dx | Add a script to insert sample tasks due in the next few minutes for manual testing.
Error handling middleware | api,dx | Centralize JSON error responses with consistent shape `{error:{message,code}}`.
Basic tests | test | Add minimal tests for `POST /tasks` validation and scheduler selection logic.

# ---- Optional / Nice-to-haves ----
Recurring tasks (MVP) | enhancement,recurrence | Add nullable `cron_expr TEXT`. If present, after execution, compute next `run_at`. Validate with a cron parser.
GET /tasks/upcoming | api | Return tasks scheduled in the next N minutes (`?window=60`). Useful for UIs.
Dockerize app + db | devops | Add `Dockerfile` and `docker-compose.yml` for app + Postgres. Provide `make up/down/logs`.
Health & readiness probes | ops | `GET /health` (app up) and `GET /ready` (DB reachable). Useful for containers.
Add OpenAPI spec | docs,api | Document endpoints, payloads, and error shapes in a `openapi.yaml`. Optional Swagger UI.
ISSUES

echo "All issues created."
