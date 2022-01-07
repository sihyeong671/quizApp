import express from 'express'
import mongoose from 'mongoose'
import Users from '../../model/users.js'
import multer from 'multer'

const userRouter = express.Router()
//define storage for the images



//upload parameter

//http header에 multipart/form-data 필수
// const upload = multer({
//   dest: '../../upload/'
// });


userRouter.get('/all', async (req, res) =>  {
  console.log("유저정보요청")
  let userData = await Users.find({})
  res.json(userData);
})

// userRouter.post('/upload', upload.single('file'), (req, res, next) => {
//   const { fieldname, originalname, encoding, mimetype, detination, filename, path, size } = req.file
// })



export default userRouter;
