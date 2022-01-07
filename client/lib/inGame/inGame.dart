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
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 30.0)),
                Container(
                  height: 1000,
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(comments.length, (index) {
                      return Card(
                        
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text('${comments[index]}'),
                            ),
                          ]
                        )
                      );
                    }),
                  ),
                ) 
              ]
            ),
          )
      ),
    );
  }
}
