const PostService = require("../services/PostService.js");
const UserService = require("../services/UserService.js");

module.exports = {
    createPost: async (req, res) => {
        try {
            const { description, longitude, latitude, address, images, star, categoryId } = req.body;
            const post = await PostService.create({ description, longitude, latitude, address, images, star, categoryId });
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
            res.json(posts);
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
            res.json(post);
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    updatePost: async (req, res) => {
        try {
            const { id } = req.params;
            const { description, longitude, latitude, address, images, star } = req.body;
            const post = await PostService.update(id, { description, longitude, latitude, address, images, star });
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
    }
};