import 'dart:convert';
import 'dart:io';

import 'package:client/main.dart';
import 'package:client/myPage/myPage.dart';
import 'package:client/provider/userID.dart';
import 'package:flutter/material.dart';
import 'package:client/lobby/lobby.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/all.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:client/utils/socketManager.dart';

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
  void initState(){
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
              child: Center(
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
                                height: 100.0,
                              ),
                              ButtonTheme(
                                minWidth: 100.0,
                                  height: 50.0,
                                  child: TextButton(
                                      child: Image.asset('assets/kakao_login_wide.png'),
                                      onPressed: () async {
                                        try {
                                          final token = _isKaKaoTalkInstalled
                                          ? await UserApi.instance.loginWithKakaoTalk() 
                                          : await UserApi.instance.loginWithKakaoAccount();
                                          
                                          // print(UserApi.instance.accessTokenInfo().toString());
                                          User kakaoUser = await UserApi.instance.me();
                                          var userID = kakaoUser.id.toString();
                                          var name = kakaoUser.properties!['nickname'].toString();
                                          var image = kakaoUser.properties!['thumbnail_image'];
                                          // var res;

                                        try{
                                          final res = await http.get(Uri.parse('http://192.249.18.158:80/user/${userID}'));
                                          final jsonData = jsonDecode(res.body);
                                          provider.add(jsonData[0]['userID'], jsonData[0]['nickName'], jsonData[0]['img'], jsonData[0]['score'], false);
                                        } catch(e){
                                          final res = await http.post(Uri.parse('http://192.249.18.158:80/user/save'),
                                            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                            body: {"userID": userID, "nickName": name, "img": image});
                                          final jsonData = jsonDecode(res.body);
                                          provider.add(jsonData[0]['userID'], jsonData[0]['nickName'], jsonData[0]['img'], jsonData[0]['score'], false);
                                        }
                                        

                                          Navigator.push(context, 
                                            MaterialPageRoute(builder: (BuildContext context) => Lobby()));
                                        } catch (e) {
                                          print('error on login: $e');
                                        }
                                      },
                                  )
                              ),
                              SizedBox(
                                width: 296.0,
                                height: 42.0,
                                child: ElevatedButton.icon(
                                  icon: Icon(Icons.add, size: 18),
                                  label: Text('게스트 로그인'),
                                  onPressed: () async {
                                      final response = await http.get(Uri.parse("https://nickname.hwanmoo.kr/?format=json&count=1"));
                                      final jsonData = jsonDecode(response.body);
                                      var name = jsonData['words'][0];
                                      var url = "https://images.unsplash.com/photo-1548247416-ec66f4900b2e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=720&q=80";
                                      
                                      provider.add("0", name, url, 0, true);
                                      Navigator.push(context, 
                                        MaterialPageRoute(builder: (BuildContext context) => Lobby()));
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