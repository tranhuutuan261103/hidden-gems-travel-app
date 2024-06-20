const mongoose = require('mongoose');
const { Schema } = mongoose;

const dataSchema = new mongoose.Schema({
    description: {
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
    votes: {
        required: true,
        type: Array
    },
    category: {
        required: true,
        type: Schema.Types.ObjectId, 
        ref: 'category' ,
    }
})

module.exports = mongoose.model('post', dataSchema)