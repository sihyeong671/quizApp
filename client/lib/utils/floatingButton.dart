import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0),
          // this is ignored if animatedIcon is non null
          // child: Icon(Icons.add),
          // visible: _dialVisible,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () => print('OPENING DIAL'),
          onClose: () => print('DIAL CLOSED'),
          tooltip: 'Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 8.0,
          // shape: CircleBorder(),
          children: [
            SpeedDialChild(
              child: Icon(Icons.home),
              backgroundColor: Colors.red,
              label: 'LOBBY',
              // labelStyle: TextTheme(fontSize: 18.0),
            ),
            SpeedDialChild(
              child: Icon(Icons.bar_chart),
              backgroundColor: Colors.blue,
              label: 'RANKING',
              // labelStyle: TextTheme(fontSize: 18.0),
            ),
            SpeedDialChild(
              child: Icon(Icons.account_circle),
              backgroundColor: Colors.green,
              label: 'MY PAGE',
              // labelStyle: TextTheme(fontSize: 18.0),
            ),
          ],
        );
  }
}