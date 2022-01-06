import 'package:flutter/material.dart';
import 'package:client/utils/floatingButton.dart';

class Lobby extends StatefulWidget {
  const Lobby({ Key? key }) : super(key: key);

  @override
  _LobbyState createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  final List<String> comments = <String>[
    '시형아 게임하자',
    '정희종 나와',
    '강준서 바보',
    '김기영 너무 멋져',
    '공병규 최고야',
    '박도윤 어디갔어'
  ];

  final List<String> wons = <String>[
    "인물퀴즈",
    "영화 맞추기",
    "노래 맞추기",
    "인물퀴즈",
    "인물퀴즈",
    "인물퀴즈"
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.amber,
      floatingActionButton: FloatingButton(),
      body: ListView.separated(
        itemCount: comments.length,
        padding: EdgeInsets.all(8),
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Text('${index+1}'),
                  title: Text('${comments[index]}'),
                  subtitle: Text('${wons[index]}'),
                ),
                ButtonBar(
                  children: <Widget>[
                    TextButton(
                      child: Text('참가하기'),
                      onPressed: () {},
                    )
                  ]
                ),
              ]
            )
          );
        }, separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
        )
      );
  }
}
