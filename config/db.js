const mysql = require("mysql2");

const db = mysql.createConnection({
    host: "localhost",
    user: "root",  
    password: "", 
    database: "dormCheck"
});

db.connect((err) => {
    if (err) {
        console.error("MySQL connection error " + err.message);
    } else {
        console.log("Database connection established.");
    }
});

module.exports = db;