require('dotenv').config();

const express = require('express');
const mongoose = require('mongoose');
const routes = require('./routes/routes.js');
const mongoString = process.env.DATABASE_URL;

mongoose.connect(mongoString);
const database = mongoose.connection;

database.on('error', (error) => {
    console.log(error)
})

database.once('connected', () => {
    console.log('Database Connected');
})
const app = express();

// CORS error handling
app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*'); // '*' for all
    res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
    if (req.method == 'OPTIONS') {
        res.header('Access-Control-Allow-Methods', 'PUT, POST, PATCH, DELETE, GET'); // '*' for all
        return res.status(200).json({});
    }
    next();
});

app.use(express.json());

app.use('/api', routes)

app.listen(3000, () => {
    console.log(`Server Started at http://localhost:${3000}`)
})