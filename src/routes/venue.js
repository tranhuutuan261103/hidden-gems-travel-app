const express = require('express');
const Venue = require('../controllers/VenueController.js');

const router = express.Router()

router.get('/venues', Venue.getAllVenue);
router.post('/venues/create', Venue.createVenue);
router.get('/venues/:id', Venue.getVenue);
router.put('/venues/:id/update', Venue.updateVenue);
router.delete('/venues/:id/delete', Venue.deleteVenue);

module.exports = router;