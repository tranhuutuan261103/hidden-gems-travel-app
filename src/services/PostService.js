const Post = require("../models/Post.js");
const Category = require("../models/Category.js");
const User = require("../models/User.js");

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

    // getAll: async (longitude, latitude, categoryId, limit = 10) => {
    //     try {
    //         let posts = categoryId ?
    //             await Post.find().populate('category')
    //                 .where('longitude').gte(parseFloat(longitude) - 1).lte(parseFloat(longitude) + 1)
    //                 .where('latitude').gte(parseFloat(latitude) - 1).lte(parseFloat(latitude) + 1)
    //                 .where('category').equals(categoryId)
    //                 .limit(parseInt(limit))
    //             : await Post.find().populate('category')
    //                 .where('longitude').gte(parseFloat(longitude) - 1).lte(parseFloat(longitude) + 1)
    //                 .where('latitude').gte(parseFloat(latitude) - 1).lte(parseFloat(latitude) + 1)
    //                 .limit(parseInt(limit));
    //         return posts;
    //     } catch (error) {
    //         throw new Error(error);
    //     }
    // },

    getAll: async (longitude, latitude, maxDistance, categoryId, limit = 10) => {
        try {
            let posts = categoryId ?
                await Post.find().populate('category')
                    .where('category').equals(categoryId)
                : await Post.find().populate('category');

            let result = [];
            result = posts.map( post => {
                let distance = Math.sqrt(Math.pow(post.longitude - longitude, 2) + Math.pow(post.latitude - latitude, 2));
                return {
                    ...post._doc,
                    distance
                };
            });

            result = result.filter(post => post.distance <= maxDistance);

            result.sort((a, b) => a.distance - b.distance);

            return result.slice(0, limit);
        } catch (error) {
            throw new Error(error);
        }
    },

    getAllFound: async (postIds) => {
        try {
            const posts = await Post.find().populate('category').where('_id').in(postIds);
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