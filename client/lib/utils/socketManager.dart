import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as IO;


late final IO.Socket _socket;


connectSocket() async{
  _socket = IO.io('http://10.0.2.2:8080',
    IO.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .build());
  _socket.connect(); // 연결


}

makeRoom(String roomName, String? gameType, bool isLock){

  Map dictionary = {
    'roomName': roomName,
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