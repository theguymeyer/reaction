import 'dart:developer';

import 'package:chain_reaction/gameInfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chain_reaction/notifiers.dart';

class ScoreWidgets extends StatefulWidget {
  GameInfo _gameInfo;

  ScoreWidgets(this._gameInfo);

  @override
  _ScoreWidgetsState createState() => _ScoreWidgetsState();
}

class _ScoreWidgetsState extends State<ScoreWidgets> {
  @override
  Widget build(BuildContext context) {
    return Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                // alignment: Alignment(1.0, 1.0),
                child: Consumer<CaughtPointNotifier>(
                    builder: (context, thisNotifier, _) {
              return Text(
                "${thisNotifier.caughtPoints}/${widget._gameInfo.targetScoreForCurrentLevel.round()}",
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w600,
                  // backgroundColor: Colors.green,
                ),
              );
            })),
            Container(
                // alignment: Alignment(1.0, -1.0),
                child: Consumer<TotalScore>(
                    builder: (context, totalScore, _) {
              return Text(
                "${totalScore.score.round()}",
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w600,
                  // backgroundColor: Colors.green,
                ),
              );
            })),
          ],
        );
  }
}
