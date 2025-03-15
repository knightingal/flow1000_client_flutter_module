import 'package:flutter/material.dart';

class ScrollModel extends ChangeNotifier {
  bool scrolling = false;

  void startScrolling() {
    scrolling = true;
    notifyListeners();
  }

  void stopScrolling() {
    scrolling = false;
    notifyListeners();
  }
}

ScrollModel scrollModel = ScrollModel();