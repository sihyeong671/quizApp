import 'package:client/auth/login.dart';
import 'package:client/main.dart';
import 'package:client/provider/userID.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:http/http.dart' as http;

class Settings extends StatefulWidget {
  const Settings({ Key? key }) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final provider = getIt.get<UserID>();

  @override
  Widget build(BuildContext context) {
    void FlutterDialog() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("진짜... 탈퇴... 하실겁니까?..."),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "진짜요...?",
                ),
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("아니요"),
                onPressed: () {
                  var code = UserApi.instance.unlink();
                Navigator.pop(context);
                },
              ),
              new TextButton(
                child: new Text("네"),
                onPressed: () async {
                  print("시발롬아");
                  print('${provider.myID}');
                  var res = await http.delete(Uri.parse('http://192.249.18.158:80/user/${provider.myID}'));
                  print('delete: $res');

                  var code = UserApi.instance.unlink();
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) => LogIn()));
                },
              ),
            ],
          );
        });
  }
    
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 50.0)),
            Text("소리"),
            Text("진동"),
            Text("푸쉬알림"),
            TextButton(
              onPressed: () {
                var code = UserApi.instance.logout();
                Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (BuildContext context) => LogIn()));
              },
              child: 
                Text('로그아웃')),
            TextButton(
              onPressed: () {
                FlutterDialog();
              },
              child: 
                Text('탈퇴하기')),
          ],
        ),
      ),
    );
  }
}

