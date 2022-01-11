import 'dart:convert';

import 'package:client/utils/floatingButton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Ranking extends StatefulWidget {
  const Ranking({ Key? key }) : super(key: key);

  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  
  late var jsonData = [];
  late var jsonDataFromFour= [];

  fetchRanking() async {
    try{
      var res = await http.get(Uri.parse("http://192.249.18.158:80/user/all"));
      setState(() {
        jsonData = jsonDecode(res.body);
        jsonData.sort((a, b) => b['score'].compareTo(a['score']));
        jsonDataFromFour = jsonData.sublist(3);
      });
    } catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    fetchRanking();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    var _listView = ListView.separated(
            itemCount: jsonDataFromFour.length,
            padding: EdgeInsets.all(8.sp),
            itemBuilder: (context, index) {
              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            '${index+4}' + '등',
                            style: TextStyle(fontSize: 50.sp)
                          ),
                          SizedBox(
                            width: 50.0.sp,
                          ),
                          CircleAvatar(
                            backgroundImage: NetworkImage(jsonDataFromFour[index]['img']),
                            radius: 60.0.sp,
                          )
                        ],
                      ),
                      title: Text(
                        '${jsonDataFromFour[index]['nickName']}',
                        style: TextStyle(fontSize: 50.sp)
                      ),
                      subtitle: Text(
                        '${jsonDataFromFour[index]['score']}',
                        style: TextStyle(fontSize: 50.sp)
                      ),
                      dense:true
                    ),
                  ]
                )
              );
            }, separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
          );
    
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
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 35.0.sp)),
                Image(
                  image: AssetImage('assets/crown.png'),
                  width: 185.0.sp,
                  height: 185.0.sp,
                ),
                Center(
                  child: CircleAvatar(
                    radius: 185.0.sp,
                    backgroundColor: Colors.amberAccent[700],
                    child: CircleAvatar(
                        radius: 168.0.sp,
                        backgroundImage: NetworkImage(jsonData[0]['img']),
                    ),
                  ),
                ),
                SizedBox(
                    height: 10.0.sp
                ),
                Text('1등! ${jsonData[0]['nickName']}'),
                Text('${jsonData[0]['score']}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Padding(padding: EdgeInsets.only(left: 50.0)),
                    Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 160.0.sp,
                          backgroundColor: Colors.grey[400],
                          child: CircleAvatar(
                              radius: 143.0.sp,
                              backgroundImage: NetworkImage(jsonData[1]['img']),
                          ),
                        ),
                        SizedBox(
                            height: 10.0.sp
                          ),
                        Text('2등! ${jsonData[1]['nickName']}'),
                        Text('${jsonData[1]['score']}'),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 160.0.sp,
                          backgroundColor: Colors.brown,
                          child: CircleAvatar(
                              radius: 143.0.sp,
                              backgroundImage: NetworkImage(jsonData[2]['img']),
                          ),
                        ),
                        SizedBox(
                            height: 10.0.sp
                          ),
                        Text('3등! ${jsonData[2]['nickName']}'),
                        Text('${jsonData[2]['score']}'),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                    height: 17.0.sp
                ),
                Container(
                  height: 1050.sp,
                  child: _listView,
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}
