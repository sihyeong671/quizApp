import 'package:client/auth/login.dart';
import 'package:client/main.dart';
import 'package:client/provider/userID.dart';
import 'package:client/utils/floatingButton.dart';
import 'package:client/myPage/settings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/all.dart';

import 'dart:convert';
import 'package:provider/provider.dart';




class MyPage extends StatefulWidget {
  const MyPage({ Key? key }) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  var _name = "guest";
  var _image = "https://source.unsplash.com/random/200x200?sig=1";
  var _score = -1;
  var _isGuest = true;
  final provider = getIt.get<UserID>();
  
  void fetchProfile() async {
    try{
      setState(() {
        _name = provider.myName;
        _image = provider.myImage;
        _score = provider.myScore;
        _isGuest = provider.myIsGuest;
      });
    } catch(err){
      print(err);
    }
  }
  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
          floatingActionButton: FloatingButton(),
          body: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 30.0)),
              Container(
                alignment: Alignment.centerRight,
                child: PopupMenuButton(
                  icon: Icon(Icons.settings),
                  color: Colors.black,
                  itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text("Setting", style: TextStyle(color: Colors.white),),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text("๋ก๊ทธ์์", style: TextStyle(color: Colors.white),),
                    ),
                    PopupMenuItem<int>(
                      value: 2,
                      child: Text("ํํดํ๊ธฐ", style: TextStyle(color: Colors.red),),
                    ),
                  ],
                  onSelected: (item) => {SelectedItem(context, item)},
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 100.0)),
              Center(
                child: CircleAvatar(
                  radius: 70.0,
                  // backgroundImage: AssetImage('assets/cutesexy.jpeg'),
                  backgroundImage: NetworkImage(_image),
                )
              ),
              SizedBox(
                height: 40.0
              ),
              Text('์ด๋ฆ : ${_name}'),
              SizedBox(
                height: 40.0
              ),
              if(!_isGuest)...[
              Text('์?์ : ${_score}'),
              SizedBox(
                height: 40.0
              ),
              Text('๋ญํน : 1'),
              SizedBox(
                height: 40.0
              ),
              Text('์ต๊ณ? ์?์ : -'),
              SizedBox(
                height: 40.0
              ),
              Text('์ต๊ณ? ๋ญํน : -'),
              ]
            ],
          ),
        ),
    );
  }
}

void SelectedItem(BuildContext context, item) {
  switch (item) {
    case 0:
      print(1);
      break;
    case 1:
      var code = UserApi.instance.logout();
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LogIn()));
      break;
    case 2:
      WidthrawalDialog(context);
      break;
  }
}

void WidthrawalDialog(BuildContext context) {
    showDialog(
        context: context,
        //barrierDismissible - Dialog๋ฅผ ์?์ธํ ๋ค๋ฅธ ํ๋ฉด ํฐ์น x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog ํ๋ฉด ๋ชจ์๋ฆฌ ๋ฅ๊ธ๊ฒ ์กฐ์?
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("์ง์ง... ํํด... ํ์ค๊ฒ๋๊น?..."),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "์ง์ง์...?",
                ),
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("์๋์"),
                onPressed: () {
                  var code = UserApi.instance.unlink();
                Navigator.pop(context);
                },
              ),
              new TextButton(
                child: new Text("๋ค"),
                onPressed: () {
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