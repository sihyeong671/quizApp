import 'dart:io';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


late final IO.Socket _socket;

// 소켓 설정
initSocket() async{
  _socket = IO.io('http://192.249.18.158:80',
    IO.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .build());
  // _socket = IO.io('http://localhost:8080',
  //   IO.OptionBuilder()
  //     .setTransports(['websocket'])
  //     .disableAutoConnect()
  //     .build());
}

// 소켓 연결
connectSocket(){
  _socket.connect();
}


// 방 만들기
makeRoom(String roomName, String? gameType, bool isLock, String name, String img){

  Map dictionary = {
    'roomName': roomName, //gameTitle이랑 동일
    'gameType': gameType,
    'isLock': isLock,
    'name': name,
    'img': img
  };

  _socket.emit('make-room',  dictionary); // 방 정보 전달
}

// 빠른입장
quickEntry(name){
  _socket.emit('quick-entry', name);
}


// 참가하기
joinRoom(data){
  _socket.emit('join-room', data);
}


// on(send)
roomExistenceCheck(Function floatToastMessage){

  _socket.on("room-already-exist", (data){
    print("이미 방이 존재합니다");
    //토스트 메시지 띄우기
    floatToastMessage(data);
  });

}

// 빠른 입장 실패
failToJoin(Function showFailToast){
  _socket.on('fail-to-join', (data){
    print('${_socket.id}의 빠른 입장 실패');
    showFailToast(data);
  });
}

// 로비 입장시 전체 방 정보 받기 + 정보 갱신
setRoomData(Function updateRoomData){
  _socket.on("update-room", (data){
    print("update-room");
    updateRoomData(data);
  });
}

// 룸 정보 갱신(pull_to_refresh)
getRoomData(){
  _socket.emit('refresh-room');
}


// inGame.dart
requestDetailRoomData(String? title){
  print("클라이언트 데이터 요청");
  _socket.emit('first-get-detail-room', title);
}

// 준비하기


// 나가기
leaveRoom(roomName){
  _socket.emit('leave-room', roomName);
}

setDetailRoomData(Function setRoomData){
  _socket.on('get-detail-room', (data){
    print("get-detail-room ");
    setRoomData(data);
  });
}

getDetailRoomData(){
  _socket.emit('update-detail-room');
}

sendMessage(String message, String gameTitle){
  _socket.emit('send-message',{
    "message": message,
    "gameTitle": gameTitle
  });
}

// 메시지 브로드 캐스트
broadCastMessage(Function showMessage){
  _socket.on('receive-message', (data){
    print(data);
    showMessage(data);
  });
}

// 게임 로직

// 게임 시작
gameStart(Function gameStart){
  _socket.on('game-start',(data){
    print("게임시작");
    gameStart();
  });
}

// 타이머 동작
runTimer(Function runTimer){
  _socket.on('run-timer',(data){
    runTimer();
  });
}

// 라운드 시작
roundStart(roomName){
  print("라운드 시작");
  _socket.emit('round-start',roomName);
}

quizContent(Function showQuizData){
  _socket.on('quiz-content', (data){
    print(data['quiz']);
    print(data['answer']);
    showQuizData(data["quiz"], data["answer"]);
  });
}

// 라운드 종료
roundOver(Function roundOver){
  _socket.on('round-over',(data){
    roundOver();
  });
}

// 정답
correctAnswer(Function giveScore){
  _socket.on('correct-answer', (data){
    giveScore(int.parse(data));
  });
}

// 게임 종료
gameOver(String roomNumber){
  _socket.emit('game-over', roomNumber);
}