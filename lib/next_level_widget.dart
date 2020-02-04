// import 'package:chain_reaction/gameInfo.dart';
import 'package:chain_reaction/notifiers.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class NextLevelWidget extends StatelessWidget {
  final int currentLevel;
  // final GameCallback restartLevel;
  final GameCallback nextLevel;
  final double _horizPadding = 0;
  final double _vertPadding = 5;
  final double _elevation = 20;

  const NextLevelWidget({this.currentLevel, this.nextLevel});

  @override
  Widget build(BuildContext context) {
    return Column(
        /// next level button
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Consumer<StatusNotifier>(builder: (context, myStatusNotifer, _) {
            return (myStatusNotifer.getStatus == Status.winner)
                ? RaisedButton(
                    elevation: _elevation,
                    color: Colors.yellow,
                    child: Text("Lv. ${(currentLevel + 1).toString()}",
                        style: TextStyle(fontSize: 20)),
                    onPressed: () {
                      nextLevel();
                    },
                  )
                : RaisedButton(
                    child: Text("Lv. ${(currentLevel).toString()}",
                        style: TextStyle(fontSize: 20)),
                    onPressed: () {},
                  );
          })
        ]);
  }
}

typedef GameCallback = void Function();