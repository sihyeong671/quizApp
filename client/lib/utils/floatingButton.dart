import 'package:client/lobby/lobby.dart';
import 'package:client/myPage/myPage.dart';
import 'package:client/ranking/ranking.dart';
import 'package:client/utils/socketManager.dart';
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
              onTap: () {
                Navigator.pushReplacement(context, 
                  MaterialPageRoute(builder: (BuildContext context) => Lobby()));
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.bar_chart),
              backgroundColor: Colors.blue,
              label: 'RANKING',
              onTap: () {
                // disconnectSocket();
                Navigator.pushReplacement(context, 
                  MaterialPageRoute(builder: (BuildContext context) => Ranking()));
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.account_circle),
              backgroundColor: Colors.green,
              label: 'MY PAGE',
              onTap: () {
                // disconnectSocket();
                Navigator.pushReplacement(context, 
                  MaterialPageRoute(builder: (BuildContext context) => MyPage()));
              },
            ),
          ],
        );
  }
}