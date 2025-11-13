import pool from "../config/db.js";

interface CreateTaskParams {
    name: string;
    description?: string;
    run_at: Date;
    priority?: number;
    cron_expr?: string;
    max_retries?: number;
}

export const createTask = async (params: CreateTaskParams) => {
    const { name, description, run_at, priority = 0, cron_expr, max_retries = 0 } = params;
    const result = await pool.query(
        'INSERT INTO app.tasks (name, description, run_at, priority, cron_expr, max_retries) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
        [name, description, run_at, priority, cron_expr, max_retries]
    );
    return result.rows[0];
};

export const getTasksWithFilters = async (status?: string, ready?: boolean, limit: number = 10, offset: number = 0) => {
    const result = await pool.query(
        `SELECT id, name, description, run_at, status, priority, created_at, updated_at
FROM app.tasks
WHERE
  ($1::text IS NULL OR status = $1::app.task_status)
  AND ($2::boolean IS FALSE OR (status = 'pending' AND run_at <= NOW()))
ORDER BY run_at ASC
LIMIT $3 OFFSET $4`,
        [status, ready, limit, offset]
    );
    return result.rows;
};
