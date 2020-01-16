/// Author: Guy Meyer
/// App Name: Chain Reaction
/// Rev 1.0.0
/// 
/// In loving memory of Gaby Barsky


// package imports
import 'dart:ui';
import 'dart:math';
import 'package:chain_reaction/fieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// local imports
import 'package:chain_reaction/point.dart';

//creating Key for playing field
// GlobalKey _keyField = GlobalKey();
GlobalKey _keyTimer = GlobalKey();

// Gameplay variables
double score = 0.0;

/// Class responsible for [Point]-related tasks
class PointController {

  double radMax = 15;
  double radOffset = 10;
  double speedMultiple = (1.5);

  PointController();

  // generate new points for game
  List<Point> addNewPoints(List<Point> pointsList, int batchSize, Size size) {
    var rng = new Random();

    for (var i = 0; i < batchSize; i++) {
      pointsList.add(
        Point(
          Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height) * (0.8) 
            + Offset(radMax + radOffset + 1, radMax + radOffset + 1),
          rng.nextDouble() * radMax + radOffset,
          (Offset(rng.nextDouble(), rng.nextDouble()) + Offset(1,1)) * speedMultiple
        )
      );
    }

    return pointsList;
  }

}


class MyHomePage extends StatefulWidget {

  Key _key; //= UniqueKey();
  int batchSize = 10;
  List<Point> points;

  MyHomePage(this._key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
  
}

class _MyHomePageState extends State<MyHomePage> {

  static PointController pm = new PointController();
  bool _flagDropped;

  Animation<double> timerAnimation; // animation variable after user interaction
  AnimationController timerAnimationController;

  void restartApp() {
    setState(() {
      widget._key = UniqueKey();
      widget.points = pm.addNewPoints([], widget.batchSize, MediaQuery.of(context).size);
      _flagDropped = false;
    });
  }

  @override
  initState() {
    super.initState();
    print("Field Init");

    _flagDropped = false;


  }

  @override
  Widget build(BuildContext context) {

    widget.points = pm.addNewPoints([], widget.batchSize, MediaQuery.of(context).size);

    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.red,
        //   title: Text("First Canvas"),
        // ),
        body: new FieldWidget(widget.points, score, restartApp),  // playing field => canvas 
      ),
    );
  }

}

class MyApp extends StatelessWidget {

  // Gameplay variables
  Key homeKey = UniqueKey();
  // List<Point> points = generatePoints([], numberOfPoints);

  void newGame() {
    homeKey = UniqueKey();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'ChainReaction',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new MyHomePage(homeKey),   
    );
  }

}

void main() => runApp(MyApp());

