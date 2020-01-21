import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

/// used to notify other widgets of timer events
///   + control timer from field
class TimerNotifier extends ChangeNotifier {
  bool _timerOn = false;
  bool get isTimerOn => _timerOn;

  void startTimer() {
    print("Timer Running ... ");
    _timerOn = true; 
    notifyListeners();
  }

  void stopTimer() {
    print("Timer Stopped !!! ");
    _timerOn = false; 
    notifyListeners();
  }

}

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