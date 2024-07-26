const express = require('express');
const multer = require('multer');
const Post = require('../controllers/PostController.js');
const AuthMiddleware = require('../middlewares/auth.middleware.js');

const router = express.Router()
const upload = multer({ dest: 'uploads/' })

router.get('/posts', AuthMiddleware.Validate, upload.single('image'), Post.getAllPost);
router.get('/posts/found', AuthMiddleware.Validate, Post.getAllPostFound);
router.post('/posts/:id/unlocked', AuthMiddleware.Validate, Post.unlockPost);
router.get('/posts/unlocked', AuthMiddleware.Validate, Post.getUnlockPost);
router.post('/posts/:id/arrived', AuthMiddleware.Validate, Post.markArrived);
router.post('/posts/create', AuthMiddleware.Validate, upload.array('images', 10), Post.createPost);
router.get('/posts/:id', AuthMiddleware.Validate, Post.getPost);
router.put('/posts/:id/update', Post.updatePost);
router.delete('/posts/:id/delete', Post.deletePost);

module.exports = router;