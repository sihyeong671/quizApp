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
  final String roomName;

  const InGame({ Key? key,
    required this.roomName
    }) : super(key: key);

  @override
  _InGameState createState() => _InGameState();
}

class _InGameState extends State<InGame> {

  final provider = getIt.get<UserID>();
  List<ChatMessage> chat = [];
  final ScrollController _scrollController = ScrollController();

  late int currnetNum;
  late String problem;
  late String answer;
  late int myGameScore;
  late bool isGameStart;
  late bool isMeReady;
  List<List<dynamic>> users = [];
  List<Character> showUsers = [
    Character(
      id: '/',
      name: '',
      score: 0,
      img: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
      isReady: false,
    ),
    Character(
      id: '/',
      name: '',
      score: 0,
      img: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
      isReady: false,
    ),
    Character(
      id: '/',
      name: '',
      score: 0,
      img: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
      isReady: false,
    ),
    Character(
      id: '/',
      name: '',
      score: 0,
      img: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
      isReady: false,
    ),
    Character(
      id: '/',
      name: '',
      score: 0,
      img: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
      isReady: false,
    ),
    Character(
      id: '/',
      name: '',
      score: 0,
      img: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
      isReady: false,
    )
  ];
  // int limitTime = 10;

  @override
  void dispose() {
    super.dispose();

  }

  @override
  void initState() {
    super.initState();
    _initSocketListener();
  }

  _initSocketListener()async{
    //on
    await getInGameData(_updateInGameData);
    await broadCastMessage(_showMessage);
    await gameStart(_gameStart);
    await gameOver(_gameOver);

    //emit
    await quizContent(_showQuizData);
    await requestRoomData(widget.roomName); // 데이터 요청
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text("캐치브레인"),
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
                        child: isGameStart ? PhotoQuiz(quiz: problem) : BeforeGame(name: provider.myName, roomName: widget.roomName, isReady: isMeReady,)
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
                  ChatInputField(roomName: widget.roomName, showMessageMe: showMessageMe)
                
                ],
              ),
            )
        ),
      ),
    );
  }

  _updateInGameData(roomInfo) {
    showUsers.clear();
    users.clear();
    List<Character> temp = [];
    currnetNum = roomInfo["currentNum"];
    isGameStart = roomInfo["isGameStart"];
    problem = roomInfo["problem"];
    answer = roomInfo["answer"];
    roomInfo["users"].forEach((v){
      if(v[2] == provider.myName) {
        myGameScore = v[1];
        isMeReady = v[4];
      }

      users.add([v[0], v[1], v[2], v[3], v[4]]);
    });
    users.forEach((v) {

      temp.add(Character(
        id: v[0],
        name: v[2],
        score: v[1],
        isReady: v[4],
        img: v[3],
      ));
    });

    print(temp);

    while(temp.length < 6){
      temp.add(Character(
        id: '/',
        name: '',
        score: 0,
        img: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
        isReady: false,
      ));
    }

    setState(() {
      showUsers = temp;
    });
      
  }
  

  _gameStart(data){
    if(mounted){
      setState(() {
        isGameStart = true;
        problem = data["problem"];
        answer = data["answer"];
      });
    }
  }

  _gameOver(){
    if(mounted){
      setState(() {
        isGameStart = false;
        myGameScore = 0;
        isMeReady = false;
      });
    }
  }

  _giveScore(String id, int scoreAdd){
    if(mounted){
      setState(() {
        
      });
    }
  }

  _showQuizData(String problem, String answer){
    this.problem = problem;
    this.answer = answer;
  }
  
  _showMessage(String msg){
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



  // _roundOver(){
  //   print("지연1");
  //   Future.delayed(Duration(milliseconds: 1000));
  //   print("지연2");
  //   setState(() {
  //     gameRound++;
  //   });
  //   if(gameRound < 5) roundStart(widget.roomName);
  //   else{
  //     // 다 쫓아내고 정보 갱신
  //     gameOver(widget.roomName);
  //   } 
    
  //   // Delay
    
  // }


  // _runTimerChange(){
  //   print("시간 줄이기");
  //   setState(() {
  //     limitTime--;
  //   });
  // }


}


class Character extends StatefulWidget {

  
  const Character({
    Key? key,
    required this.id,
    required this.name,
    required this.score,
    required this.isReady,
    required this.img,
  }) : super(key: key);

  final String id;
  final String name;
  final int score;
  final bool isReady;
  final String img;

  @override
  State<Character> createState() => _CharacterState();
}

class _CharacterState extends State<Character> {

  late bool isEmpty;
  late String _name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sliceName(widget.name);
  }

  _sliceName(String name){
    if(name.length > 6){
      _name = name.substring(0, 6)+'...';
    }
    else _name = name;
  }
  
  @override
  Widget build(BuildContext context){

    if(widget.id == '/'){
      isEmpty = true;
    }
    else{
      isEmpty = false;
    }


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isEmpty ? Text('') : Text(widget.score.toString()) ,
        Row(
          children: <Widget>[
            SizedBox(
              width: 10.0,
            ),
            isEmpty ? CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(widget.img),
            ) : CircleAvatar(
              radius: 15,
              backgroundColor: widget.isReady ? Colors.green : Colors.red,
              child: CircleAvatar(
                radius: 13,
                backgroundImage: NetworkImage(widget.img),
              ),
            ),
            SizedBox(
              width: 10.0,
            )
          ],
        ),
        Text(_name)
      ],
    );
  }

}


class PhotoQuiz extends StatefulWidget {
  
  final String quiz;
  const PhotoQuiz({ Key? key, required this.quiz}) : super(key: key);

  @override
  State<PhotoQuiz> createState() => _PhotoQuizState();
}

class _PhotoQuizState extends State<PhotoQuiz> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.quiz)
      ],
    );
  }
}


class BeforeGame extends StatefulWidget {
  
  final String roomName;
  final String name;
  final bool isReady;
  const BeforeGame({
    Key? key,
    required this.name,
    required this.isReady,
    required this.roomName,
    }) : super(key: key);

  @override
  State<BeforeGame> createState() => _BeforeGameState();
}

class _BeforeGameState extends State<BeforeGame> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.isReady ?
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(color: Colors.green)
          ),
          onPressed: (){
            inGameReadyToggle(widget.roomName);
          },
          child: Text("준비하기")
        ):
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(color: Colors.red)
          ),
          onPressed: (){
            inGameReadyToggle(widget.roomName);
          },
          child: Text("준비하기")
        ),
        ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
            // 
            leaveRoom(widget.roomName);
          },
          child: Text("나가기")
        )
      ],
    );
  }
} 
