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
// import 'package:chain_reaction/my_game_timer.dart';
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
        providers: [  // notifiers about game/user events
          // ChangeNotifierProvider(create: (context) => UpdatedCaughtPointNotifier()),
          ChangeNotifierProvider(create: (context) => CaughtPointNotifier()),
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
  // static List<int> _levels = [3,4]; // current level inside gameInfo.dart

  GamePage();

  @override
  _GamePageState createState() {
    return new _GamePageState();
  }

}

class _GamePageState extends State<GamePage> {
  // implement Notifier if FieldManagerWidget GestureDectector detects use tap

  static int currentLevel = 1;

  GameInfo gameInfo;   // Error with this
  FieldManagerWidget myField;
  GameTimer myGameTimer;

  @override
  void initState() {
    super.initState();

    // build game elements
    gameInfo = GameInfo(currentLevel);  
    myField = new FieldManagerWidget(UniqueKey(), gameInfo); // gameRules: numberOfPoints, speedRanges, radiusRanges
    // myGameTimer = new GameTimer(UniqueKey(), gameInfo.timeBonusPerCatch);

  }

  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Container( // Field
            child: myField
          ),
          Builder(builder: (context) {
            return Visibility(
              maintainSize: true, 
              maintainAnimation: true,
              maintainState: true,
              visible: (Provider.of<StatusNotifier>(context).getStatus == Status.userTap) ? true : false, 
              child: Column( // Timer bar
                verticalDirection: VerticalDirection.up,
                children: <Widget>[
                  GameTimer(UniqueKey(), 0.3),
                ]  // needs provider for listener_status: Completed => FieldManager.freezeField()
              ),
            );
          }),
          Container( // Reset Button
            alignment: Alignment(-0.85, 0.93),
            child: IconButton(
              alignment: Alignment(1,1),
              icon: Icon(FontAwesomeIcons.redo), 
              iconSize: 40,
              // onPressed: () {print("Pressed"); widget.restartGame(); buildAnimators(); },
              onPressed: () { restartLevel(); }
            )
          ),
          Container( // score Text
            alignment: Alignment(0.8, 0.93),
            child: Consumer<CaughtPointNotifier>(
              builder: (context, _, __) {

                if (gameInfo.score.round() >= gameInfo.targetScoreForCurrentLevel.round()) {
                  return IconButton(
                    alignment: Alignment(1,1),
                    icon: Icon(FontAwesomeIcons.play), 
                    iconSize: 40,
                    color: Colors.green,
                    onPressed: () { nextLevel(); }
                  );
                } else {
                  return Text(
                    "${gameInfo.score.round()}/${gameInfo.targetScoreForCurrentLevel.round()}",
                    style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.w600,
                      // backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            ),
          ),
        ],
      )
    );

  }

  /// This restart function is only responsible for reseting all necessary fields of the game
  ///   * This function does NOT move to the next level
  ///     => currentLevel = (currentLevel); 
  /// 
  ///   * Get gameInfo for new level
  ///   * reset the; field, timer and notifiers (UpdatedCaughtPoint, Status)
  void restartLevel() {

    setState(() {
      gameInfo = GameInfo(currentLevel);  

      myField = FieldManagerWidget(UniqueKey(), gameInfo);
      // myGameTimer = GameTimer(UniqueKey(), gameInfo.timeBonusPerCatch);
      Provider.of<CaughtPointNotifier>(context, listen: false).reset();
      Provider.of<StatusNotifier>(context, listen: false).setStatus(Status.ready);
    });
  }

  /// Move level counter to next level and restart game
  void nextLevel() {
    setState(() {

      // cycle through the levels
      currentLevel = (currentLevel + 1) % (gameInfo.numberOfLevels + 1);
      print("currentLevel:\t${currentLevel}");
      
    });
    restartLevel();

  }

}

