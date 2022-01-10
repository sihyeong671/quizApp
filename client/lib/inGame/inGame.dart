import 'dart:ffi';

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

  bool isGameStart = false;
  int gameRound = 0;
  late String gameType;
  List<Character> showUsers = [
    Character(
      id: '/',
      name: '',
      img: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
    ),
    Character(
      id: '/',
      name: '',
      img: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
    ),
    Character(
      id: '/',
      name: '',
      img: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
    ),
    Character(
      id: '/',
      name: '',
      img: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
    ),
    Character(
      id: '/',
      name: '',
      img: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
    ),
    Character(
      id: '/',
      name: '',
      img: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
    ),
  ];
  List<ChatMessage> chat = [];
  final ScrollController _scrollController = ScrollController();

  String problem = '';
  String answer = ''; 
  int gameScore = 0;
  @override
  void initState() {
    super.initState();
    _initSocketListener();
  }


  _initSocketListener(){
    setDetailRoomData(_setRoomData); // 처음에 데이터 받기
    requestDetailRoomData(widget.gameTitle); // 데이터 요청
    broadCastMessage(_showMessage);
    gameStart(_gameStart);
    quizContent(_showQuizData);
    roundOver(_roundOver);
    correctAnswer(_giveScore);
    // 라운드 progress
    // 게임종료
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
                  SizedBox(
                    height: 30.0,
                  ),
                  isGameStart ? Row(
                    children: [
                      Text("타이머 숫자")
                    ],
                  ): SizedBox(height:30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text("${gameRound}"),
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
                        child: isGameStart ? PhotoQuiz() : BeforeGame(name: provider.myName, gameTitle: widget.gameTitle)
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

  _gameStart(){
    if(mounted){
      setState(() {
        isGameStart = true;
      });
    }
    roundStart(widget.gameTitle);
  }

  _showQuizData(String problem, String answer){
    this.problem = problem;
    this.answer = answer;
  }
  
  _showMessage(String msg){
    print(msg);
    if(mounted){
      setState(() {
      chat.add(ChatMessage(isSender: false, text: msg));
    });
    }
    
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
    print(data);
    data.forEach((v, k){
      if(k == 'gameType') gameType = v;
      else if(k == 'gameRound') gameRound = v;
      else if(k == 'person'){
        v.forEach((vv){
          if(mounted){
            setState((){
              showUsers.add(new Character(
                id: vv[0],
                name: vv[1],
                score: gameScore,
                img: vv[3],
              ));
            });
          }
          
          
        });
      }

      while (showUsers.length < 6) {
        if(mounted){
          setState(() {
          showUsers.add(new Character(
          id: '/',
          name: '',
          img: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
        ));
        });
        }
        
      }
    });

    if(mounted){
      
    }
    
    
  }

  _roundOver(){
    print("지연1");
    Future.delayed(Duration(milliseconds: 1000));
    print("지연2");
    setState(() {
      
    });
    gameRound++;
    // Delay
    roundStart(widget.gameTitle);
  }

  _giveScore(int score){
    setState(() {
      gameScore += 5;
    });
    
  }

}

class Character extends StatefulWidget {

  const Character({
    Key? key,
    this.id,
    this.name,
    this.score,
    this.img,
  }) : super(key: key);

  final String? name;
  final String? img;
  final String? id;
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
          backgroundColor: Colors.green,
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


class BeforeGame extends StatefulWidget {
  
  final String gameTitle;
  final String name;
  const BeforeGame({
    Key? key,
    required this.name,
    required this.gameTitle,
    }) : super(key: key);

  @override
  State<BeforeGame> createState() => _BeforeGameState();
}

class _BeforeGameState extends State<BeforeGame> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
            // 
            leaveRoom(widget.gameTitle);
          },
          child: Text("나가기")
        )
      ],
    );
  }
} 
