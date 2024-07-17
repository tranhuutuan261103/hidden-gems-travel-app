const mongoose = require('mongoose');
const { Schema } = mongoose;

const dataSchema = new mongoose.Schema({
    content: {
        required: true,
        type: String
    },
    createdBy: {
        required: true,
        type: Schema.Types.ObjectId, 
        ref: 'user' 
    },
    createdAt: {
        required: true,
        type: Date,
        default: Date.now
    },
    postId: {
        required: true,
        type: Schema.Types.ObjectId, 
        ref: 'post' 
    },
    star: {
        required: true,
        type: Number,
        default: 0,
        min: 0,
        max: 5
    }
})

module.exports = mongoose.model('comment', dataSchema)