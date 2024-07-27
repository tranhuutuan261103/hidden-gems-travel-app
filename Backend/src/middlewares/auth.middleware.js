const jwt = require("jsonwebtoken");

async function Validate(req, res, next) {
    try {
        const token = req.headers.authorization.substring(7);
        if (!token) {
            return res.status(401).send({ message: "Token not found" });
        }

        const user = await jwt.verify(token, process.env.JWT_SECRET);

        if (!user) {
            return res.status(401).send({ message: "Token invalid" });
        }

        req.user = user;
        
        next();
    } catch (error) {
        return res.status(401).send({ message: "Token invalid" });
    }
}

module.exports = { Validate };