import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Spacer(),
        Image.asset('assets/cutesexy.jpeg'),
        Container(
          // padding: EdgeInsets.symmetric(
          // ),
          decoration: BoxDecoration(color: Colors.blue)
        )
      ],
    );
  }
}