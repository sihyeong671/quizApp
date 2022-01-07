import express from 'express'
import cors from 'cors'
import dotenv from 'dotenv'
import Server from 'socket.io'
import http from 'http'
import userRouter from './router/users.js' // .js붙여줘야함 (폴더안에 index.js 있으면 js쓸 필요없음)
import bodyParser from 'body-parser'

dotenv.config()
const {PORT} = process.env

const app = express()

app.use(cors())
app.use(express.json()) //body-parser와 동일

app.use(bodyParser.urlencoded({
  extended: true
}));

app.use("/user",userRouter)



const httpServer = http.createServer(app)
const io = new Server(httpServer,{cors: {origin: '*'}})

// DB


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