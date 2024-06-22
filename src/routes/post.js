const express = require('express');
const multer = require('multer');
const Post = require('../controllers/PostController.js');
const AuthMiddleware = require('../middlewares/auth.middleware.js');

const router = express.Router()
const upload = multer({ dest: 'uploads/' })

router.get('/posts', AuthMiddleware.Validate, Post.getAllPost);
router.get('/posts/found', AuthMiddleware.Validate, Post.getAllPostFound);
router.post('/posts/create', AuthMiddleware.Validate, upload.array('images', 10), Post.createPost);
router.get('/posts/:id', Post.getPost);
router.put('/posts/:id/update', Post.updatePost);
router.delete('/posts/:id/delete', Post.deletePost);

module.exports = router;