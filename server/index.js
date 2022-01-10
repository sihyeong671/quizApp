import express from 'express'
import cors from 'cors'
import dotenv from 'dotenv'
import Server from 'socket.io'
import http from 'http'
import { findSourceMap } from 'module'
import userRouter from './router/users.js' // .js붙여줘야함 (폴더안에 index.js 있으면 js쓸 필요없음)
import bodyParser from 'body-parser'
import { read } from 'fs'

dotenv.config()
const {PORT, BASE_URL} = process.env

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

let detailRooms = new Map();


io.on('connection', (socket) => {
  console.log('socket connect...')

  // 처음 연결할때
  socket.emit("update-room", Object.fromEntries(rooms));


  // 방만들기
  socket.on("make-room", (roomInfo) => {
    try{

      // rooms
      const roomName = roomInfo.roomName;
      const gameType = roomInfo.gameType;
      const isLock = roomInfo.isLock;
      const name = roomInfo.name;
      const img = roomInfo.img;
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
      let timeLimit; 
      if(gameType === "노래")       timeLimit = 10; // 처음 맞춘사람만 점수
      else if(gameType === "영화")  timeLimit = 15; // 처음 맞춘사람만 점수
      else if(gameType === "인물")  timeLimit = 5; // 못 맞추면 감점

      const detailRoomData = {
        gameTitle: roomName,
        gameType: gameType,
        gameStart: false,
        gameRound: 0,
        readyNum: 0,
        gameTime: timeLimit,
        person: [
        //socket, nickname, isHost, isReady, score, img
          [socket.id, name, true, false, 0, img]
        ],
        // chat은 필요없음
      }


      if(!check){
        socket.join(roomName);
        rooms.set(roomName, roomData);
        detailRooms.set(roomName, detailRoomData);
        console.log(`${socket.id}님이 ${roomName}을 만들었습니다`);
        socket.broadcast.emit('update-room', Object.fromEntries(rooms));
        // 클라이언트에서 페이지 전환
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
    console.log(`${socket.id}가 ${roomName}에 참가했습니다`)
    socket.join(roomName);
    if(rooms.get(roomName).currentNum < 6){
      rooms.get(roomName).currentNum++;
      detailRooms.get(roomName).person.push([socket.id]);
      socket.to(roomName).emit("get-detail-room", detailRooms.get(roomName));
      socket.broadcast.emit('update-room', Object.fromEntries(rooms));
    }
    else{
      socket.emit('fail-join', '인원이 다 찼습니다');
    }
    
  })

  // 빠른입장
  socket.on("quick-entry", (name) => {
    console.log("빠른 입장");
    let key;
    let num = 0;
    let check = false;
    rooms.forEach((v, k)=>{
      if((v.currentNum > num) && (v.currentNum < 6) && (!v.isGameStart)){
        key = k;
        check = true;
      }
    })
    socket.join(key);

    if(check){
      rooms.get(key).currentNum++;
      detailRooms.get(key).person.push([socket.id, name, false, false, 0]);

      socket.to(key).emit('get-detail-room',detailRooms.get(key));
      socket.broadcast.emit('update-room', Object.fromEntries(rooms));
    }
    else{
      // fail to join
      socket.emit('fail-to-join', '다시 시도해 주세요');
    }
    
    
    // socket.emit("update", Object.fromEntries(rooms));
  })

  // 방 업데이트
  socket.on('refresh-room', () => {
    console.log('방이 업데이트 되었습니다');
    socket.emit('update-room', Object.fromEntries(rooms));
  })

  // 방 나가기
  socket.on("leave-room", (roomName) => {
    console.log(`${socket.id}님이 ${roomName}을 나갔습니다`)
    socket.leave(roomName);
    rooms.get(roomName).currentNum--;
    
    detailRooms.get(roomName).person = detailRooms.get(roomName).person.filter(e => {
      console.log(e[0], socket.id);
      if(e[0] === socket.id){
        return false;
      }
      return true;
    })

    console.log(detailRooms.get(roomName).person);
    console.log(detailRooms.get(roomName).person.length);


    if(detailRooms.get(roomName).person.length == 0){
      detailRooms.delete(roomName);
      rooms.delete(roomName);
      socket.broadcast.emit('update-room', Object.fromEntries(rooms));
    }else{
      socket.to(roomName).emit('get-detail-room',detailRooms.get(roomName));
    }

    


  })
  // 게임 준비
  socket.on("ready", (data) => {
    
    let isReady;
    console.log(detailRooms.get(data.gameTitle));


    detailRooms.get(data.gameTitle).person.forEach((v)=>{
      if(socket.id === v[0]){
         // Toggle
        if(!v[3]){ // 준비안함 -> 준비
          v.readyNum++;
          isReady = true;
          console.log(`${data.name}님이 준비하였습니다`)
        }
        else{ // 준비 -> 준비안함
          v.readyNum--;
          isReady = false;
          console.log(`${data.name}님이 준비해제하였습니다`)
        }
        v[3] = !v[3];
      }
    })

    if(isReady) detailRooms.get(data.gameTitle).readyNum += 1;
    else  detailRooms.get(data.gameTitle).readyNum -= 1;

    socket.to(data.gameTitle).emit('get-detail-room', detailRooms.get(data.gameTitle));
  })

  // 게임 시작
  socket.on('game-start', (roomName) => {
    const length = detailRooms.get(roomName).person.length
    if((length - 1 == detailRooms.get(roomName).readyNum) && (length > 1)){
      console.log('게임을 시작합니다');
      rooms.get(roomName).isGameStart = true;
      detailRooms.get(roomName).gameStart = true;
      detailRooms.get(roomName).gameRound++;
      // 로직 추가
      socket.emit('game-starting');
      // 브로드 캐스트 전체 room
      // 브로드 캐스트 방 detailroom
      
    }else{
      console.log("누군가 준비를 하지 않았거나 혼자입니다")
    }
  })

  // 메시지 보내기

  socket.on('first-get-detail-room', (name)=>{
    socket.emit('get-detail-room', detailRooms.get(name));
  });

  socket.on('send-message', (data) => {
    socket.to(data.gameTitle).emit("receive-message", data.message); // 룸 내의 모든 참가자에게 메시지 전송
  })

  socket.on('disconnect', () => {
    console.log("disconnected...")

  })

})


httpServer.listen(PORT, (err) => {
  console.log(`Listening on port ${PORT}`)
})