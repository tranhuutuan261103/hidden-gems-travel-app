const CategoryService = require("../services/CategoryService.js");
const StorageService = require("../services/StorageService.js");

module.exports = {
    createCategory: async (req, res) => {
        try {
            if (!req.file) {
                return res.status(400).send("Error: No files found")
            }

            const { name } = req.body;

            const uploadResult = await StorageService.upload(req.file, "Categories", name);
            const venue = await CategoryService.create({ name, thumbnail: uploadResult });
            res.json(venue);
        } catch (error) {
            console.log(error);
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