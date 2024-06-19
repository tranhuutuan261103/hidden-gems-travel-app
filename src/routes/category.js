const express = require('express');
const multer = require('multer')
const Category = require('../controllers/CategoryController.js');
const authMiddleware = require("../middlewares/auth.middleware.js");

const router = express.Router()
const upload = multer({ dest: 'uploads/' })

router.post('/categories/create', upload.single('image'), authMiddleware.Validate, Category.createCategory);
router.get('/categories', Category.getCategories);

module.exports = router;