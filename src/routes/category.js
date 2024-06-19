const express = require('express');
const multer = require('multer')
const Category = require('../controllers/CategoryController.js');
const upload = multer({ dest: 'uploads/' })

const router = express.Router()

router.post('/categories/create', upload.single('image'), Category.createCategory);
router.get('/categories', Category.getCategories);

module.exports = router;