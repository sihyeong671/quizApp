import 'dart:convert';
import 'dart:io';

import 'package:client/main.dart';
import 'package:client/myPage/myPage.dart';
import 'package:client/provider/userID.dart';
import 'package:flutter/material.dart';
import 'package:client/lobby/lobby.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/all.dart';


class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  final provider = getIt.get<UserID>();

  bool _isKaKaoTalkInstalled = true;

  _initKaKaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    setState(() {
      _isKaKaoTalkInstalled = installed;
    });
  }

  @override
  void initState() {
    super.initState();
    _initKaKaoTalkInstalled();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 200)),
                  Form(
                    child: Theme(
                      data: ThemeData(
                        primaryColor: Colors.teal,
                        inputDecorationTheme: InputDecorationTheme(
                          labelStyle: TextStyle(
                            color: Colors.teal,
                            fontSize: 15.0
                          )
                        )
                      ),
                      child: Container(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 40.0,
                            ),
                            ButtonTheme(
                              minWidth: 100.0,
                              height: 50.0,
                              child: ElevatedButton(
                                child: Text('게스트 로그인'),
                                onPressed: (){
                                    provider.add("61da81813e4fad319183edd1");
                                    Navigator.push(context, 
                                      MaterialPageRoute(builder: (BuildContext context) => Lobby()));
                                },
                              )
                            ),
                            ButtonTheme(
                              minWidth: 100.0,
                                height: 50.0,
                                child: TextButton(
                                    child: Image.asset('assets/kakao_login.png'),
                                    onPressed: () async {
                                      try {
                                        final token = _isKaKaoTalkInstalled
                                        ? await UserApi.instance.loginWithKakaoTalk() 
                                        : await UserApi.instance.loginWithKakaoAccount();
                                        
                                        // print(UserApi.instance.accessTokenInfo().toString());
                                        User kakaoUser = await UserApi.instance.me();
                                        var userID = kakaoUser.id.toString();
                                        var name = kakaoUser.properties!['nickname'].toString();
                                        var image = kakaoUser.properties!['thumbnail_image'].toString();

                                        provider.add(userID);
                                        try{
                                          final res = await http.get(Uri.parse('http://10.0.2.2:8080/user/${userID}'));
                                        } catch(e){
                                          await http.post(Uri.parse('http://10.0.2.2:8080/user/save'),
                                          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                          body: {"userID": userID, "nickName": name, "img": image});
                                        }
                                        
                                        Navigator.push(context, 
                                          MaterialPageRoute(builder: (BuildContext context) => MyPage()));
                                      } catch (e) {
                                        print('error on login: $e');
                                      }
                                    },
                                )
                            ),
                          ]
                        )
                      )
                    )
                  )
                ]
              ),
            ),
          );
        }
      )
    );
  }

}

void showSnackBar(BuildContext context){
  Scaffold.of(context).showSnackBar(
    SnackBar(content: 
      Text('로그인 확인 하세욧',
      textAlign: TextAlign.center,),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
    )
  );
}