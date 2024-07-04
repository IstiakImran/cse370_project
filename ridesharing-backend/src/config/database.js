import mysql from "mysql2"
import dotenv from "dotenv"
dotenv.config()

//Create a connection pool to the database
const pool = mysql.createPool({
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USER,
    password: process.env.MYSQL_PASSWORD,
    database: process.env.MYSQL_NAME,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
  }).promise();
  
  pool.getConnection((err, connection) => {
    if (err) {
      console.error('Error connecting to the database:', err.message);
    } else {
      console.log('Connected to the database');
      connection.release();
    }
  });
  



export {
    pool
  };