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


export const getAllTasksController = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const status = req.query.status as string | undefined;
        const ready = req.query.ready === 'true';
        const limit = parseInt(req.query.limit as string) || 10;
        const offset = parseInt(req.query.offset as string) || 0;

        const tasks = await taskModel.getTasksWithFilters(status, ready, limit, offset);
        res.status(200).json(tasks);
    } catch (error) {
        next(error);
    }
};
