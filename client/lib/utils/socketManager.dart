import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as IO;


late final IO.Socket _socket;


initSocket() async{
  _socket = IO.io('http://10.0.2.2:8080',
    IO.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .build());
}

connectSocket(){
  _socket.connect();
}

makeRoom(String roomName, String? gameType, bool isLock){

  Map dictionary = {
    'roomName': roomName, //gameTitle이랑 동일
    'gameType': gameType,
    'isLock': isLock
  };

  _socket.emit('make-room',  dictionary);
}

quickEntry(){
  _socket.emit('quick-entry', 'random');
}

roomExistenceCheck(Function floatToastMessage){

  _socket.on("room-already-exist", (data){
    print("이미 방이 존재합니다");
    //토스트 메시지 띄우기
    floatToastMessage(data);
  });

}

updateRoomInfo(Function updateInfo){
  _socket.on("update", (data){
    updateInfo(data);
  });
}

setRoomData(Function initRoomData){
  _socket.on("first-send-room", (data){
    print("first-send-room");
    initRoomData(data);
  });
}

removeRoom(Function updateRoomData){
  _socket.on('remove-room', (data){
    print(data);
    updateRoomData(data);
  });
}

