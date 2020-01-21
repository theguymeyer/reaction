/// Author: Guy Meyer
/// App Name: Chain Reaction
/// Rev 1.0.0
/// 
/// In loving memory of Gaby Barsky


// package imports
// import 'dart:async';
// import 'dart:html';
import 'dart:ui';
import 'dart:math';
import 'package:chain_reaction/gameInfo.dart';
import 'package:chain_reaction/fieldManagerWidget.dart';
import 'package:chain_reaction/gameTimer.dart';
import 'package:chain_reaction/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// local imports
// import 'package:chain_reaction/../test/animation_test.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Chain Reaction',

      home: MultiProvider(
        providers: [  // timer notifiers about game events
          ChangeNotifierProvider(create: (context) => TimerNotifier()),
          ChangeNotifierProvider(create: (context) => StatusNotifier()),
        ],
        child: GamePage(),
      )

    );
  }
}

/// This is the main widget in the application
///   child widgets include: Field, restartGame, Timer
class GamePage extends StatefulWidget {
  static List<int> _levels = [3]; // current level inside gameInfo.dart

  GamePage();

  @override
  _GamePageState createState() => new _GamePageState();

}

class _GamePageState extends State<GamePage> {
  // implement Notifier if FieldManagerWidget GestureDectector detects use tap

  FieldManagerWidget myField;
  GameTimer myGameTimer = new GameTimer();
  GameInfo gameInfo = new GameInfo();  

  @override
  void initState() {
    super.initState();

    myField = new FieldManagerWidget(gameInfo); // gameRules: numberOfPoints, speedRanges, radiusRanges

  }

  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Container( // Field
            child: myField
          ),
          Container( // Timer bar
            child: myGameTimer  // needs provider for listener_status: Completed => FieldManager.freezeField()
          ),
          Container( // Reset Button
            alignment: Alignment(-0.85, 0.93),
            child: IconButton(
              alignment: Alignment(1,1),
              icon: Icon(FontAwesomeIcons.redo), 
              iconSize: 40,
              // onPressed: () {print("Pressed"); widget.restartGame(); buildAnimators(); },
              onPressed: () { restartGame(); }
            )
          ),
          Container( // score Text
            alignment: Alignment(0.8, 0.93),
            child: Text(
              "${gameInfo.score.round()}",
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      )
    );

  }

  void restartGame() {
    setState(() {
      // prepare a new field
      myField = new FieldManagerWidget(gameInfo);

      myGameTimer = new GameTimer();
      // Provider.of<TimerNotifier>(context, listen: false).resetTimer();
    });
  }

}

