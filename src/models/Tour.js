const mongoose = require('mongoose');

const dataSchema = new mongoose.Schema({
    name: {
        required: true,
        type: String
    },
    price: {
        required: true,
        type: Number
    },
    ratingsAverage: {
        required: true,
        type: Number
    },
    ratings: {
        required: true,
        type: Array
    },
    duration: {
        required: true,
        type: Number
    },
    description: {
        required: true,
        type: String
    },
    startAddress: {
        required: true,
        type: String
    },
    createdBy: {
        required: true,
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user'
    },
})

module.exports = mongoose.model('tour', dataSchema)