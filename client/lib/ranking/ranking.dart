import 'package:client/utils/floatingButton.dart';
import 'package:flutter/material.dart';

class Ranking extends StatefulWidget {
  const Ranking({ Key? key }) : super(key: key);

  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  final List<String> users = <String>[
    '김기영',
    '김기영',
    '김기영',
    '김기영',
    '김기영',
    '김기영',
    '김기영',
  ]; 

  final List<String> scores = <String>[
    '48,684',
    '47,122',
    '15,486',
    '9,156',
    '5,612',
    '176',
    '65',
  ]; 
  
  @override
  Widget build(BuildContext context) {
    var _listView = ListView.separated(
            itemCount: users.length,
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
                            backgroundImage: AssetImage('assets/cutesexy.jpeg'),
                          )
                        ],
                      ),
                      title: Text('${users[index]}'),
                      subtitle: Text('${scores[index]}'),
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
              Padding(padding: EdgeInsets.only(top: 50.0)),
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
                      backgroundImage: AssetImage('assets/cutesexy.jpeg'),
                  ),
                ),
              ),
              SizedBox(
                  height: 10.0
              ),
              Text('1등! 김기영'),
              Text('180,265'),
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
                            backgroundImage: AssetImage('assets/cutesexy.jpeg'),
                        ),
                      ),
                      SizedBox(
                          height: 10.0
                        ),
                      Text('2등! 김기영'),
                      Text('90,865'),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.brown,
                        child: CircleAvatar(
                            radius: 43.0,
                            backgroundImage: AssetImage('assets/cutesexy.jpeg'),
                        ),
                      ),
                      SizedBox(
                          height: 10.0
                        ),
                      Text('3등! 김기영'),
                      Text('55,155'),
                    ],
                  ),
                ],
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

// class UsingSeparateListConstructing extends StatelessWidget {
  
  
//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       itemCount: users.length,
//       padding: EdgeInsets.all(8),
//       itemBuilder: (context, index) {
//         return Card(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               ListTile(
//                 leading: Text('${index+1}'),
//                 title: Text('${users[index]}'),
//                 subtitle: Text('${users[index]}'),
//               ),
//             ]
//           )
//         );
//       }, separatorBuilder: (BuildContext context, int index) {
//         return Divider();
//       },
//     );
//   }
// }