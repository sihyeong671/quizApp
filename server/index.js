import express from 'express'
import cors from 'cors'
import mongoose from 'mongoose'
import dotenv from 'dotenv'
import User from './model/user.js'
// const User = require('./model/user');

dotenv.config()

const {PORT} = process.env

const app = express()
app.use(cors())
app.use(express.json()) //body-parser와 동일

// DB
mongoose.connect('mongodb://localhost:27017/test')
  .then(()=>console.log("Connected to MongoDB"))
  .catch((err)=> console.log(err))

// 회원가입
app.post("/user", async (req, res) => {
  console.log(req.body)
  const user = new User(req.body);
  console.log('연결성공')
  try{
    await user.save();
    res.status(204).send()
  }catch(e){
    res.status(500).json({
      message: "User 저장 실패"
    })
  }
})

// 회원 탈퇴



// 유저 랭킹 보여주기
app.get("/user", async(req, res) => {
  try{
    const users = await User.find({});

    res.status(200).send(users);
  }catch(e){
    res.status(500).json({
      message: "User 조회 실패"
    })
  }
})

// 유저 닉네임 수정
app.patch("/user",  async(req, res) => {
  try{

  }catch(e){

  }
})


app.listen(PORT, (err) => console.log(err))