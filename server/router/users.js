import express from 'express'
import mongoose from 'mongoose'
import Users from '../model/users.js'


const userRouter = express.Router()

userRouter.get('/all', async (req, res) =>  {
    console.log("유저정보요청")
    let userData = await Users.find({})
    res.json(userData);
})




export default userRouter;
