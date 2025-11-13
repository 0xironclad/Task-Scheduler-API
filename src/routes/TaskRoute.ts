import { createTaskController } from "../controller/taskController.js";
import { validateCreateTask } from "../middlewares/taskValidator.js";
import express from "express";

const taskRouter = express.Router()

taskRouter.post("/tasks/create", validateCreateTask,  createTaskController)



export default taskRouter
