import 'package:chain_reaction/gameInfo.dart';
import 'package:chain_reaction/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class GameTimer extends StatefulWidget {

  Key key;
  GameInfo gameInfo;
  // double timeBonus; // beginning of animation

  GameTimer(this.key, this.gameInfo);

  @override
  _GameTimerState createState() => new _GameTimerState();

}

/// Tracks the state of the timer 
///   * the timer setters: stop, reset, start (thru forward) 
///   * Tracks the value of the timer
///   * value = 0 (animation expiry) => level over (freeze field) => StatusNotifier
///   * CaughtPointNotifier => value = value + timeBonus * (CaughtNotifier.value - _caughtPoints) => _caughtPoints = CaughtNotifier.value
///   * move down a pixel every frame
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
      duration: new Duration(milliseconds: widget.gameInfo.initialTimerValue),
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

    /// notifications set by fieldManagerWidget.GestureDectector
    

    /// notifications set by fieldManagerWidget.collisionCheck
    int _newPoints = Provider.of<CaughtPointNotifier>(context).caughtPoints;
    if (_caughtPoints != _newPoints) {
      addTimeToTimer((_newPoints - _caughtPoints) * widget.gameInfo.timeBonusPerCatch);
    }

    // track points internally
    _caughtPoints = _newPoints;



    return Consumer<StatusNotifier>(
      builder: (context, myStatusNotifier, _) {

        (myStatusNotifier.getStatus == Status.ready) ? stop() : null;
        (myStatusNotifier.getStatus == Status.userTap) ? start() : null;

      
        return ClipRRect(
          borderRadius: BorderRadius.circular(80.0),
          child: Container(  // count down bar
            decoration: new BoxDecoration(
              color: Colors.green // TODO add animation here
            ),
            width: MediaQuery.of(context).size.width * 0.04,
            height: MediaQuery.of(context).size.height * (_timerAnimation.value),
          )
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
  /// Triggered by newly frozen points only
  void addTimeToTimer(double timeToAdd) {
    var currValue = _timerAnimation.value;
    var tmpTime = timeToAdd + currValue;

    stop();
    _tween.begin = (tmpTime > 1) ? 1.0 : (tmpTime); // max out at 1
    _tween.end = 0;
    reset();
    start();

    // Provider.of<CaughtPointNotifier>(context, listen: false).toggle();

  }

}