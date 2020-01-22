import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

enum Status {
  ready,    // ready for user input
  userTap,  // user has tapped
  finished  // timer ran out
}

class StatusNotifier extends ChangeNotifier {

  Status _status = Status.ready;

  Status get getStatus => _status;
  
  void setStatus(Status newStatus) {
    _status = newStatus;
    notifyListeners();
  }

}

/// used to notify other widgets when a new point is frozen
class CaughtPointNotifier extends ChangeNotifier {
  bool _didCatchNewPoint = false;
  bool get didCatchNewPoint => _didCatchNewPoint;

  void caughtNew() {
    _didCatchNewPoint = true; 
    notifyListeners();
  }

  void resetNotifier() {
    _didCatchNewPoint = false; 
  }

}