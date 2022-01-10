import 'package:client/inGame/ChatMessage.dart';
import 'package:client/inGame/chat_input_field.dart';
import 'package:client/inGame/message.dart';
import 'package:client/models/Room.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/socketManager.dart';
import 'package:tuple/tuple.dart';
import 'package:client/utils/socketManager.dart';

import 'package:client/main.dart';
import 'package:client/provider/userID.dart';

class InGame extends StatefulWidget {
  final String gameTitle;
  const InGame({ Key? key, required this.gameTitle}) : super(key: key);

  @override
  _InGameState createState() => _InGameState();
}

class _InGameState extends State<InGame> {

  final provider = getIt.get<UserID>();

  bool gameStart = false;
  late int gameRound;
  late String gameType;
  late bool myIsHost = false;
  List<Character> showUsers = [

  ];
  List<ChatMessage> chat = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initSocketListener();
  }

  @override
  void dispose() {
    super.dispose();
    leaveRoom(widget.gameTitle);
  }

  _initSocketListener(){
    setDetailRoomData(_setRoomData); // 처음에 데이터 받기
    requestDetailRoomData(widget.gameTitle); // 데이터 요청
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
                          showUsers[0],
                          Padding(padding: EdgeInsets.only(top: 50.0)),
                          showUsers[1],
                          Padding(padding: EdgeInsets.only(top: 50.0)),
                          showUsers[2]
                        ],
                      ),
                      Expanded( 
                        child: gameStart ? PhotoQuiz() : BeforeGame(name: provider.myName, gameTitle: widget.gameTitle, isHost: myIsHost,)
                      ),
                      Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 50.0)),
                          showUsers[3],
                          Padding(padding: EdgeInsets.only(top: 50.0)),
                          showUsers[4],
                          Padding(padding: EdgeInsets.only(top: 50.0)),
                          showUsers[5]
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
    if(mounted){
      setState(() {
        chat.add(ChatMessage(isSender: true, text: msg));
      });
    }
    
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut);
  }

  _setRoomData(data){
    showUsers.clear();
    data.forEach((v, k){
      if(k == 'gameType') gameType = v;
      else if(k == 'gameRound') gameRound = v;
      else if(k == 'person'){
        v.forEach((vv){

          if(vv[1] == provider.myName){
            myIsHost = vv[2];
          }

          showUsers.add(new Character(
            id: vv[0],
            name: vv[1],
            isHost: vv[2],
            isReady: vv[3],
            score: vv[4],
            img: vv[5],
          ));
        });
      }

      while (showUsers.length < 6) {
        showUsers.add(new Character(
          id: '/',
          name: '',
          img: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
        ));
      }
    });

    setState((){

    });
    
  }

  
}

class Character extends StatefulWidget {


  const Character({
    Key? key,
    this.id,
    this.name,
    this.isHost,
    this.isReady,
    this.score,
    this.img,
  }) : super(key: key);

  final String? name;
  final String? img;
  final String? id;
  final bool? isHost;
  final bool? isReady;
  final int? score;

  @override
  State<Character> createState() => _CharacterState();
}

class _CharacterState extends State<Character> {

  late bool isEmpty;
  
  @override
  Widget build(BuildContext context){

    if(widget.id == '/'){
      isEmpty = true;
    }
    else{
      isEmpty = false;
    }

    return Row(
      children: <Widget>[
        Text(widget.name!),
        SizedBox(
          width: 10.0,
        ),
        isEmpty ? CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(widget.img!),
        ) : CircleAvatar(
          radius: 15,
          backgroundColor: (widget.isReady!) ? Colors.green : Colors.red,
          child: CircleAvatar(
            radius: 13,
            backgroundImage: NetworkImage(widget.img!),
          ),
        ),
        SizedBox(
          width: 10.0,
        )
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
  
  final String gameTitle;
  final String name;
  final bool isHost;
  const BeforeGame({
    Key? key,
    required this.name,
    required this.gameTitle,
    required this.isHost
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        !isHost ? ElevatedButton(
          onPressed: (){
            // Host는 게임 시작
            startForGame(name, gameTitle);
          },
          child: Text("게임 시작") 
        ) : ElevatedButton(
          onPressed: (){
            // Host는 게임 시작
            readyForGame(name, gameTitle);
          },
          child: Text("게임 준비") 
        ),
        ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
            // 
            leaveRoom(gameTitle);
          },
          child: Text("나가기")
        )
      ],
    );
  }
}