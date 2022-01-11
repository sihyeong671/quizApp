import 'dart:io';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


late final IO.Socket _socket;

// 소켓 설정
initSocket(){

    _socket= IO.io('http://192.249.18.158:80',
    IO.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .build());
  }
  
  // _socket = IO.io('http://localhost:8080',
  //   IO.OptionBuilder()
  //     .setTransports(['websocket'])
  //     .disableAutoConnect()
  //     .build());

// 소켓 연결
connectSocket(){
  _socket.connect();
}

// 방 만들기
makeRoom(String roomName, bool isLock, String name, String img){
  print("방만들기");
  Map dictionary = {
    "roomName": roomName,
    "isLock": isLock,
    "name": name,
    'img': img
  };

  _socket.emit('make-room',  dictionary); // 방 정보 전달
}


// 빠른입장
quickEntry(name){
  _socket.emit('quick-entry', name);
}


// 참가하기
joinRoom(roomInfo){
  _socket.emit('join-room', roomInfo);
}

// 방만들기 실패
roomExistenceCheck(Function floatToastMessage){
  _socket.on("room-already-exist", (data){
    //토스트 메시지 띄우기
    floatToastMessage("이미 방이 존재합니다");
  });

}

// 빠른 입장 실패
failToJoin(Function showFailToast){
  _socket.on('fail-to-join', (data){
    showFailToast(data);
  });
}

// 로비 입장시 전체 방 정보 받기 + 정보 갱신
setRoomData(Function updateRoomData){
  _socket.on("update-room", (data){
    updateRoomData(data);
  });
}

// 룸 정보 갱신(pull_to_refresh)
pullToReFresh(){
  _socket.emit('refresh-room');
}


// inGame.dart
requestRoomData(String title){
  _socket.emit('request-inGame-data', title);
}

getInGameData(Function updateInGameData){
  _socket.on('update-inGame-room',(data){
    print("getInGameData");
    print(data);
    updateInGameData(data);
  });
}

// 준비하기

inGameReadyToggle(roomName){
  _socket.emit('inGame-ready', 
    {
      "id": _socket.id,
      "roomName": roomName 
    }
  );
}





// 나가기
leaveRoom(roomName){
  _socket.emit('leave-room', roomName);
}



sendMessage(String message, String roomName){
  _socket.emit('send-message',{
    "message": message,
    "roomName": roomName
  });
}

// 메시지 브로드 캐스트f
broadCastMessage(Function showMessage){
  _socket.on('receive-message', (data){
    showMessage(data["msg"], data["img"]);
  });
}

// 게임 시작
gameStart(Function gameStart){
  _socket.on('game-start',(data){
    print("게임시작");
    gameStart(data);
  });
}

// 타이머 동작
// runTimer(Function runTimer){
//   _socket.on('run-timer',(data){
//     runTimer();
//   });
// }

// // 라운드 시작
// roundStart(roomName){
//   print("라운드 시작");
//   _socket.emit('round-start',roomName);
// }

quizContent(Function showQuizData){
  _socket.on('quiz-content', (data){
    showQuizData(data["quiz"], data["answer"]);
  });
}

// 라운드 종료
// roundOver(Function roundOver){
//   _socket.on('round-over',(data){
//     roundOver();
//   });
// }

disconnectSocket() {
  _socket.disconnect();
}

// 게임 종료
gameOver(Function gameOver){
  _socket.on('game-over', (data){
    print("게임종료");
    gameOver();
  });
}

socketDisconnect(){
  _socket.disconnect();
}