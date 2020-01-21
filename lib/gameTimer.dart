import 'package:chain_reaction/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class GameTimer extends StatefulWidget {

  GameTimer() : super();

  @override
  _GameTimerState createState() => new _GameTimerState();

}

class _GameTimerState extends State<GameTimer> with SingleTickerProviderStateMixin {

  Tween<double> _tween;
  Animation<double> _timerAnimation;
  AnimationController _timerAnimationController;

  @override
  initState() {
    super.initState();

    /// Use this to Count down till game over
    _timerAnimationController = new AnimationController(
      vsync: this,

      // countdown time (TODO add to gameInfo variable API)
      duration: new Duration(milliseconds: 2000),
    );

    /// tween interpolation
    _tween = Tween(begin: 1.0, end: 0.0);

    /// animation - countdown timer bar
    _timerAnimation = _tween.animate(_timerAnimationController)
      ..addListener(() {
        setState(() {
          // every step
        });
      })
      ..addStatusListener((AnimationStatus status) {
        setState(() {
          if (status == AnimationStatus.completed) {
            // Interrupt: fieldManagerWidget.freezeField() - freeze all points (use Provider class)
            Provider.of<StatusNotifier>(context, listen: false).setStatus(Status.finished);
          }
        });
      }
    );

    // _timerAnimationController.forward();

  }

  @override
  Widget build(BuildContext context) {

    final timerNotifier = Provider.of<TimerNotifier>(context);
    final statusNotifier = Provider.of<StatusNotifier>(context);

    // print("_timerAnimation.value:\t ${_timerAnimation.value}");

    // Timer has set location/alignment (note: location should probably be in higher widget)
    return Consumer<StatusNotifier>(
      builder: (context, _, __) {

        (statusNotifier.getStatus == Status.userTap) ? start() : null;

        return Container(  // count down bar
          alignment: Alignment(-1.0, 0.5),
          margin: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width * 0.05,
          height: MediaQuery.of(context).size.height * _timerAnimation.value,
          color: Colors.green,
        );
      }
    );
  }

  @override
  void dispose() {
    _timerAnimationController.dispose();
    super.dispose();
  }

  /* Custom Methods */
  void start() => _timerAnimationController.forward();
  void stop() => _timerAnimationController.stop();
  void reset() => _timerAnimationController.reset();

  /// adds time to timerAnimation Tween
  /// Triggered by NEW moving point collisions with frozen points
  void setNewTimerValue(double timeToAdd) {
    var currValue = _timerAnimation.value;
    var tmpTime = timeToAdd + currValue;

    _tween.begin = (tmpTime > 1) ? 1 : (tmpTime); // max out at 1
    _timerAnimationController.reset();
    _tween.end = 0;
    _timerAnimationController.forward();
  }

}