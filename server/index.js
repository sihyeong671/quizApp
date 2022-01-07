import express from 'express'
import cors from 'cors'
import mongoose from 'mongoose'
import dotenv from 'dotenv'
import User from './model/user.js'
import Server from 'socket.io'
import http from 'http'

dotenv.config()
const {PORT} = process.env

const app = express()
app.use(cors())
app.use(express.json()) //body-parser와 동일

const httpServer = http.createServer(app)

const io = new Server(httpServer,{cors: {origin: '*'}})

// DB
mongoose.connect('mongodb://localhost:27017/test')
  .then(()=>console.log("Connected to MongoDB"))
  .catch((err)=> console.log(err))

io.on('connection', (socket) => {
  console.log('socket connect', socket.id)

  // socket.on('typing', (data) => {
  //   console.log(data);
  //   io.emit('typing', data)
  // })

  // socket.on('message', (data) => {
  //   console.log(data);
  //   io.emit('message', data)
  // })

  // socket.on('location', (data) => {
  //   console.log(data);
  //   io.emit('location', data)
  // })

  // socket.on('connect', () => {})

  // socket.on('disconnect', () => {
  //   console.log('socket disconnect...', socket.id);
  // })

  // socket.on('error', (err)=>{
  //   console.log('received error from socket: ', socket.id)
  //   console.log(err)
  // })
})


httpServer.listen(PORT, (err) => {
  console.log(`Listening on port ${PORT}`)
})