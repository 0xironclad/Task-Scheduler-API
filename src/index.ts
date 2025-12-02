import "dotenv/config";
import express, { Request, Response } from "express";
import * as test_database from "./data/testDb.js"
import errorHandler from "./middlewares/errorHandler.js";
import taskRouter from "./routes/TaskRoute.js";
import cron from "node-cron";

const app = express();
const port = 3000;

app.use(express.json());
app.use(errorHandler);
app.use("/api/v1/", taskRouter);

app.get("/", (_req: Request, res: Response) => {
    res.json({
        message: "Hello World"
    });
});

cron.schedule('* * * * *', () => {
    console.log('Cron job running every minute!');
    test_database.getNow();
});

test_database.getNow()
app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
