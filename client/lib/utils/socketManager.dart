import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


late final IO.Socket _socket;

// 소켓 설정
initSocket() async{
  _socket = IO.io('http://10.0.2.2:8080',
    IO.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .build());
}

// 소켓 연결
connectSocket(){
  _socket.connect();
}


// 방 만들기
makeRoom(String roomName, String? gameType, bool isLock){

  Map dictionary = {
    'roomName': roomName, //gameTitle이랑 동일
    'gameType': gameType,
    'isLock': isLock
  };

  _socket.emit('make-room',  dictionary); // 방 정보 전달
}

// 빠른 입장
quickEntry(){
  _socket.emit('quick-entry', 'random');
}

// on(send)
roomExistenceCheck(Function floatToastMessage){

  _socket.on("room-already-exist", (data){
    print("이미 방이 존재합니다");
    //토스트 메시지 띄우기
    floatToastMessage(data);
  });

}


// 로비 입장시 전체 방 정보 받기 + 정보 갱신
setRoomData(Function updateRoomData){
  _socket.on("update-room", (data){
    print("update-room");
    updateRoomData(data);
  });
}

getRoomData(){
  _socket.emit('refresh-room');
}


// inGame.dart
requestDetailRoomData(String? title){
  print("클라이언트 데이터 요청");
  _socket.emit('first-get-detail-room', title);
}

getDetailRoomData(Function setRoomData){
  _socket.on('get-detail-room', (data){
    setRoomData(data);
  });
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