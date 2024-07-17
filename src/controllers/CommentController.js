const CommentService = require("../services/CommentService.js");

module.exports = {
    createComment: async (req, res) => {
        try {
            const userId = req.user._id;
            const { content, star, postId } = req.body;
            const comment = await CommentService.create({ content, star, postId, createdBy: userId });
            res.json(comment);
        } catch (error) {
            console.log(error);
            res.json({ message: error.message });
        }
    },

    getAllComments: async (req, res) => {
        try {
            const { postId } = req.params;
            const comments = await CommentService.getAllComments(postId);
            res.json(comments);
        } catch (error) {
            res.json({ message: error.message });
        }
    }
};