const PostService = require("../services/PostService.js");
const UserService = require("../services/UserService.js");
const CommentService = require("../services/CommentService.js");
const StorageService = require("../services/StorageService.js");

module.exports = {
    createPost: async (req, res) => {
        try {
            const userId = req.user._id;
            if (!req.files) {
                res.json({ message: "Image is required" });
                return;
            }
            const imageUrls = await StorageService.uploadMultiple(req.files, "Posts");
            const { title, content, longitude, latitude, address, star, categoryId } = req.body;
            const post = await PostService.create({ title, content, longitude, latitude, address, images: imageUrls, star, categoryId, createdBy: userId});
            res.json(post);
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    getAllPost: async (req, res) => {
        try {
            const { longitude, latitude, categoryId, limit } = req.query;
            const userId = req.user._id;
            const posts = await PostService.getAll(longitude, latitude, categoryId, limit);
            await UserService.updatePostsFound(userId, posts.map(post => post._id));

            const userInfo = await UserService.getUserInfo(userId);
            const postsUnlocked = userInfo.postsUnlocked;
            const postsArrived = userInfo.postsArrived;
            let result = [];
            for (let post of posts) {
                if (postsUnlocked.includes(post._id)) {
                    result.push({ ...post._doc, isUnlocked: true });
                } else {
                    result.push({ ...post._doc, isUnlocked: false });
                }

                if (postsArrived.includes(post._id)) {
                    result[result.length - 1].isArrived = true;
                } else {
                    result[result.length - 1].isArrived = false;
                }
            }
            res.json(result);
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    getAllPostFound: async (req, res) => {
        try {
            const userId = req.user._id;
            const user = await UserService.getUserInfo(userId);
            const posts = await PostService.getAllFound(user.postsFound);
            res.json(posts);
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    getPost: async (req, res) => {
        try {
            const { id } = req.params;
            const post = await PostService.getOne(id);
            if (!post) {
                res.json({ message: "Post not found" });
                return;
            }
            const userId = req.user._id;

            const userInfo = await UserService.getUserInfo(userId);
            const postsUnlocked = userInfo.postsUnlocked;
            const postsArrived = userInfo.postsArrived;
            let result = post;

            if (postsUnlocked.includes(post._id)) {
                result = { ...post._doc, isUnlocked: true };
            } else {
                result = { ...post._doc, isUnlocked: false };
            }

            if (postsArrived.includes(post._id)) {
                result.isArrived = true;
            } else {
                result.isArrived = false
            }

            res.json(result);
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    updatePost: async (req, res) => {
        try {
            const { id } = req.params;
            const { title, content, longitude, latitude, address, images, star } = req.body;
            const post = await PostService.update(id, { title, content, longitude, latitude, address, images, star });
            res.json(post);
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    deletePost: async (req, res) => {
        try {
            const { id } = req.params;
            await PostService.delete(id);
            res.json({ message: "Post deleted" });
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    getUnlockPost: async (req, res) => {
        try {
            const userId = req.user._id;
            const posts = await UserService.getUnlockPost(userId);
            res.json(posts);
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    unlockPost: async (req, res) => {
        try {
            const { id } = req.params;
            const userId = req.user._id;
            const post = await PostService.getOne(id);
            if (!post) {
                res.json({ message: "Post not found" });
                return;
            }
            await UserService.unlockPost(id, userId);
            res.json({ message: "Unlocked post" });
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    markArrived: async (req, res) => {
        try {
            const { id } = req.params;
            const userId = req.user._id;
            const post = await PostService.getOne(id);
            if (!post) {
                res.json({ message: "Post not found" });
                return;
            }
            const userInfo = await UserService.getUserInfo(userId);
            if (!userInfo.postsFound.includes(id)) {
                res.json({ message: "You have not found this post" });
                return;
            }
            await UserService.markArrived(id, userId);
            res.json({ message: "Marked arrived" });
        } catch (error) {
            res.json({ message: error.message });
        }
    }
};