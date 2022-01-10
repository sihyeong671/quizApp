import express from 'express'
import mongoose from 'mongoose'
import Users from '../model/users.js'
import db from '../db.js'


const userRouter = express.Router()

userRouter.get('/all', async (req, res) =>  {
    console.log("유저정보요청 all")
    let userData = await Users.find()
    res.json(userData);
})

userRouter.get('/:id', async (req, res) =>  {
    console.log("유저정보요청 id")
    let userData = await Users.find({userID: req.params.id})
    res.json(userData);
})

userRouter.post('/save' , (req, res) => {
    console.log("유저정보저장")
    const {userID, nickName, img, score} = req.body;
    db.add(userID, nickName, img, score, (newUser) => {
        res.json(newUser)
    })
});

userRouter.delete('/:id', async (req, res) => {
    console.log("유저정보삭제 id");
    let userData = await Users.deleteOne({userID: req.params.id});
    res.json(userData);
})



export default userRouter;
