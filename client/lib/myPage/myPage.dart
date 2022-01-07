import 'package:client/utils/floatingButton.dart';
import 'package:client/myPage/settings.dart';
import 'package:flutter/material.dart';




class MyPage extends StatefulWidget {
  const MyPage({ Key? key }) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
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
                  backgroundImage: AssetImage('assets/cutesexy.jpeg'),
                )
              ),
              SizedBox(
                height: 40.0
              ),
              Text('Nickname : CUTIE SEXY'),
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