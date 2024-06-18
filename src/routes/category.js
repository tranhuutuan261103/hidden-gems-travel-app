const express = require('express');
const Category = require('../controllers/CategoryController.js');

const router = express.Router()

router.post('/categories/create', Category.createCategory);
router.get('/categories', Category.getCategories);

module.exports = router;