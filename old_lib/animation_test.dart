import 'package:flutter/material.dart';

class TestTimer extends StatefulWidget {

  TestTimer();

  @override
  _TestTimerState createState() => new _TestTimerState();

}

class _TestTimerState extends State<TestTimer> with SingleTickerProviderStateMixin {

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

    /// animation - countdown timer bar
    _timerAnimation = Tween(begin: 1.0, end: 0.0).animate(_timerAnimationController)
      ..addListener(() {
        setState(() {
          
        });
      })
      ..addStatusListener((AnimationStatus status) {
        setState(() {
          if (status == AnimationStatus.completed) {
            print("Completed");
            // Interrupt: fieldManagerWidget.freezeField() - freeze all points (use Provider class)
            // Provider.of<TimerNotifier>(context, listen: false).stopTimer();
          }
        });
      }
    );

    _timerAnimationController.forward();

  }

  @override
  Widget build(BuildContext context) {

    // final timerNotifier = Provider.of<TimerNotifier>(context);

    // if (timerNotifier.isTimerOn) {
    //   print("Starting animation");
    //     start();
    //   // });
    // } else {
    //   stop();
    // }

    print("_timerAnimation.value:\t ${_timerAnimation.value}");

    // if (_timerAnimation.value == 0) {
    //   Provider.of<TimerNotifier>(context, listen: false).endTimer();
    // }

    // Timer has set location/alignment (note: location should probably be in higher widget)
    return Container(  // count down bar
      alignment: Alignment(-1.0, 0.5),
      margin: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.05,
      height: MediaQuery.of(context).size.height * _timerAnimation.value,
      color: Colors.green,
    );
      
  }

  @override
  void dispose() {
    _timerAnimationController.dispose();
    super.dispose();
  }

}