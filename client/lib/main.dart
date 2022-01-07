import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:client/auth/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LogIn()
      );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({ Key? key }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  TextEditingController msgInputController = TextEditingController();
  late IO.Socket socket;
  
  @override
  void initState() {
    // TODO: implement initState
    print("working");
    socket = IO.io('http://localhost:8080',
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()  
        .build());

    socket.connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: Container(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index){
                    return MessageItem(sentByMe: true);
                  }),
              )),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.red,
                child: TextField(
                  style: TextStyle(
                    color: Colors.white
                  ),
                  cursorColor: Colors.purple,
                  controller: msgInputController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    suffixIcon: Container(
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: IconButton(
                        onPressed: (){
                          sendMessage(msgInputController.text);
                          msgInputController.text = "";
                        }
                        ,icon: Icon(Icons.send, color: Colors.white)),
                    )
                  )
                )
              )
            )
          ],
        ),
      ),
    );
  }
}

void sendMessage(String text){

}


class MessageItem extends StatelessWidget {
  const MessageItem({ Key? key, required this.sentByMe }) : super(key: key);

  final bool sentByMe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: sentByMe? Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        
        color: sentByMe? Colors.purple:Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              "Hello",
              style: TextStyle(
                color: sentByMe ? Colors.white:Colors.purple,
                fontSize: 18
              ),
            ),
            SizedBox(width: 5),
            Text(
              "1:10 AM",
              style: TextStyle(
                color: (sentByMe ? Colors.white:Colors.purple).withOpacity(0.7),
                fontSize: 10),
            )
            
          ],
          ),
      ),
    );
  }
}