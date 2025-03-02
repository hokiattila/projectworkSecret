const db = require("../config/db");

class CardModel {
    static getRoomByCardId(cardid) {
        return new Promise((resolve, reject) => {
            const sql = `
                SELECT roomid
                FROM room
                WHERE cardid = ?`;
            db.query(sql, [cardid], (err, results) => {
                if (err) {
                    reject(err);
                } else {
                    resolve(results.length > 0 ? results[0] : null);
                }
            });
        });
    }

    static addCardCheck(userid, cardid, event) {
        return new Promise((resolve, reject) => {
            const sql = "INSERT INTO CARDCHECKS (roomid, cardid, cevent, ctimestamp) VALUES (?, ?, ?, NOW())";
            db.query(sql, [userid, cardid, event], (err, result) => {
                if (err) {
                    reject(err);
                } else {
                    resolve(result.insertId);
                }
            });
        });
    }
}

module.exports = CardModel;
