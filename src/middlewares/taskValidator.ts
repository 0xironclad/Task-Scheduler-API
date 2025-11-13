import Joi from "joi";
import { Request, Response, NextFunction } from "express";

const createTaskSchema = Joi.object({
    name: Joi.string().required().min(2),
    description: Joi.string().optional(),
    run_at: Joi.date().required(),
    priority: Joi.number().integer().default(0),
    cron_expr: Joi.string().optional(),
    max_retries: Joi.number().integer().min(0).default(0)
});

const updateTaskSchema = Joi.object({
    name: Joi.string(),
    description: Joi.string(),
    run_at: Joi.date(),
    status: Joi.string().valid('pending', 'running', 'done', 'failed', 'canceled'),
    priority: Joi.number().integer(),
    cron_expr: Joi.string(),
    max_retries: Joi.number().integer().min(0)
}).min(1);

export const validateCreateTask = (req: Request, res: Response, next: NextFunction) => {
    const { error } = createTaskSchema.validate(req.body);
    if (error) {
        return res.status(400).json({ error: error.details[0].message });
    }
    next();
};

export const validateUpdateTask = (req: Request, res: Response, next: NextFunction) => {
    const { error } = updateTaskSchema.validate(req.body);
    if (error) {
        return res.status(400).json({ error: error.details[0].message });
    }
    next();
};
