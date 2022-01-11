import 'dart:convert';

import 'package:client/main.dart';
import 'package:client/provider/userID.dart';
import 'package:client/utils/socketManager.dart';
import 'package:flutter/material.dart';
import 'package:client/lobby/lobby.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/all.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

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
    return ScreenUtilInit(
      designSize: const Size(1080, 2280),
      minTextAdapt: true,
      builder: () => 
        Scaffold(
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
                      Padding(padding: EdgeInsets.only(top: 200.sp)),
                      Form(
                        child: Theme(
                          data: ThemeData(
                            primaryColor: Colors.teal,
                            inputDecorationTheme: InputDecorationTheme(
                              labelStyle: TextStyle(
                                color: Colors.teal,
                                fontSize: 15.0.sp
                              )
                            )
                          ),
                          child: Container(
                            padding: EdgeInsets.all(40.0.sp),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 700.0.sp,
                                ),
                                ButtonTheme(
                                    child: TextButton(
                                        child: Image.asset('assets/kakao_login_wide.png'),
                                        onPressed: () async {
                                          try {
                                            _isKaKaoTalkInstalled
                                            ? await UserApi.instance.loginWithKakaoTalk() 
                                            : await UserApi.instance.loginWithKakaoAccount();
                                            
                                            // print(UserApi.instance.accessTokenInfo().toString());
                                            User kakaoUser = await UserApi.instance.me();
                                            var userID = kakaoUser.id.toString();
                                            var name = kakaoUser.properties!['nickname'].toString();
                                            var image = kakaoUser.properties!['thumbnail_image'];
                                            if (image == null){
                                              print("default profile image!");
                                              image = "https://k.kakaocdn.net/dn/dpk9l1/btqmGhA2lKL/Oz0wDuJn1YV2DIn92f6DVK/img_640x640.jpg";
                                            }
                                            
    
                                            var res = await http.get(Uri.parse('http://192.249.18.158:80/user/$userID'));
                                            print("get한거: ${res.body}");
                                            if (jsonDecode(res.body).length == 0) {
                                              res = await http.post(Uri.parse('http://192.249.18.158:80/user/save'),
                                                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                                body: {"userID": userID, "nickName": name, "img": image});
                                              print("post된거: ${res.body}");
                                            }
                                            final jsonData = jsonDecode(res.body);
                                            jsonData.length == 1
                                              ? provider.add(jsonData[0]['userID'], jsonData[0]['nickName'], jsonData[0]['img'], jsonData[0]['score'], false) 
                                              : provider.add(jsonData['userID'], jsonData['nickName'], jsonData['img'], jsonData['score'], false);
                                            
                                            // initSocket();
                                            connectSocket();

                                            Navigator.push(context, 
                                              MaterialPageRoute(builder: (BuildContext context) => const Lobby()));
                                          } catch (e) {
                                            print('error on login: $e');
                                          }
                                        },
                                    )
                                ),
                                SizedBox(
                                  width: 960.0.sp,
                                  height: 140.0.sp,
                                  child: ElevatedButton.icon(
                                    icon: Icon(Icons.add, size: 100.sp),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.amber[900],
                                    ),
                                    label: const Text('게스트 로그인'),
                                    onPressed: () async {
                                        final response = await http.get(Uri.parse("https://nickname.hwanmoo.kr/?format=json&count=1"));
                                        final jsonData = jsonDecode(response.body);
                                        var name = jsonData['words'][0];
                                        var url = "https://images.unsplash.com/photo-1548247416-ec66f4900b2e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=720&q=80";
                                        
                                        provider.add("0", name, url, 0, true);
                                        
                                        // initSocket();
                                        connectSocket();
                                        Navigator.push(context, 
                                          MaterialPageRoute(builder: (BuildContext context) => const Lobby()));
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
      ),
    );
  }

}