const express = require('express');
const User = require('../controllers/UserController.js');

const router = express.Router()

// router.get('/users', User.getAllUser);
router.post('/users/register', User.registerUser);
router.post('/users/login', User.loginUser);

module.exports = router;