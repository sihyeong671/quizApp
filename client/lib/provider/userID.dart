import 'package:flutter/material.dart';

class UserID with ChangeNotifier {
  String _id = "61da81813e4fad319183edd1";
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