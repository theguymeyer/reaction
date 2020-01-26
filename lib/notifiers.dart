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

/// used to notify other widgets when a new point is frozen
class CaughtPointNotifier extends ChangeNotifier{

  ValueNotifier<bool> _caughtNewPoint = ValueNotifier(false);

  ValueNotifier<bool> get caughtNewPoint => _caughtNewPoint;

  // notifier does not care about value only when the event occured
  void toggle() {
    _caughtNewPoint = ValueNotifier(!(_caughtNewPoint.value));
    notifyListeners();
  }

}

class UpdatedCaughtPointNotifier extends ChangeNotifier {
  int _caughtPoints = 0;

  int get caughtPoints => _caughtPoints;

  void caughtNew() {
    _caughtPoints++;
    notifyListeners();
  }
}