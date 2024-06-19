const User = require('../models/User.js');

module.exports = {
    register: async (data) => {
        try {
            const user = new User(data);
            await user.save();
            return user;
        } catch (error) {
            throw new Error(error);
        }
    },

    login: async (email, password) => {
        try {
            const user = await User.findOne({ email, password });
            return user;
        } catch (error) {
            throw new Error(error);
        }
    }
};