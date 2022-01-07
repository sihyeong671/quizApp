import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 50.0)),
            Text("소리"),
            Text("진동"),
            Text("로그아웃"),
            Text("푸쉬알림")
          ],
        ),
      ),
    );
  }
}