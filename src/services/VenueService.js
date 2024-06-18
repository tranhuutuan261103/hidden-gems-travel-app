const Venue = require("../models/Venue.js");

module.exports = {
    create: async (data) => {
        try {
            const venue = new Venue(data);
            await venue.save();
            return venue;
        } catch (error) {
            throw new Error(error);
        }
    },

    getAll: async (limit = 10, page = 1) => {
        try {
            const venues = await Venue.find().limit(limit).skip((page - 1) * limit);
            return venues;
        } catch (error) {
            throw new Error(error);
        }
    },

    getOne: async (id) => {
        try {
            const venue = await Venue.findById(id);
            return venue;
        } catch (error) {
            throw new Error(error);
        }
    },

    update: async (id, data) => {
        try {
            const venue = await Venue.findByIdAndUpdate(id, data, {
                new: true
            });
            return venue;
        } catch (error) {
            throw new Error(error);
        }
    },

    delete: async (id) => {
        try {
            await Venue.findByIdAndDelete(id);
        } catch (error) {
            throw new Error(error);
        }
    }
};