import 'package:chain_reaction/gameInfo.dart';
import 'package:chain_reaction/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MenuWidgets extends StatelessWidget {
  final int currentLevel;
  final GameCallback restartLevel;
  final GameCallback nextLevel;
  final double _horizPadding = 5;
  final double _elevation = 20;

  const MenuWidgets({this.currentLevel, this.restartLevel, this.nextLevel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
            // reset button
            padding:
                EdgeInsets.symmetric(vertical: 0, horizontal: _horizPadding),
            child: Container(
                child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.red,
                    elevation: _elevation,
                    child: Icon(FontAwesomeIcons.undoAlt),
                    onPressed: () => {restartLevel()}))),
        Padding(
            // info button
            padding:
                EdgeInsets.symmetric(vertical: 0, horizontal: _horizPadding),
            child: Container(
                child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.blue,
                    elevation: _elevation,
                    child: Icon(FontAwesomeIcons.smile),
                    onPressed: () => {}))),
        Padding(
            // new level button
            padding:
                EdgeInsets.symmetric(vertical: 0, horizontal: _horizPadding),
            child: Consumer<StatusNotifier>(
                builder: (context, myStatusNotifer, _) {
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
            }))
      ],
    );
  }
}

typedef GameCallback = void Function();
