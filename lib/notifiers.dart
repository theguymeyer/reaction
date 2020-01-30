import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

enum Status {
  ready,    /// ready for user input
  userTap,  /// user has tapped
  finished  /// timer ran out
}

/// tracks the status of the application
class StatusNotifier extends ChangeNotifier {

  Status _status = Status.ready;

  Status get getStatus => _status;
  
  void setStatus(Status newStatus) {
    _status = newStatus;
    notifyListeners();
  }

}

class CaughtPointNotifier extends ChangeNotifier {
  int _caughtPoints = 0;

  int get caughtPoints => _caughtPoints;

  void caughtNew() {
    _caughtPoints++;
    notifyListeners();
  }

  void reset() {
    _caughtPoints = 0;
  }
}