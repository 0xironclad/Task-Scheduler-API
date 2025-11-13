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
