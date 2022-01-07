import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:client/lobby/lobby.dart';
import 'package:client/auth/signUp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;




class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  var _postsJson = [];
  
  final uri = "https://jsonplaceholder.typicode.com/posts";
  
  void fetchPosts() async {
    try{
      final response = await http.get(Uri.parse(uri));
      final jsonData = jsonDecode(response.body) as List;

      setState(() {
        _postsJson = jsonData;
      });
    } catch (err) {}
  }

  @override
  void initState() {
    super.initState();
    fetchPosts();
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
                                    onPressed: (){
                                      final post = _postsJson[0];
                                      Fluttertoast.showToast(msg: '${post["title"]}',
                                      );
                                    },
                                )
                            ),
                            ButtonTheme(
                              minWidth: 100.0,
                                height: 50.0,
                                child: ElevatedButton(
                                    child: Text("SIGN UP"),
                                    onPressed: (){

                                      Navigator.push(context, 
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