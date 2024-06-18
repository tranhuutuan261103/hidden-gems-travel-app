const VenueService = require("../services/VenueService.js");

module.exports = {
    createVenue: async (req, res) => {
        try {
            const { name, longitude, latitude, address, images, star } = req.body;
            const venue = await VenueService.create({ name, longitude, latitude, address, images, star });
            res.json(venue);
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    getAllVenue: async (req, res) => {
        try {
            const { limit, page } = req.query;
            const venues = await VenueService.getAll(limit, page);
            res.json(venues);
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    getVenue: async (req, res) => {
        try {
            const { id } = req.params;
            const venue = await VenueService.getOne(id);
            res.json(venue);
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    updateVenue: async (req, res) => {
        try {
            const { id } = req.params;
            const { name, longitude, latitude, address, images, star } = req.body;
            const venue = await VenueService.update(id, { name, longitude, latitude, address, images, star });
            res.json(venue);
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    deleteVenue: async (req, res) => {
        try {
            const { id } = req.params;
            await VenueService.delete(id);
            res.json({ message: "Venue deleted" });
        } catch (error) {
            res.json({ message: error.message });
        }
    }
};