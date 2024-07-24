const mongoose = require('mongoose');
const { Schema } = mongoose;

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
    points: {
        required: true,
        type: Number,
        default: 5000
    },
    role: {
        required: true,
        type: String
    },
    postsFound: {
        type: Array({
            type: Schema.Types.ObjectId,
            ref: 'post'
        })
    },
    postsUnlocked: {
        type: Array({
            type: Schema.Types.ObjectId,
            ref: 'post'
        })
    },
    postsArrived: {
        type: Array({
            type: Schema.Types.ObjectId,
            ref: 'post'
        })
    }
})

module.exports = mongoose.model('user', dataSchema)