import 'package:flutter/material.dart';

class Room extends StatelessWidget {
  const Room({ Key? key }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return <Widget>[
      ListTile(
        leading: Text('1'),
        title: Text('2'),
        subtitle: Text('3'),
      ),
      ButtonBar(
        children: <Widget>[
          TextButton(
            child: Text('참가하기'),
            onPressed: () {},
          )
        ]
      ),
    ];
  }
}