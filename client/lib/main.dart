import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:client/auth/login.dart';
import 'package:kakao_flutter_sdk/all.dart';


void main() {
  KakaoContext.clientId = 'b6b6f5078bcc8d1e50be1b189a5ce58c';
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LogIn()
      );
  }
}

