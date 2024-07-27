const Category = require("../models/Category.js");

module.exports = {
    create: async (data) => {
        try {
            const category = new Category(data);
            await category.save();
            return category;
        } catch (error) {
            throw new Error(error);
        }
    },

    get: async () => {
        try {
            const categories = await Category.find();
            return categories;
        } catch (error) {
            throw new Error(error);
        }
    }
};