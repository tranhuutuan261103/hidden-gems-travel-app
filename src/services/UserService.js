const User = require('../models/User.js');
const bcrypt = require("bcrypt");
const { unlock } = require('../routes/post.js');

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
    },

    getUserInfoDetail: async (userId) => {
        try {
            const user = await User.findById(userId);
            return user;
        } catch (error) {
            throw new Error(error);
        }
    },

    updatePostsFound: async (userId, postIds) => {
        try {
            const userInfo = await User.findById(userId);
            postIds = postIds.filter(postId => !userInfo.postsFound.includes(postId));
            await User.findByIdAndUpdate(userId, { $push: { postsFound: { $each: postIds } } });
            return;
        } catch (error) {
            throw new Error(error);
        }
    },

    getUnlockPost: async (userId) => {
        try {
            const userInfo = await User.findById(userId);
            return userInfo.postsUnlocked;
        } catch (error) {
            throw new Error(error);
        }
    },

    unlockPost: async (postId, userId) => {
        try {
            const userInfo = await User.findById(userId);
            if (!userInfo.postsUnlocked.includes(postId)) {
                await User.findByIdAndUpdate(userId, { $push: { postsUnlocked: postId } });
            }
            return;
        } catch (error) {
            throw new Error(error);
        }
    },

    markArrived: async (postId, userId) => {
        const userInfo = await User.findById(userId);
        if (!userInfo.postsArrived.includes(postId)) {
            return await User.findByIdAndUpdate(userId, {
                $push: { postsArrived: postId },
            });
        }
        return userInfo;
    },
};