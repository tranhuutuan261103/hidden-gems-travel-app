const Tour = require('../models/Tour.js');
const User = require('../models/User.js');

module.exports = {
    create: async (data, userId) => {
        try {
            const userRef = User.findById(userId);
            if (!userRef) {
                throw new Error('User not found');
            }
            const tour = new Tour(
                {
                    ...data,
                    createdBy: userId
                }
            );
            await tour.save();
            return tour;
        } catch (error) {
            throw new Error(error.message);
        }
    },

    getTours: async () => {
        try {
            let tours = await Tour.find().populate('createdBy');
            tours = tours.map(tour => {
                return {
                    id: tour._id,
                    name: tour.name,
                    price: tour.price,
                    ratingsAverage: tour.ratingsAverage,
                    ratings: tour.ratings,
                    duration: tour.duration,
                    description: tour.description,
                    startAddress: tour.startAddress,
                    createdBy: {
                        id: tour.createdBy._id,
                        name: tour.createdBy.name,
                        email: tour.createdBy.email,
                    }
                }
            });
            return tours;
        } catch (error) {
            throw new Error(error.message);
        }
    },
}