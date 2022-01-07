import 'package:client/utils/floatingButton.dart';
import 'package:client/myPage/settings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';




class MyPage extends StatefulWidget {
  const MyPage({ Key? key }) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  
  var _name = "guest";
  var _image = "https://source.unsplash.com/random/200x200?sig=1";
  
  void fetchProfile() async {
    try{
      final res = await http.get(Uri.parse('http://10.0.2.2:8080/user/all'));
      final jsonData = jsonDecode(res.body);
      print(jsonData);
      setState(() {
        _name = jsonData[0]['nickName'];
        _image = jsonData[0]['img'];

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
              Text('Score : 180,265'),
              SizedBox(
                height: 40.0
              ),
              Text('Ranking : 1'),
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
        ),
    );
  }
}