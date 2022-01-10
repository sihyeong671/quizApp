import 'package:client/provider/userID.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/link.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:client/auth/login.dart';
// import 'com.kakao.sdk.common.util.Utility';


GetIt getIt = GetIt.instance;

void main() {
  getIt.registerSingleton<UserID>(UserID());
  // var keyHash = Utility.getKeyHash(this);
  
  KakaoContext.clientId = "b6b6f5078bcc8d1e50be1b189a5ce58c";
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserID())],
      child: MyApp()));
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

