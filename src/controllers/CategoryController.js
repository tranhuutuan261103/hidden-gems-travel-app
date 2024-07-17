const CategoryService = require("../services/CategoryService.js");
module.exports = {
    createCategory: async (req, res) => {
        try {
            const { name, icon } = req.body;
            const category = await CategoryService.create({ name, icon });
            res.json(category);
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