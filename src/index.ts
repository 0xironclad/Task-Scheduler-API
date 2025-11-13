import "dotenv/config";
import express, { Request, Response } from "express";
import * as test_database from "./data/testDb.js"

const app = express();
const port = 3000;

app.use(express.json());

app.get("/", (_req: Request, res: Response) => {
    res.json({
        message: "Hello World"
    });
});

test_database.getNow()
app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
