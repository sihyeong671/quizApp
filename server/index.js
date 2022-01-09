import express from 'express'
import cors from 'cors'
import dotenv from 'dotenv'
import Server from 'socket.io'
import http from 'http'
import { findSourceMap } from 'module'
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

// const game = io.of('/chat');
// game.on()

let rooms = new Map();
rooms.set('asdf', {
  totalNum: 6,
  currentNum: 3,
  gameType: '노래',
  gameTitle: '게임하자',
  isLock: false,
  isGameStart: false
})

let detailRooms = new Map();
detailRooms.set('asdf', {
  gameTitle: '게임하자',
  gameType: '노래',
  gameStart: false,
  gameRound: 1,
  person: ['1', '2'],
  chat:[
    ['1', '안녕'],
    ['2', 'Hi']
  ]
})


io.on('connection', (socket) => {
  console.log('socket connect...')

  // 처음 연결할때
  socket.emit("update-room", Object.fromEntries(rooms));


  // 방만들기
  socket.on("make-room", (roomInfo) => {
    try{

      // rooms
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
        isGameStart: false
      }
      // detailRooms
      const detailRoomData = {
        gameTitle: roomName,
        gameType: gameType,
        gameStart: false,
        gameRound: 1,
        person: [
          [socket.id]
        ],
        chat: [
          []
        ]
      }


      if(!check){
        socket.join(roomName);
        rooms.set(roomName, roomData);
        detailRooms.set(roomName, detailRoomData);
        // 페이지 전환
      }
      else{
        console.log("이미 방이 존재 합니다 혹은 알 수 없는 오류");
        socket.emit("room-already-exist", "같은 이름의 방이 존재합니다");
      }
    }catch(e){
      console.log(e)
    }


    
  })

  // 참가하기
  socket.on('join-room', (roomName) => {
    socket.join(roomName);
    if(rooms.get(roomName)[currentNum] < 6){
      rooms.get(roomName)[currentNum]++;
      rooms.get(roomName)[person].push(socket.id);
    }
    else{
      socket.emit('fail-join', '인원이 다 찼습니다');
    }
  })

  // 빠른입장
  socket.on("quick-entry", () => {
    console.log("빠른 입장");
    // socket.emit("update", Object.fromEntries(rooms));
  })

  // 방 업데이트
  socket.on('refresh-room', () => {
    console.log('방 정보 전달');
    socket.emit('update-room', Object.fromEntries(rooms));
  })

  // 방 나가기
  socket.on("leave-room", (roomName) => {
    socket.leave(roomName);
    rooms.get(roomName)[currentNum]--;
    const idx = rooms.get(roomName)[person].indexOf(socket.id);
    rooms.get(roomName)[person].splice(idx, 1);
  })

  // 게임 준비
  socket.on("ready", () => {

  })

  // 게임 시작
  socket.on('game-start', () => {

  })

  // 메시지 보내기

  socket.on('first-get-detail-room', (name)=>{
    console.log(name);
    console.log(detailRooms.get(name));
    socket.emit('get-detail-room',detailRooms.get(name));
  });

  socket.on('send-message', (data) => {
    console.log(data);
    console.log(data.message);
    console.log(data.gameTitle);
    socket.to(data.gameTitle).emit("receive-message", data.message); // 룸 내의 모든 참가자에게 메시지 전송
  })

  socket.on('disconnect', () => {
    console.log("disconnected...")

  })

})


httpServer.listen(PORT, (err) => {
  console.log(`Listening on port ${PORT}`)
})