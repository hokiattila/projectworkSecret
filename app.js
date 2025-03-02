const express = require("express");
const app = express();
const path = require("path");
const bodyParser = require("body-parser");
const db = require("./config/db");

app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));

app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, "public")));

const homeRoutes = require("./routes/index");
const apiRoutes = require("./routes/api");
app.use("/", homeRoutes);
app.use("/api", apiRoutes);

const PORT = process.env.PORT || 3333;
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});