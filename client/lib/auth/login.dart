import 'dart:convert';
import 'dart:io';

import 'package:client/myPage/myPage.dart';
import 'package:flutter/material.dart';
import 'package:client/lobby/lobby.dart';
import 'package:client/auth/signUp.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/all.dart';


class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  var _postsJson = [];
  
  // final uri = "https://localhost:8080/user/all";
  final uri = "http://10.0.2.2:8080/user/all";
  
  void fetchPosts() async {
    try{
      final response = await http.get(Uri.parse(uri));
      // print(response);
      final jsonData = jsonDecode(response.body);
      // print(jsonData);
      setState(() {
        _postsJson = jsonData;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    print("작동");
    // fetchPosts();
  }

  // Future<void> _issueAccessToken(String authCode) async {
  //   try {
  //     var token = await AuthApi.instance.issueAccessToken(authCode);
  //     AccessTokenStore.instance.toStore(token);
  //     final kakaoUrl = Uri.parse('[http://10.0.2.2:8080/api/kakao]');
  //     http
  //         .post(kakaoUrl, body: json.encode({'access_token': token}))
  //         .then((res) => print(json.decode(res.body)))
  //         .catchError((e) => print(e.toString()));
  //     Navigator.pushNamed(context, '/');
  //   } catch (error) {
  //     print(error.toString());
  //   }
  // }
  

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
                            TextField(
                              controller: controller1,
                              decoration: InputDecoration(
                                labelText: 'ID',
                                hintText: 'Enter your ID',
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            TextField(
                              controller: controller2,
                              decoration: InputDecoration(
                                labelText: 'PASSWORD',
                                hintText: 'Enter your PW',
                              ),
                              keyboardType: TextInputType.text,
                              obscureText: true,
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            ButtonTheme(
                              minWidth: 100.0,
                              height: 50.0,
                              child: ElevatedButton(
                                child: Text('LOGIN'),
                                onPressed: (){
              
                                  if(controller1.text == 'test' && controller2.text == '1234'){
                                    Navigator.push(context, 
                                      MaterialPageRoute(builder: (BuildContext context) => Lobby()));
                                  } else{
                                    showSnackBar(context);
                                  }
              
                                },
                              )
                            ),
                            ButtonTheme(
                              minWidth: 100.0,
                                height: 50.0,
                                child: TextButton(
                                    child: Image.asset('assets/kakao_login.png'),
                                    onPressed:  () async {
                                      // String authCode = await AuthCodeClient.instance.requestWithTalk();
                                      // await _issueAccessToken(code);
                                      // } catch (error) {
                                      //   print(error.toString());
                                      // }
                                      // print('카카오 연결 성공!'+ authCode);
                                      try {
                                        final token = await UserApi.instance.loginWithKakaoTalk();
                                        print('res이에요'+token.toString());
                                        User kakaoUser = await UserApi.instance.me();
                                        var name = kakaoUser.properties!['nickname'].toString();
                                        var image = kakaoUser.properties!['thumbnail_image'].toString();

                                        
                                        var res = await http.post(Uri.parse('http://10.0.2.2:8080/user/save'),
                                          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                          body: {"nickName": name, "img": image});
                                        Navigator.push(context, 
                                          MaterialPageRoute(builder: (BuildContext context) => MyPage()));
                                      } catch (e) {
                                        print('error on login: $e');
  }
                                    },
                                )
                            ),
                            ButtonTheme(
                              minWidth: 100.0,
                                height: 50.0,
                                child: ElevatedButton(
                                    child: Text("SIGN UP"),
                                    onPressed: () {
                                      Navigator.pushReplacement(context, 
                                        MaterialPageRoute(builder: (BuildContext context) => SignUp()));
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