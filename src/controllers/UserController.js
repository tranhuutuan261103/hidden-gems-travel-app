const UserService = require("../services/UserService.js");

module.exports = {
    registerUser: async (req, res) => {
        try {
            const { name, email, password, hashPassword, role } = req.body;

            const user = await UserService.register({ name, email, password, hashPassword, role });
            res.json(user);
        } catch (error) {
            console.log(error);
            res.json({ message: error.message });
        }
    },

    loginUser: async (req, res) => {
        try {
            const { email, password } = req.body;
            const user = await UserService.login(email, password);
            res.json(user);
        } catch (error) {
            res.json({ message: error.message });
        }
    },
};