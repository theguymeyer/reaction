import 'package:chain_reaction/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class GameTimer extends StatefulWidget {

  Key key;
  double timeBonus; // the amount added for every caught Point

  GameTimer(this.key, this.timeBonus);

  @override
  _GameTimerState createState() => new _GameTimerState();

}

class _GameTimerState extends State<GameTimer> with SingleTickerProviderStateMixin {

  int _caughtPoints;
  Tween<double> _tween;
  Animation<double> _timerAnimation;
  AnimationController _timerAnimationController;

  @override
  initState() {
    super.initState();

    _caughtPoints = 0;

    /// Use this to Count down till game over
    _timerAnimationController = new AnimationController(
      vsync: this,

      // countdown time (TODO add to gameInfo variable API)
      duration: new Duration(milliseconds: 3000),
    );

    /// tween interpolation
    _tween = Tween(begin: 1.0, end: 0.0);

    /// animation - countdown timer bar
    _timerAnimation = _tween.animate(_timerAnimationController)
      ..addListener(() {
        setState(() {
        //   // every step
        });
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          Provider.of<StatusNotifier>(context, listen: false).setStatus(Status.finished);

          setState(() {
          }); 
        }
      }
    );

    // _timerAnimationController.forward();

  }

  @override
  Widget build(BuildContext context) {

    // Timer has set location/alignment (TODO: location should probably be in higher widget)
    return Consumer<StatusNotifier>(
      builder: (context, myStatusNotifier, _) {

        (myStatusNotifier.getStatus == Status.ready) ? stop() : null;
        (myStatusNotifier.getStatus == Status.userTap) ? start() : null;

        return Consumer<UpdatedCaughtPointNotifier>(
          builder: (context, myCaughtPointNotifier, _) {

            // TODO make a stream from provider (currently throwing error: setState in build)
            // (myCaughtPointNotifier.caughtNewPoint.value == true) ? addTimeToTimer(widget.timeBonus) : null;

            // if (myCaughtPointNotifier.caughtPoints == context.dependOnInheritedWidgetOfExactType(UpdatedCaughtPointNotifier)) {
            //   // myCaughtPointNotifier.caughtNew();
            // }

            // print("newTimerValue:\t ${myCaughtPointNotifier.caughtPoints - _caughtPoints}");
            newTimerValue(_timerAnimation.value, myCaughtPointNotifier.caughtPoints - _caughtPoints, widget.timeBonus);

            return ClipRRect(
              borderRadius: BorderRadius.circular(80.0),
              child: Container(  // count down bar
                decoration: new BoxDecoration(
                  color: Colors.green // TODO add animation here
                ),
                width: MediaQuery.of(context).size.width * 0.05,
                height: MediaQuery.of(context).size.height * _timerAnimation.value,
                  // * newTimerValue(_timerAnimation.value, myCaughtPointNotifier.caughtPoints - _caughtPoints, widget.timeBonus),
              )
            );
          }
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
  // void regenKey() => widget.key = UniqueKey();

  /// adds time to timerAnimation Tween
  /// Triggered by NEW moving point collisions with frozen points
  void addTimeToTimer(double timeToAdd) {
    var currValue = _timerAnimation.value;
    var tmpTime = timeToAdd + currValue;

    // print("cuaght points");

    stop();
    _tween.begin = (tmpTime > 1) ? 1 : (tmpTime); // max out at 1
    _tween.end = 0;
    reset();
    start();

    // Provider.of<CaughtPointNotifier>(context, listen: false).toggle();

  }

  /// Calculates a multiplier of the maxSize based on the difference in caught points
  ///   * input: int newlyCaughtPoints (number of points caught since last build), double currentSize, double timeBonus (from widget via gameInfo)
  ///   * output: double newTimerValue
  /// 
  ///   * contraints: must be between 0.0 and 1.0
  /// 
  ///   therefore,
  ///     newTimerValue = currentSize + newlyCaughtPoints * timeBonus if <= 1.0 else 1.0
  void newTimerValue(double currentTimerValue, int newlyCaughtPoints, double gameTimeBonus) {
    var tmpTime = currentTimerValue + newlyCaughtPoints * gameTimeBonus;

    assert(tmpTime >= 0.0);
    // TODO: else freezeField()

    print("tmpTime:\t ${(tmpTime > 1.0) ? 1.0 : (tmpTime)}");

    // TODO: setState?
    _caughtPoints = newlyCaughtPoints;

    stop();
    _tween.begin = (tmpTime > 1.0) ? 1.0 : (tmpTime); // max out at 1
    _tween.end = 0.0;
    reset();
    start();

    // upper limit of 1.0
    // return (tmpTime > 1.0) ? 1.0 : (tmpTime);
  }

}