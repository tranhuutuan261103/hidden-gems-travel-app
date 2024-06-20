const PostService = require("../services/PostService.js");

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
            const { limit, page } = req.query;
            const posts = await PostService.getAll(limit, page);
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