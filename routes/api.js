const express = require("express");
const router = express.Router();
const CardModel = require("../models/CardModel");  

router.get("/card/:cardid", async (req, res) => {
    const { cardid } = req.params;

    if (!cardid || cardid.trim() === "") {
        return res.status(400).json({ error: "Card identifier needs to be provided!" });
    }

    try {
        const room = await CardModel.getRoomByCardId(cardid);
        res.json(room ? room : {});
    } catch (err) {
        console.error("Database error: ", err);
        res.status(500).json({ error: "Server error" });
    }
});

router.post("/card", async (req, res) => {
    const { userid, cardid, event } = req.body;

    if (!userid || !cardid || cardid.trim() === "") {
        return res.status(400).json({ error: "User ID and Card ID needs to be provided!" });
    }

    try {
        const result = await CardModel.addCardCheck(userid, cardid, event);
        res.status(201).json({ message: "Login attempt saved." });
    } catch (err) {
        console.error("Database error ", err);
        res.status(500).json({ error: "Server error" });
    }
});

module.exports = router;
