import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatInputField extends StatefulWidget {
  const ChatInputField({ Key? key }) : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {

  TextEditingController _msgController = TextEditingController();
  late final IO.Socket socket;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    socket = IO.io('http://10.0.2.2:8080',
    IO.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .build());
    socket.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0 / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            SizedBox(width: 20.0),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0 * 0.75,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 20.0 / 4),
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        decoration: InputDecoration(
                          hintText: "정답",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0 / 4),
                    IconButton(
                      onPressed: (){
                        socket.emit("send-message", _msgController.text);
                      },
                      icon: Icon(Icons.send_rounded),
                      color: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .color!
                        .withOpacity(0.64),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
