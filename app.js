const express = require("express");
const http = require("http");
const WebSocket = require("ws");
const path = require("path");
const bodyParser = require("body-parser");
const db = require("./config/db");

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

// View engine beállítás
app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));

// Middleware
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, "public")));

// Route-ok
const homeRoutes = require("./routes/index");
const apiRoutes = require("./routes/api");

app.use("/", homeRoutes);
app.use("/api", apiRoutes);

const PORT = process.env.PORT || 3333;

// WebSocket kezelése
wss.on('connection', (ws) => {
    console.log("New WebSocket client connected");
});

// Real-time log figyelés check_time alapján
let lastCheckTime = "1970-01-01 00:00:00"; // induláskor a legrégebbi idő

setInterval(() => {
    db.query(`
        SELECT c.*, u.firstname, u.lastname 
        FROM CARDCHECKS c
        LEFT JOIN USER u ON c.userid = u.userid
        WHERE c.check_time > ?
        ORDER BY c.check_time ASC
    `, [lastCheckTime], (err, results) => {
        if (err) {
            console.error("DB error: ", err);
            return;
        }

        if (results.length > 0) {
            results.forEach(record => {
                lastCheckTime = record.check_time; // Frissítjük az utolsó időpontot

                let message = "";

                if (record.cardid === "UNKNOWN" && record.userid === -1) {
                    message = `Ismeretlen kártyával próbáltak belépni! - ${record.check_time}`;
                } else if (record.cardid !== "UNKNOWN" && record.userid === -1) {
                    message = `Tulajdonos nélküli kártyával próbáltak meg belépni! - ${record.check_time}`;
                } else if (record.cevent === "ENTRY") {
                    message = `${record.firstname} ${record.lastname} - Belépett! - ${record.check_time}`;
                }

                // Üzenet küldése az összes websocket kliensnek
                wss.clients.forEach(client => {
                    if (client.readyState === WebSocket.OPEN) {
                        client.send(message);
                    }
                });
            });
        }
    });
}, 1000); // 1 másodpercenként

// Szerver indítása
server.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
