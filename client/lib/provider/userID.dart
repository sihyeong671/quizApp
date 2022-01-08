import 'package:flutter/material.dart';

class UserID with ChangeNotifier {
  String _id = "";
  String get myID => _id;

  void add(id) {
    _id = id;
    notifyListeners();
  }

  void remove() {
    _id = "";
    notifyListeners();
  }
}