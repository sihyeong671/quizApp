import express from 'express'
import cors from 'cors'
import dotenv from 'dotenv'
import Server from 'socket.io'
import http from 'http'
import userRouter from './router/api/users.js' // .js붙여줘야함 (폴더안에 index.js 있으면 js쓸 필요없음)

dotenv.config()
const {PORT} = process.env

const app = express()

app.use(cors())
app.use(express.json()) //body-parser와 동일

app.use("/users",userRouter)




const httpServer = http.createServer(app)
const io = new Server(httpServer,{cors: {origin: '*'}})

io.on('connection', (socket) => {
  console.log('socket connect...')

  socket.on("make-room", (roomName) => {

  })

  socket.on("quick-entry", () => {

  })

  socket.on("join-room", () => {

  })

  socket.on("ready", () => {

  })

  socket.on('game-start', () => {

  })

  socket.on('send-message', () => {

  })

  socket.on("push-button", (param) => {
    console.log(param);
  })

})


httpServer.listen(PORT, (err) => {
  console.log(`Listening on port ${PORT}`)
})