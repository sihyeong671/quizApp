import 'package:client/inGame/ChatMessage.dart';
import 'package:client/inGame/chat_input_field.dart';
import 'package:client/inGame/message.dart';
import 'package:flutter/material.dart';

class InGame extends StatefulWidget {
  const InGame({ Key? key }) : super(key: key);

  @override
  _InGameState createState() => _InGameState();
}

class _InGameState extends State<InGame> {
  final List<String> comments = <String>[
    '김기영',
    '박시형',
    '정희종',
    '박도윤',
    '공병규',
    '강준서',
  ];
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading:  IconButton(
            onPressed: () {
              Navigator.pop(context); //뒤로가기
            },
            color: Colors.black,
            icon: Icon(Icons.arrow_back)),
        ),
        body: 
          GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 50.0)),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10.0,
                            ),
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/cutesexy.jpeg'),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text('김기영'),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 50.0)),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10.0,
                            ),
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/cutesexy.jpeg'),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text('김기영'),
                            
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 50.0)),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10.0,
                            ),
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/cutesexy.jpeg'),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text('김기영'),
                          ],
                        )
                      ],
                    ),
                    Expanded(
                      child: Image.asset(
                        'assets/cutesexy.jpeg', 
                        width: 150.0,
                        height: 150.0,
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 50.0)),
                        Row(
                          children: <Widget>[
                            Text('김기영'),
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
                        ),
                        Padding(padding: EdgeInsets.only(top: 50.0)),
                        Row(
                          children: <Widget>[
                            Text('김기영'),
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
                        ),
                        Padding(padding: EdgeInsets.only(top: 50.0)),
                        Row(
                          children: <Widget>[
                            Text('김기영'),
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
                        )
                      ],
                    ),
                  ],
                ),
                
                Expanded(
                  child: ListView.builder(
                    itemCount: demeChatMessages.length,
                    itemBuilder: (context, index) => 
                      // Text("${index}"),
                      Message(message: demeChatMessages[index]),
                  ),
                ),
                ChatInputField()
              ],
            ),
          )
      ),
    );
  }
}
