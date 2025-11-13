import * as taskModel from "../models/taskModel.js";
import { Request, Response, NextFunction } from "express";

export const createTaskController = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { name, description, run_at, priority, cron_expr, max_retries } = req.body;
        const task = await taskModel.createTask({
            name,
            description,
            run_at: new Date(run_at),
            priority,
            cron_expr,
            max_retries
        });
        res.status(201).json(task);
    } catch (error) {
        next(error);
    }
};
