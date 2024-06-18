const mongoose = require('mongoose');

const dataSchema = new mongoose.Schema({
    name: {
        required: true,
        type: String
    },
    longitude: {
        required: true,
        type: Number
    },
    latitude: {
        required: true,
        type: Number
    },
    address: {
        required: true,
        type: String
    },
    images: {
        required: true,
        type: Array
    },
    star: {
        required: true,
        type: Number
    },
})

module.exports = mongoose.model('venue', dataSchema)