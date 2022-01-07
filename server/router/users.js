import express from 'express'
import mongoose from 'mongoose'
import Users from '../model/users.js'
import db from '../db.js'


const userRouter = express.Router()

userRouter.get('/all', async (req, res) =>  {
    console.log("유저정보요청")
    let userData = await Users.find({nickName: "기영이"})
    res.json(userData);
})

userRouter.post('/save' , (req, res) => {
    console.log("유저정보저장")
    const {nickName, img} = req.body;
    db.add(nickName, img, (newUser) => {
        res.json(newUser)
    })
});



export default userRouter;
