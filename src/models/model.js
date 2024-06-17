const mongoose = require('mongoose');

const dataSchema = new mongoose.Schema({
    address: {
        required: true,
        type: String
    },
    name: {
        required: true,
        type: String
    }
})

module.exports = mongoose.model('venue', dataSchema)