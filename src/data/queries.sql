CREATE TYPE app.task_status AS ENUM ('pending','running','done','failed','canceled');
CREATE TYPE app.task_result AS ENUM ('success','error','skipped');


-- tasks
CREATE TABLE IF NOT EXISTS app.tasks (
  id              BIGSERIAL PRIMARY KEY,
  name            TEXT NOT NULL,
  description     TEXT,
  run_at          TIMESTAMPTZ NOT NULL,
  status          app.task_status NOT NULL DEFAULT 'pending',
  priority        SMALLINT NOT NULL DEFAULT 0,          -- higher can go first
  cron_expr       TEXT,                                  -- nullable: for future recurring tasks
  max_retries     SMALLINT NOT NULL DEFAULT 0,
  retry_count     SMALLINT NOT NULL DEFAULT 0,
  locked_at       TIMESTAMPTZ,                           -- for worker lock
  locked_by       TEXT,                                  -- worker id/hostname
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_tasks_due ON app.tasks (status, run_at);
CREATE INDEX IF NOT EXISTS idx_tasks_priority ON app.tasks (priority DESC, run_at);




-- task logs
CREATE TABLE IF NOT EXISTS app.task_logs (
  id            BIGSERIAL PRIMARY KEY,
  task_id       BIGINT NOT NULL REFERENCES app.tasks(id) ON DELETE CASCADE,
  attempt       INT NOT NULL DEFAULT 1,
  started_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  finished_at   TIMESTAMPTZ,
  result        app.task_result,
  message       TEXT
);

CREATE INDEX IF NOT EXISTS idx_task_logs_task_id ON app.task_logs (task_id);


CREATE OR REPLACE FUNCTION app.touch_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END; $$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_tasks_touch ON app.tasks;

CREATE TRIGGER trg_tasks_touch
BEFORE UPDATE ON app.tasks
FOR EACH ROW
EXECUTE FUNCTION app.touch_updated_at();
