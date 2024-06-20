const Post = require("../models/Post.js");
const Category = require("../models/Category.js");

module.exports = {
    create: async (data) => {
        try {
            const category = await Category.findById(data.categoryId);
            if (!category) {
                throw new Error('Category not found');
            }
            const post = new Post({
                ...data,
                category: category._id,
                votes: []
            });
            await post.save();
            return post;
        } catch (error) {
            throw new Error(error);
        }
    },

    getAll: async (limit = 10, page = 1) => {
        try {
            const posts = await Post.find().populate('category').limit(limit * 1).skip((page - 1) * limit).exec();
            return posts;
        } catch (error) {
            throw new Error(error);
        }
    },

    getOne: async (id) => {
        try {
            const post = await Post.findById(id).populate('category');
            return post;
        } catch (error) {
            throw new Error(error);
        }
    },

    update: async (id, data) => {
        try {
            const post = await Post.findByIdAndUpdate(id, data, {
                new: true
            });
            return post;
        } catch (error) {
            throw new Error(error);
        }
    },

    delete: async (id) => {
        try {
            await Post.findByIdAndDelete(id);
        } catch (error) {
            throw new Error(error);
        }
    }
};