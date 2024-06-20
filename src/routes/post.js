const express = require('express');
const Post = require('../controllers/PostController.js');

const router = express.Router()

router.get('/posts', Post.getAllPost);
router.post('/posts/create', Post.createPost);
router.get('/posts/:id', Post.getPost);
router.put('/posts/:id/update', Post.updatePost);
router.delete('/posts/:id/delete', Post.deletePost);

module.exports = router;