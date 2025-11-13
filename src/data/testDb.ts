import pool from "../config/db.js";

export const getNow = async () => {
  const result = await pool.query("SELECT NOW()");
  console.log(result.rows[0]);
};
