import 'package:flutter/material.dart';
import 'package:client/utils/floatingButton.dart';

class Lobby extends StatelessWidget {
  const Lobby({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      floatingActionButton: FloatingButton(),
      body: Center(
        child: Text('Lobby~!~!'),
      ),
      
        
      );
  }
}