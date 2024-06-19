const UserService = require("../services/UserService.js");
const jwt = require("jsonwebtoken");

module.exports = {
    registerUser: async (req, res) => {
        try {
            const { name, email, password, hashPassword, role } = req.body;

            const user = await UserService.register({ name, email, password, hashPassword, role });
            if (user) {
                const token = jwt.sign({ _id: user._id, email: user.email, role: user.role },
                    process.env.JWT_SECRET, { expiresIn: '1h' });
                return res.json({ token });
            }
            return res.json({
                code: 401,
                message: "User not created"
            }
            );
        } catch (error) {
            console.log(error);
            res.json({ message: error.message });
        }
    },

    loginUser: async (req, res) => {
        try {
            const { email, password } = req.body;
            const user = await UserService.login(email, password);
            if (user) {
                const token = jwt.sign({ _id: user._id, email: user.email, role: user.role },
                    process.env.JWT_SECRET, { expiresIn: '1h' });
                return res.json({ token });
            }
            return res.json({
                code: 401,
                message: "Email or password is incorrect"
            });
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    getUserInfo: async (req, res) => {
        try {
            const { _id } = req.user;
            const user = await UserService.getUserInfo(_id);
            res.json(user);
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    logoutUser: async (req, res) => {
        try {
            res.json({ message: "Logout success" });
        } catch (error) {
            res.json({ message: error.message });
        }
    }
};