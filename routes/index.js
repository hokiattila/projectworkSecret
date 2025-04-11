const express = require("express");
const router = express.Router();
const homeController = require("../controllers/homeController");

router.get("/", homeController.index);
router.get('/entry', (req, res) => {
    res.render('entry');
});
module.exports = router;
