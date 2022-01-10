import 'package:client/inGame/ChatMessage.dart';
import 'package:client/inGame/chat_input_field.dart';
import 'package:client/inGame/message.dart';
import 'package:client/models/Room.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/socketManager.dart';
import 'package:tuple/tuple.dart';
import 'package:client/utils/socketManager.dart';


class InGame extends StatefulWidget {
  final String? gameTitle;
  const InGame({ Key? key, @required this.gameTitle}) : super(key: key);

  @override
  _InGameState createState() => _InGameState();
}

class _InGameState extends State<InGame> {

  bool gameStart = false;
  int gameRound = 1;
  late String gameType;
  List<String> users = [];
  List<ChatMessage> chat = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initSocketListener();
  }

  _initSocketListener(){
    getDetailRoomData(_setRoomData);
    requestDetailRoomData(widget.gameTitle);
    broadCastMessage(_showMessage);
  }
  
  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          return Future(() => false);
        },
        child: Scaffold(
          body: 
            GestureDetector(
              onTap: (){
                FocusScope.of(context).unfocus();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text("망고"),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 50.0)),
                          Character(name: "안녕"),
                          Padding(padding: EdgeInsets.only(top: 50.0)),
                          Character(name: "안녕"),
                          Padding(padding: EdgeInsets.only(top: 50.0)),
                          Character(name: "안녕")
                        ],
                      ),
                      Expanded(
                        child: gameStart ? PhotoQuiz() : BeforeGame()
                      ),
                      Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 50.0)),
                          Character(name: "안녕"),
                          Padding(padding: EdgeInsets.only(top: 50.0)),
                          Character(name: "안녕"),
                          Padding(padding: EdgeInsets.only(top: 50.0)),
                          Character(name: "안녕")
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: chat.length,
                      itemBuilder: (context, index) => 
                        Message(message: chat[index]),
                    ),
                  ),
                  ChatInputField(gameTitle: widget.gameTitle, showMessageMe: showMessageMe)
                ],
              ),
            )
        ),
      ),
    );
  }

  

  _showMessage(String msg){
    print(msg);
    setState(() {
      chat.add(ChatMessage(isSender: false, text: msg));
    });
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut);
  }
  
  showMessageMe(String msg){
    setState(() {
      chat.add(ChatMessage(isSender: true, text: msg));
    });
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut);
  }

  _setRoomData(data){
    print(data);
    print(data.runtimeType);

    data.forEach((k, v){
      if(k == 'gameType') gameType = v;
      else if(k == 'person'){
        v.forEach((vv){
          users.add(vv[0]);
        });
      }
    });
  }
}

class Character extends StatelessWidget {

  const Character({
    Key? key,
    this.name,
  }) : super(key: key);

  final String? name;

  @override
  Widget build(BuildContext context){
    return Row(
      children: <Widget>[
        Text(name!),
        SizedBox(
          width: 10.0,
        ),
        CircleAvatar(
          backgroundImage: AssetImage('assets/cutesexy.jpeg'),
        ),
        SizedBox(
          width: 10.0,
        ),
      ],
    );
  }
}


class PhotoQuiz extends StatelessWidget {
  const PhotoQuiz({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/cutesexy.jpeg', 
          width: 150.0,
          height: 150.0,
        ),
      ],
    );
  }
}


class BeforeGame extends StatelessWidget {
  const BeforeGame({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: (){},
          child: Text("준비하기")
        ),
        ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text("나가기")
        )
      ],
    );
  }
} 