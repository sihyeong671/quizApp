import 'package:flutter/material.dart';

class UserID with ChangeNotifier {
  String _id = "0";
  String _name = "GUEST TEST";
  String _image = "https://images.unsplash.com/photo-1548247416-ec66f4900b2e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=720&q=80";
  int _score = 0;
  bool _isGuest = true;
  String get myID => _id;
  String get myName => _name;
  String get myImage => _image;
  int get myScore => _score;
  bool get myIsGuest => _isGuest;

  void add(id, name, image, score, isGuest) {
    _id = id;
    _name = name;
    _image = image;
    _score = score;
    _isGuest = isGuest;
    notifyListeners();
  }

  void remove() {
    _id = "0";
    _name = "GUEST TEST";
    String _image = "https://images.unsplash.com/photo-1548247416-ec66f4900b2e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=720&q=80";
    _score = 0;
    _isGuest = true;
    notifyListeners();
  }
}