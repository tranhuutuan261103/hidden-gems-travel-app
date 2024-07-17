const express = require('express');
const User = require('../controllers/UserController.js');
const authMiddleware = require("../middlewares/auth.middleware.js");

const router = express.Router()

// router.get('/users', User.getAllUser);
router.post('/users/register', User.registerUser);
router.post('/users/login', User.loginUser);
router.get('/users/info', authMiddleware.Validate, User.getUserInfo);
router.get('/users/infoDetail', authMiddleware.Validate, User.getUserInfoDetail);
router.post('/users/logout', authMiddleware.Validate, User.logoutUser);

module.exports = router;