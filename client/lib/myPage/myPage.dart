import 'package:client/auth/login.dart';
import 'package:client/main.dart';
import 'package:client/provider/userID.dart';
import 'package:client/utils/floatingButton.dart';
import 'package:client/myPage/settings.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/all.dart';
import 'package:client/main.dart';

import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:client/utils/socketManager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';




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
    return ScreenUtilInit(
      designSize: Size(1080, 2280),
      minTextAdapt: true,
      builder: () => 
        WillPopScope(
        onWillPop: () {
          return Future(() => false);
        },
        child: Scaffold(
            floatingActionButton: FloatingButton(),
            body: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 150.0.sp)),
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
                        child: Text("로그아웃", style: TextStyle(color: Colors.white),),
                      ),
                      PopupMenuItem<int>(
                        value: 2,
                        child: Text("탈퇴하기", style: TextStyle(color: Colors.red),),
                      ),
                    ],
                    onSelected: (item) => {SelectedItem(context, provider, item)},
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 150.0.sp)),
                Center(
                  child: CircleAvatar(
                    radius: 300.0.sp,
                    // backgroundImage: AssetImage('assets/cutesexy.jpeg'),
                    backgroundImage: NetworkImage(_image),
                  )
                ),
                SizedBox(
                  height: 200.0.sp
                ),
                Text('이름 : ${_name}'),
                SizedBox(
                  height: 40.0.sp
                ),
                if(!_isGuest)...[
                Text('점수 : ${_score}'),
                SizedBox(
                  height: 40.0.sp
                ),
                Text('랭킹 : 1'),
                SizedBox(
                  height: 40.0.sp
                ),
                Text('최고 점수 : -'),
                SizedBox(
                  height: 40.0.sp
                ),
                Text('최고 랭킹 : -'),
                ]
              ],
            ),
          ),
      ),
    );
  }
}

void SelectedItem(BuildContext context, provider, item) {
  switch (item) {
    case 0:
      print(1);
      break;
    case 1:
      var code = UserApi.instance.logout();
      disconnectSocket();
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LogIn()));
      break;
    case 2:
      WidthrawalDialog(context, provider);
      break;
  }
}

void WidthrawalDialog(BuildContext context, provider,) {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0.sp)),
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
                  Navigator.pop(context);
                },
              ),
              new TextButton(
                child: new Text("네"),
                onPressed: () async {
                  var res = await http.delete(Uri.parse('http://192.249.18.158:80/user/${provider.myID}'));
                  print('delete: ${provider.myID}');
                  var code = UserApi.instance.unlink();

                  disconnectSocket();
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) => LogIn()));
                },
              ),
            ],
          );
        });
  }