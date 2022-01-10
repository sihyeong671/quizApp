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

io.on('connection', (socket) => {
  console.log('socket connect...')

  // 처음 연결할때
  socket.emit("update-room", Object.fromEntries(rooms));


  // 방만들기
  socket.on("make-room", (roomInfo) => {
    try{
      const roomName = roomInfo.roomName; // key
      const isLock = roomInfo.isLock;
      const name = roomInfo.name;
      const problem = "ㅇㅂㅈㅅ";
      const answer = "어벤져스";
      let check; // 방 존재여부

      if(rooms.has(roomName)) check = true; // 존재
      else check = false; // 없음

      const roomData = {
        totalNum: 6,
        currentNum: 1,
        isLock: isLock,
        isGameStart: false,
        problem: problem,
        answer: answer,
        users: [[socket.id, 0, name, false]]
      }

      if(!check){ // 존재 하지 않는 경우 생성
        socket.join(roomName); // join
        rooms.set(roomName, roomData); // Map에 추가
        console.log(`${socket.id}님이 ${roomName}을 만들었습니다`);
        socket.emit('update-room', Object.fromEntries(rooms));
        // 클라이언트에서 페이지 전환
      }
      else{
        console.log("이미 방이 존재 합니다");
        socket.emit("room-already-exist", "같은 이름의 방이 존재합니다");
      }
    }catch(e){
      console.log(e)
    }
  })

  // 참가하기
  socket.on('join-room', (roomInfo) => {

    const roomName = roomInfo.roomName;
    const myName = roomInfo.name;
    
    socket.join(roomName);

    if(rooms.get(roomName).currentNum < 6 && !rooms.get(roomName).isGameStart){
      rooms.get(roomName).currentNum++;
      console.log(`${socket.id}가 ${roomName}에 참가했습니다`);
      //id, name, score, isReady
      rooms.get(roomName).person.push([socket.id, myName, 0, false])
      io.in(roomName).emit("update-inGame-room", rooms.get(roomName));

      // if(rooms.get(roomName).currentNum == 2){
      //   rooms.get(roomName).isGameStart = true;
      //   io.in(roomName).emit('game-start');
      // }
    }
    else{
      socket.emit('fail-join', null);
    }
    
  })

  // 빠른입장
  socket.on("quick-entry", (name) => {
    let key;
    let num = 0;
    let check = false;
    rooms.forEach((v, k)=>{
      // 가장 인원이 많은곳, 6명 미만인 방, 게임 시작전인 방 
      if((v.currentNum > num) && (v.currentNum < 6) && (!v.isGameStart)){
        key = k;
        check = true;
      }
    })

    if(check){ // join할 방이 있다.
      socket.join(key); // join
      rooms.get(key).currentNum++;
      rooms.get(key).person.push([socket.id, name, 0, false]);
      console.log(`${socket.id}가 ${key}에 입장하였습니다`);
      io.to.emit('update-inGame-room', rooms.get(roomName));

      // if(rooms.get(key).currentNum == 2){
      //   rooms.get(key).isGameStart = true;
      //   socket.to(key).emit('game-start');
      // }
    }
    else{
      // fail to join
      socket.emit('fail-to-join', null);
    }
    
  
  })

  // 방 업데이트
  socket.on('refresh-room', () => {
    console.log(`${socket.id}가 pull to refresh를 사용`);
    socket.emit('update-room', Object.fromEntries(rooms));
  })

  // 방 나가기
  socket.on("leave-room", (roomName) => {
    console.log(`${socket.id}님이 ${roomName}을 나갔습니다`);
    socket.leave(roomName);
    rooms.get(roomName).currentNum -= 1; // 현재인원 지우기
    rooms.get(roomName).users = rooms.get(roomName).users.filter((user)=>{
      return user[0] !== socket.id;
    });
    
    if(rooms.get(roomName).users.length <= 0){
      rooms.delete(roomName);
      // 강제 종료시에도 작동되기 할 것
    }

    socket.to(roomName).emit('update-inGame-room', rooms.get(roomName));

  })

  // 게임 시작
  // socket.on('round-start', (roomName)=>{
  //   // db
  //   // 문제 보내기

  //   detailRooms.get(roomName).answer = "신과함께";
  //   socket.to(roomName).emit('quiz-content', ({
  //     quiz: 'ㅅㄱㅎㄲ',
  //     answer: '신과함께'
  //   }));

  //   setTimeout(()=>{
  //     console.log("round-over");
  //     socket.emit('round-over');
  //     clearInterval(Timercheck);
  //   }, 10001);

  //   setInterval(()=>{
  //     Timercheck
  //   }, 1000)
    
  // })

  socket.on('inGame-ready',(data)=>{

    const roomName = data.roomName;
    const id = data.id;
    let flag = true; // 모두 준비면 true

    let len = rooms.get(roomName).users.length
    for(let i = 0; i < len; ++i){
      if(!rooms.get(roomName).users[i][3]) flag = false;
      if(rooms.get(roomName).users[i][0] == id) {
        rooms.get(roomName).users[i][3] = !rooms.get(roomName).users[i][3];
      }
      
    }
    

    if(!flag){
      rooms.get(roomName).isGameStart = true;
      io.in(roomName).emit('game-start')
    }

    io.in(roomName).emit("update-inGame-room", rooms.get(roomName));
  });

  socket.on('game-over', (roomName)=>{

  })

  // 메시지 보내기
  socket.on('send-message', (data) => {
    

    const myRoom = rooms.get(data.roomName)
    const msg = data.message;

    if(myRoom.isGameStart){ // 게임중
      if(msg === myRoom.answer){
        rooms.get(myRoom).isGameStart = false;
        io.in(myRoom).emit('game-over');
        
        // socket.emit('correct-answer'); // 정답
        
        // if(myRoom.gameRound > 5){

        //   socket.to(data.gameTitle).emit('game-over'); // 만들어줘야함
        //   socket.to(data.gameTitle).emit('update-room');
        // }else{
        //   socket.to(data.gameTitle).emit('round-over'); // 라운드 끝
        //   socket.to(data.gameTitle).emit('get-detail-room');
        // }
      }
    }
    socket.to(myRoom).emit("receive-message", data.message); // 룸 내의 모든 참가자에게 메시지 전송
  })

  socket.on('disconnect', () => {
    console.log("disconnected...")
  })

  // inGame내에서 요청
  socket.on('request-inGame-data', (roomName)=>{
    socket.emit("update-inGame-room", rooms.get(roomName));
  })

})



httpServer.listen(PORT, (err) => {
  console.log(`Listening on port ${PORT}`)
})