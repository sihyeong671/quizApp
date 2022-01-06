import 'package:client/utils/floatingButton.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  const MyPage({ Key? key }) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingButton(),
        body: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 120.0)),
            Center(
              child: CircleAvatar(
                radius: 70.0,
                backgroundImage: AssetImage('assets/cutesexy.jpeg'),
              )
            ),
            SizedBox(
              height: 40.0
            ),
            Text('Nickname : CUTIE SEXY'),
            SizedBox(
              height: 40.0
            ),
            Text('Score : 180,265'),
            SizedBox(
              height: 40.0
            ),
            Text('Ranking : 55'),
            SizedBox(
              height: 40.0
            ),
            Text('Max Score : 6,847,125'),
            SizedBox(
              height: 40.0
            ),
            Text('Max Ranking : 3'),
            SizedBox(
              height: 40.0
            ),
          ],
        ),
      );
  }
}