const TourService = require("../services/TourService.js");

module.exports = {
    createTour: async (req, res) => {
        try {
            const userId = req.user._id;
            const { name, price, ratingsAverage, ratings, duration, description, startAddress } = req.body;
            const tour = await TourService.create({ name, price, ratingsAverage, ratings, duration, description, startAddress }, userId);
            res.json(tour);
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    getAllTour: async (req, res) => {
        try {
            const tours = await TourService.getTours();
            res.json(tours);
        } catch (error) {
            res.json({ message: error.message });
        }
    },
};