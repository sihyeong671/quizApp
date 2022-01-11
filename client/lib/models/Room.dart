import 'package:flutter/cupertino.dart';
import 'package:tuple/tuple.dart';

class Room{
  String roomName;
  int totalNum;
  int currentNum;
  bool isLock;
  bool isGameStart;
  Room(
    String roomName,
    int totalNum,
    int currentNum,
    bool isLock,
    bool isGameStart
  ) : this.roomName = roomName,
      this.totalNum = totalNum,
      this.currentNum = currentNum,
      this.isLock = isLock,
      this.isGameStart = isGameStart;
}
