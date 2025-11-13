import * as taskController from "../controller/taskController.js";
import { validateCreateTask, validateUpdateTask } from "../middlewares/taskValidator.js";
import express from "express";

const taskRouter = express.Router();

taskRouter.get("/tasks", taskController.getAllTasksController);
// taskRouter.get("/tasks/:id", taskController.getTaskById);
taskRouter.post("/tasks", validateCreateTask, taskController.createTaskController);
// taskRouter.put("/tasks/:id", validateUpdateTask, taskController.updateTask);
// taskRouter.delete("/tasks/:id", taskController.deleteTask);

export default taskRouter;
