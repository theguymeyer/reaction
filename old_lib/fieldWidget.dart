import 'package:chain_reaction/point.dart';
import 'package:chain_reaction/openPainter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Widget to hold all playing field elements (OpenPainter)
/// OpenPainter used to draw canvas and points
/// Widget includes gesture abilities (GestureDetector().onTapDown)
/// Widget includes two animation: Canvas repaint animation + timer animation (green bar)
/// Widget includes two Ticker Widgets via TickerProviderStateMixin
/// Widget references HomePage Widget to restart => restartGame() (Note: should use inherited widget here)
class FieldWidget extends StatefulWidget {

  // Key key = UniqueKey();

  List<Point> points;
  double score;
  bool _flagDropped = false;

  final Function() restartGame;  // flag: true if user tapped screen

  FieldWidget(this.points, this.score, this.restartGame);

  @override
  _FieldWidgetState createState() => new _FieldWidgetState();
}

class _FieldWidgetState extends State<FieldWidget> with TickerProviderStateMixin {

  Animation<double> canvasAnimation;
  Animation<double> timerAnimation; // canvasAnimation variable after user interaction
  AnimationController canvasAnimationController;
  AnimationController timerAnimationController;

  bool _enableGameRestart = false;

  @override
  initState() {
    super.initState();

    print("Init Field!");

    buildAnimators();

    canvasAnimationController.repeat();
    // canvasAnimationController.forward();

  }

  void buildAnimators() {
    /// make canvasAnimation for point motion
    canvasAnimationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 1000),
    );

    /// Count down till game over
    timerAnimationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 2000),
    );

    // TODO test if 0 -> 1.0 endpoints matter...
    canvasAnimation = Tween(begin: 0.0, end: 1.0).animate(canvasAnimationController)
      ..addListener(() {
        setState(() {

          // print("Widget Points ${widget.points}");
          
          for (var p in widget.points) {
            p.updateVelocity(newVelocity(p));
            p.updatePoint();

          }
        });
      }
    );

    /// animation
    timerAnimation = Tween(begin: 1.0, end: 0.0).animate(timerAnimationController)
      ..addStatusListener((AnimationStatus status) {
        // print("Finished ANimation: Game Over\t${status}");
        setState(() {
          if (status == AnimationStatus.completed) {
            for (var p in widget.points) {
              p.stop();
              _enableGameRestart = true;
            }
          }
        });
      }
    );

  }

  @override
  void dispose() {
    canvasAnimationController.dispose();
    timerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (widget._flagDropped) {

      /// changes the velocity of every 'touching' point to Offset(0,0)
      for (var p in widget.points) {
        if (p.vel == Offset(0,0)) {
          for (var pOther in widget.points) {
            pOther.vel = checkCollision(p, pOther) ? caughtPoint(pOther) : pOther.vel;
          }
        }
      }


      // print("USER tapped");

      return Stack(
        children: <Widget> [
          Container(  // count down bar
            alignment: Alignment(-1.0, 1.0),
            margin: const EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width * 0.05,
            height: MediaQuery.of(context).size.height * timerAnimation.value,
            color: Colors.green,
          ),
          CustomPaint(painter: OpenPainter(widget.points)),
          Container(
            alignment: Alignment(0.8, 0.93),
            child: Text(
              "${widget.score.round()}",
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
              alignment: Alignment(-0.85, 0.93),
              child: IconButton(
                icon: Icon(FontAwesomeIcons.redo), 
                iconSize: 40,
                // onPressed: () {print("Pressed"); widget.restartGame(); buildAnimators(); },
                onPressed: _enableGameRestart ? () {print("Pressed"); widget.restartGame(); buildAnimators(); 
                  _enableGameRestart = false;} : null,
              )
            ),
        ]
      );

    } else {

      // print("Not tapped");

      return Stack(
        children: <Widget> [
          GestureDetector(
          behavior: HitTestBehavior.translucent,
          // onTap: () => print('tapped!'),
          onTapDown: (detail) => _onTapDown(detail),
          // onTapUp: (TapUpDetails details) => _onTapUp(details),
          ),
          CustomPaint(painter: OpenPainter(widget.points)),
          Container(
            alignment: Alignment(0.8, 0.93),
            child: Text("${widget.score.round()}",
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ]
      );
    }
  }

  /// Gesture Listener for User Tap on field
  _onTapDown(TapDownDetails details) {
    print('tapped!');

    var x = details.localPosition.dx;
    var y = details.localPosition.dy;
    // print("tap down " + x.toString() + ", " + y.toString());

    Point newPoint = Point(Offset(x,y), 40, Offset(0,0));
    newPoint.stop();

    widget.points.add(newPoint);

    setState(() {
      widget._flagDropped = true;
      timerAnimationController.forward();
    });
  }

  /* Custom Methods */

  /// Check if two points touch
  bool checkCollision(Point p1, Point p2) {
    double dist = (p1.pos - p2.pos).distance;

    return (dist <= (p1.rad + p2.rad)) ? true : false; 
  }

  Offset caughtPoint(Point pOther) {
    
    if (pOther.moving) {
      widget.score += 100;
      pOther.stop();
      return Offset(0,0);
    } else {
      return Offset(0,0);
    }
  }


  /// invoke when atBorder returns true
  Offset newVelocity(Point myPoint) {

    // final RenderBox renderBoxRed = parentKey.currentContext.findRenderObject();
    final fieldHeight = MediaQuery.of(context).size.height;
    final fieldWidth = MediaQuery.of(context).size.width;

    if (myPoint.pos.dx + myPoint.rad >= fieldWidth || myPoint.pos.dx - myPoint.rad <= 0) {
      // change horiz speed
      // vel = Offset(vel.dx * -1, vel.dy);
      return Offset(myPoint.vel.dx * -1, myPoint.vel.dy);
    } else if (myPoint.pos.dy + myPoint.rad >= fieldHeight || myPoint.pos.dy - myPoint.rad <= 0) {
      // change vert speed
      // vel = Offset(myPoint.vel.dx, myPoint.vel.dy * -1);
      return Offset(myPoint.vel.dx, myPoint.vel.dy * -1);
    }

    return myPoint.vel;
  }

}
