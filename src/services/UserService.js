const User = require('../models/User.js');
const bcrypt = require("bcrypt")

module.exports = {
    register: async (data) => {
        try {
            const salt = await bcrypt.genSalt(10);
            const hashedPassword = await bcrypt.hash(data.password, salt);
            const user = new User({
                name: data.name,
                email: data.email,
                password: data.password,
                hashedPassword: hashedPassword,
                role: data.role
            });
            await user.save();
            return user;
        } catch (error) {
            throw new Error(error);
        }
    },

    login: async (email, password) => {
        try {
            const user = await User.findOne({ email });
            if (!user) {
                throw new Error("User not found");
            }
            const validPassword = await bcrypt.compare(password, user.hashedPassword);
            if (!validPassword) {
                throw new Error("Password is incorrect");
            }
            return user;
        } catch (error) {
            throw new Error(error);
        }
    },

    getUserInfo: async (userId) => {
        try {
            const user = await User.findById(userId);
            return user;
        } catch (error) {
            throw new Error(error);
        }
    }
};