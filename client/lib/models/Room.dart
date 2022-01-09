import 'package:flutter/cupertino.dart';
import 'package:tuple/tuple.dart';

class Room{
  int totalNum;
  int currentNum;
  String gameType;
  String gameTitle;
  bool isLock;
  bool isGameStart;
  Room(
    int totalNum,
    int currentNum,
    String gameType,
    String gameTitle,
    bool isLock,
    bool isGameStart
  ) : this.totalNum = totalNum,
      this.currentNum = currentNum,
      this.gameType = gameType,
      this.gameTitle = gameTitle,
      this.isLock = isLock,
      this.isGameStart = isGameStart;
}

class DetailRoom{
  String gameTitle;
  String gameType;
  bool gameStart;
  int gameRound;
  List<Tuple2<String, String>> person;
  List<Tuple2<String, String>> chat;

  DetailRoom(
    String gameTitle,
    String gameType,
    bool gameStart,
    int gameRound,
    List<Tuple2<String, String>> person,
    List<Tuple2<String, String>> chat
  ) : this.gameTitle = gameTitle,
      this.gameType = gameType,
      this.gameStart = gameStart,
      this.gameRound = gameRound,
      this.person = person,
      this.chat = chat;


}