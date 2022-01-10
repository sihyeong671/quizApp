import 'dart:convert';

import 'package:client/utils/floatingButton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Ranking extends StatefulWidget {
  const Ranking({ Key? key }) : super(key: key);

  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {

  late var jsonData = [];
  late var jsonDataFromFour = [];

  fetchRanking() async {
    try{
      var res = await http.get(Uri.parse("http://192.249.18.158:80/user/all"));
      setState(() {
        jsonData = jsonDecode(res.body);
        jsonData.sort((a, b) => b['score'].compareTo(a['score']));
        jsonDataFromFour = jsonData.sublist(3);
        print(jsonData);
      });
    } catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRanking();
  }
  
  @override
  Widget build(BuildContext context) {
    var _listView = ListView.separated(
            itemCount: jsonDataFromFour.length,
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('${index+4}' + '등'),
                          SizedBox(
                            width: 10.0,
                          ),
                          CircleAvatar(
                            backgroundImage: NetworkImage(jsonDataFromFour[index]['img']),
                          )
                        ],
                      ),
                      title: Text('${jsonDataFromFour[index]['nickName']}'),
                      subtitle: Text('${jsonDataFromFour[index]['score']}'),
                    ),
                  ]
                )
              );
            }, separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
          );
    
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        floatingActionButton: FloatingButton(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 35.0)),
              Image(
                image: AssetImage('assets/crown.png'),
                width: 70.0,
                height: 70.0,
              ),
              Center(
                child: CircleAvatar(
                  radius: 75.0,
                  backgroundColor: Colors.amberAccent[700],
                  child: CircleAvatar(
                      radius: 68.0,
                      backgroundImage: NetworkImage(jsonData[0]['img']),
                  ),
                ),
              ),
              SizedBox(
                  height: 10.0
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
                        radius: 50.0,
                        backgroundColor: Colors.grey[400],
                        child: CircleAvatar(
                            radius: 43.0,
                            backgroundImage: NetworkImage(jsonData[1]['img']),
                        ),
                      ),
                      SizedBox(
                          height: 10.0
                        ),
                      Text('2등! ${jsonData[1]['nickName']}'),
                      Text('${jsonData[1]['score']}'),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.brown,
                        child: CircleAvatar(
                            radius: 43.0,
                            backgroundImage: NetworkImage(jsonData[2]['img']),
                        ),
                      ),
                      SizedBox(
                          height: 10.0
                        ),
                      Text('3등! ${jsonData[2]['nickName']}'),
                      Text('${jsonData[2]['score']}'),
                    ],
                  ),
                ],
              ),
              SizedBox(
                  height: 15.0
              ),
              Container(
                height: 300,
                child: _listView,
              ),
            ]
          ),
        ),
      ),
    );
  }
}
