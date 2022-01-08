import 'package:flutter/cupertino.dart';

class Room{
  int totalNum;
  int currentNum;
  String gameType;
  String gameTitle;
  bool isLock;
  List<String> person;

  Room(
    int totalNum,
    int currentNum,
    String gameType,
    String gameTitle,
    bool isLock,
    List<String> person
  ) : this.totalNum = totalNum,
      this.currentNum = currentNum,
      this.gameType = gameType,
      this.gameTitle = gameTitle,
      this.isLock = isLock,
      this.person = person;

}