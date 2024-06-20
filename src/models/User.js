const mongoose = require('mongoose');

const dataSchema = new mongoose.Schema({
    name: {
        required: true,
        type: String
    },
    email: {
        required: true,
        type: String
    },
    password: {
        required: true,
        type: String
    },
    hashedPassword: {
        required: true,
        type: String
    },
    role: {
        required: true,
        type: String
    }
})

module.exports = mongoose.model('user', dataSchema)