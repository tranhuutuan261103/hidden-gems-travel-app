const Comment = require("../models/Comment.js");
const Post = require("../models/Post.js");

module.exports = {
    create: async (data) => {
        try {
            const post = await Post.findById(data.postId);
            if (!post) {
                throw new Error('Post not found');
            }
            const comment = new Comment(
                {
                    ...data,
                    postId: post._id,
                }
            );
            await comment.save();
            post.star_average = await module.exports.getStarAverage(data.postId);
            await Post.findByIdAndUpdate(post._id, post);
            return comment;
        } catch (error) {
            throw new Error(error);
        }
    },

    getAllComments: async (postId) => {
        try {
            const comments = await Comment.find().where('postId').equals(postId);
            let stars = 0;
            comments.forEach(comment => {
                stars += comment.star;
            });
            const star_average = stars / comments.length;
            return { comments, star_average };
        } catch (error) {
            throw new Error(error);
        }
    },

    getStarAverage: async (postId) => {
        try {
            const comments = await Comment.find().where('postId').equals(postId);
            let stars = 0;
            comments.forEach(comment => {
                stars += comment.star;
            });
            return stars / comments.length;
        } catch (error) {
            throw new Error(error);
        }
    }
};