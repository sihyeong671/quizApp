import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as IO;


connectSocket(socket){
  socket = IO.io('http://10.0.2.2:8080',
    IO.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .build());

  socket.connect(); // 연결

}