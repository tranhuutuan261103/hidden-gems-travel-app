const express = require('express');
const Tour = require('../controllers/TourController.js');
const AuthMiddleware = require('../middlewares/auth.middleware.js');

const router = express.Router()

router.get('/tours', Tour.getAllTour);
router.post('/tours/create', AuthMiddleware.Validate, Tour.createTour);

module.exports = router;