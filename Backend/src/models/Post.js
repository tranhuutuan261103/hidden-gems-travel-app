const mongoose = require('mongoose');
const { Schema } = mongoose;

const dataSchema = new mongoose.Schema({
    title: {
        required: true,
        type: String
    },
    content: {
        required: true,
        type: String
    },
    contentVectorize: {
        required: true,
        type: Array
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
    imageVectorize: {
        required: true,
        type: Array
    },
    category: {
        required: true,
        type: Schema.Types.ObjectId, 
        ref: 'category' ,
    },
    createdBy: {
        required: true,
        type: Schema.Types.ObjectId, 
        ref: 'user' ,
    },
    star_average: {
        required: true,
        type: Number,
        default: 0,
        min: 0,
        max: 5
    },
})

module.exports = mongoose.model('post', dataSchema)