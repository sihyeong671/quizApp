import express from 'express'
import cors from 'cors'
import dotenv from 'dotenv'
import Server from 'socket.io'
import http from 'http'
import userRouter from './router/api/users.js' // .js붙여줘야함 (폴더안에 index.js 있으면 js쓸 필요없음)
import { findSourceMap } from 'module'

dotenv.config()
const {PORT} = process.env

const app = express()

app.use(cors())
app.use(express.json()) //body-parser와 동일

app.use("/users",userRouter)




const httpServer = http.createServer(app)
const io = new Server(httpServer,{cors: {origin: '*'}})

// const game = io.of('/chat');
// game.on()

let rooms = new Map();
rooms.set('asdf', {
  totalNum: 6,
  currentNum: 0,
  gameType: '노래',
  isLock: false,
  person:[
    '1'
  ]
})


io.on('connection', (socket) => {
  console.log('socket connect...')

  // socket.emit("send-room-info", roomObj);

  socket.on("make-room", (roomInfo) => {
    try{
      let roomName = roomInfo.roomName;
      let gameType = roomInfo.gameType;
      let isLock = roomInfo.isLock;

      let check = false; // 존재하는 방 이름인지 체크

      rooms.forEach((v, k) => {
        if(k === roomName) check = true;
      })

      const roomData = {
        totalNum: 6,
        currentNum: 1,
        gameType: gameType,
        gameTitle: roomName,
        isLock: isLock,
        person:[
          socket.id
        ]
      }

      if(!check){
        socket.join(roomName);
        rooms.set(roomName,roomData);
        socket.emit("update", roomData);
      }
      
      else{
        console.log("이미 방이 존재 합니다 혹은 알 수 없는 오류")
        socket.emit("room-already-exist", "같은이름의 방이 존재합니다");
      }
    }catch(e){
      console.log(e)
    }
    
  })

  socket.on('join-room', (roomName) => {
    socket.join(roomName);
    if(rooms.get(roomName)[currentNum] < 6){
      rooms.get(roomName)[currentNum]++;
      rooms.get(roomName)[person].push(socket.id);
      socket.emit('update', Object.fromEntries(rooms));
    }
    socket.emit('fail-join', '인원이 다 찼습니다');
  })

  socket.on("quick-entry", () => {
    console.log("빠른 입장");
    // socket.emit("update", Object.fromEntries(rooms));
  })

  socket.on("leave-room", (roomName) => {
    socket.leave(roomName);
    rooms.get(roomName)[currentNum]--;
    const idx = rooms.get(roomName)[person].indexOf(socket.id);
    rooms.get(roomName)[person].splice(idx, 1);
    socket.emit('update');
  })

  socket.on("ready", () => {

  })

  socket.on('game-start', () => {

  })

  socket.on('send-message', (msg, roomName) => {
    console.log(msg);
    socket.to(roomName).emit("receive-message", msg); // 룸 내의 모든 참가자에게 메시지 전송
  })


  socket.on('remove-room', (roomName)=>{
    delete rooms[roomName];
    socket.emit("update-room", '');
  })


  socket.on('disconnect', () => {
    console.log("disconnected...")

  })

})


httpServer.listen(PORT, (err) => {
  console.log(`Listening on port ${PORT}`)
})