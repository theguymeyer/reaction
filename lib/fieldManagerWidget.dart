
import 'dart:async';

import 'package:chain_reaction/gameInfo.dart';
import 'package:chain_reaction/openPainter.dart';
import 'package:chain_reaction/point.dart';
import 'package:chain_reaction/pointManager.dart';
import 'package:chain_reaction/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart'; 

/// Widget to hold all playing field elements (OpenPainter)
/// OpenPainter used to draw canvas and points
/// Widget includes gesture abilities (GestureDetector().onTapDown)
/// Widget includes two animation: Canvas repaint animation + timer animation (green bar)
/// Widget includes two Ticker Widgets via TickerProviderStateMixin
/// Widget references HomePage Widget to restart => restartGame() (Note: should use inherited widget here)

class FieldManagerWidget extends StatefulWidget {

  Key key;
  GameInfo gameInfo;
  List<Point> _pointList = [];  // all points are stored here - move to state widget?

  FieldManagerWidget(this.key, this.gameInfo);

  @override
  _FieldManagerWidgetState createState() => new _FieldManagerWidgetState();

}

class _FieldManagerWidgetState extends State<FieldManagerWidget> {

  static PointManager pm;
  OpenPainter myPainter;
  int _frameCallbackId; // render related - frame scheduling

  void resetField() {
    setState(() {
      widget._pointList = pm.addNewPoints([], widget.gameInfo.batchSize, MediaQuery.of(context).size);
    });
  }

  @override
  initState() {
    super.initState();

    pm  = new PointManager(widget.gameInfo);
    myPainter = new OpenPainter(widget._pointList);

    _scheduleTick();
    // TODO: timer.periodic to create updates every frame

  }

  @override
  Widget build(BuildContext context) {

    if (widget._pointList.length == 0) {  // should this be in initState?
      widget._pointList = pm.addNewPoints([], widget.gameInfo.batchSize, MediaQuery.of(context).size);
    }

    // points exist in field
    assert(widget._pointList.length != 0);

    // final statusNotifier = Provider.of<StatusNotifier>(context);
    
    return Consumer<StatusNotifier>(
      builder: (context, statusNotifier, _) {

        if (statusNotifier.getStatus != Status.ready) {
          (statusNotifier.getStatus == Status.finished || statusNotifier.getStatus == Status.winner) ? freezeField() : null;

          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            // color: Colors.green[50],

            child: CustomPaint(
              painter: new OpenPainter(widget._pointList)
            ),
          );
        }

        return GestureDetector(
          // behavior: HitTestBehavior.translucent,
          onTapDown: (details) => _onTapDown(details),
          
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            // color: Colors.green[50],

            child: CustomPaint(
              painter: new OpenPainter(widget._pointList)
            ),
          ),

        );

      }
    );
  }

  @override
  void dispose() {
    _unscheduleTick();
    super.dispose();
  }


  /* Custom Methods */

  /// Gesture Listener for User Tap on field
  _onTapDown(TapDownDetails details) {
    print('tapped!');

    var x = details.localPosition.dx;
    var y = details.localPosition.dy;

    Point newPoint = Point(Offset(x,y), 50, Offset(0,0));
    newPoint.stop();  // excessive

    // final timerNotifier = Provider.of<TimerNotifier>(context, listen: false).startTimer();
    Provider.of<StatusNotifier>(context, listen: false).setStatus(Status.userTap);

    setState(() {

      widget._pointList.add(newPoint);

    });
  }

  /* Custom Methods */

  /// prep for next step
  void updateField() {

    setState(() {

      checkForCollisionWithFrozen(widget._pointList);

      for (Point p in widget._pointList) {
        p.updateVelocity(pm.updatePointVelocity(p, MediaQuery.of(context).size)); // new velocity if necessary
        p.updatePoint();
      }
    });

    // print("Field Updated!");
  }

  /// change all point velocities to zero (0)
  void freezeField() {
    for (Point p in widget._pointList) {
      p.updateVelocity(Offset(0,0));
    }
  }

  /// checks for points touching frozen points
  List<Point> checkForCollisionWithFrozen(points) {

    for (Point p in points) {
      if (p.vel == Offset(0,0)) { // if `p` is frozen
        for (Point pOther in points) {

          // points touch when their radii combine for more than the distance between their centers
          if ((p.pos - pOther.pos).distance <= (p.rad + pOther.rad)) {
            pOther = caughtPoint(pOther);
          }  

        }
      }
    }

    return points;
  }

  /// stops 'caught' points and updates score if newly caught
  Point caughtPoint(Point myPoint) {
    
    final currentVelocity = myPoint.vel;
    myPoint.stop(); 

    if (currentVelocity != myPoint.vel) {
      Provider.of<CaughtPointNotifier>(context, listen: false).caughtNew();
      widget.gameInfo.addPoints(myPoint.value);
    }

    if (widget.gameInfo.reachedTarget()) {
      Provider.of<StatusNotifier>(context, listen: false).setStatus(Status.winner);
    }

    return myPoint;
  }

  /* Rendering Related Methods */

  // schedule new frame
  
  void _scheduleTick() {
    _frameCallbackId = SchedulerBinding.instance.scheduleFrameCallback(_tick);
  }

  void _unscheduleTick() {
    SchedulerBinding.instance.cancelFrameCallbackWithId(_frameCallbackId);
  }

  void _tick(Duration timestamp) {

    // setState(() {
    updateField();
    // });

    // print("TICK!");
    _scheduleTick();  // prep for new frame


  }

}
