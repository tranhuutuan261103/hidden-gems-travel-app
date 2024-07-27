const express = require('express');
const Comment = require('../controllers/CommentController.js');
const authMiddleware = require("../middlewares/auth.middleware.js");

const router = express.Router()

router.post('/comments/create', authMiddleware.Validate, Comment.createComment);
router.get('/comments/:postId', Comment.getAllComments);

module.exports = router;