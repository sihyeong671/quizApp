import 'package:client/main.dart';
import 'package:client/provider/userID.dart';
import 'package:client/utils/floatingButton.dart';
import 'package:client/myPage/settings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
              Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (BuildContext context) => Settings()));
                    },
                  icon: Icon(Icons.settings),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 120.0)),
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
              Text('Nickname : ${_name}'),
              SizedBox(
                height: 40.0
              ),
              if(!_isGuest)...[
              Text('Score : ${_score}'),
              SizedBox(
                height: 40.0
              ),
              Text('Ranking : 1'),
              SizedBox(
                height: 40.0
              ),
              Text('Max Score : -'),
              SizedBox(
                height: 40.0
              ),
              Text('Max Ranking : -'),
              ]
            ],
          ),
        ),
    );
  }
}