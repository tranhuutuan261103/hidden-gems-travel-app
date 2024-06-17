const express = require('express');
const Model = require('../models/model');

const router = express.Router()

//Post Method
router.post('/post', async (req, res) => {
    try {
        // console.log(req.body)
        // const data = new Model({
        //     name: req.body.name,
        //     address: req.body.address
        // })
        const data = new Model({
            name: "Ngũ Hành Sơn",
            address: "Đà Nẵng"
        })

        const dataToSave = await data.save();
        res.status(200).json(dataToSave)
    }
    catch (error) {
        console.log(error)
        res.status(400).json({message: error.message})
    }
})

//Get all Method
router.get('/getAll',async (req, res) => {
    try{
        const data = await Model.find();
        res.json(data)
    }
    catch(error){
        res.status(500).json({message: error.message})
    }
})

//Get by ID Method
router.get('/getOne/:id', async (req, res) => {
    try{
        const data = await Model.findById(req.params.id);
        res.json(data)
    }
    catch(error){
        res.status(500).json({message: error.message})
    }
})

//Update by ID Method
router.patch('/update/:id', async (req, res) => {
    try {
        const id = req.params.id;
        const updatedData = {
            name: req.body.name,
            address: req.body.address
        };
        const options = { new: true };

        const result = await Model.findByIdAndUpdate(
            id, updatedData, options
        )

        res.send(result)
    }
    catch (error) {
        res.status(400).json({ message: error.message })
    }
})

//Delete by ID Method
router.delete('/delete/:id', (req, res) => {
    res.send('Delete by ID API')
})

module.exports = router;