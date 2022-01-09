import 'package:flutter/material.dart';

class UserID with ChangeNotifier {
  String _id = "0";
  String _name = "GUEST TEST";
  String get myID => _id;
  String get myName => _name;

  void add(id, name) {
    _id = id;
    _name = name;
    notifyListeners();
  }

  void remove() {
    _id = "0";
    _name = "GUEST TEST";
    notifyListeners();
  }
}