const User = require('../models/User.js');
const bcrypt = require("bcrypt");
const { Schema, get } = require('mongoose');

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
            const user = await User.findById(userId).populate('postsFound').populate('postsUnlocked').populate('postsArrived');
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
                return true;
            }
            return false;
        } catch (error) {
            throw new Error(error);
        }
    },

    getPostArrived: async (userId) => {
        try {
            const userInfo = await User.findById(userId);
            return userInfo.postsArrived;
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

    increasePoints: async (userId, points) => {
        try {
            const userInfo = await User.findById(userId);
            if (userInfo.points === undefined) {
                await User.findByIdAndUpdate(userId, { points: points });
            } else {
                await User.findByIdAndUpdate(userId, { points: userInfo.points + points });
            }
            return await User.findById(userId);
        } catch (error) {
            throw new Error(error);
        }
    },

    decreasePoints: async (userId, points) => {
        try {
            const userInfo = await User.findById(userId);
            if (userInfo.points === undefined) {
                await User.findByIdAndUpdate(userId, { points: 0 });
            } else {
                if (userInfo.points < points) {
                    throw new Error("Not enough points");
                } else {
                    await User.findByIdAndUpdate(userId, { points: userInfo.points - points });
                }
            }
        } catch (error) {
            throw new Error(error);
        }
    },

    getPoints: async (userId) => {
        try {
            const userInfo = await User.findById(userId);
            return userInfo.points;
        } catch (error) {
            throw new Error(error);
        }
    },

    getLeaderboard: async (limit) => {
        try {
            const users = await User.find().sort({ points: -1 });
            if (limit) {
                return users.slice(0, limit).map(user => {
                    return {
                        _id: user._id,
                        name: user.name,
                        points: user.points,
                    };
                });
            }
            return users.map(user => {
                return {
                    _id: user._id,
                    name: user.name,
                    points: user.points,
                };
            });
        } catch (error) {
            throw new Error(error);
        }
    },
};