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
    },
    postsFound: {
        type: Array
    },
    postsUnlocked: {
        type: Array
    },
    postsArrived: {
        type: Array
    }
})

module.exports = mongoose.model('user', dataSchema)