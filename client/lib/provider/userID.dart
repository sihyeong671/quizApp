import 'package:flutter/material.dart';

class UserID with ChangeNotifier {
  @JsonKey(name: "_id")
  final String id;

  void add() {
    _cout++;
    notifyListeners();
  }

  void remove() {
    _count--;
    notifyListeners();
  }
}