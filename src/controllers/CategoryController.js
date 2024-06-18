const { get } = require("mongoose");
const CategoryService = require("../services/CategoryService.js");

module.exports = {
    createCategory: async (req, res) => {
        try {
            const { name, thumbnail } = req.body;
            const venue = await CategoryService.create({ name, thumbnail });
            res.json(venue);
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    getCategories: async (req, res) => {
        try {
            const categories = await CategoryService.get();
            res.json(categories);
        } catch (error) {
            res.json({ message: error.message });
        }
    }
};