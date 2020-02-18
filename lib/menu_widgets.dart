import 'package:chain_reaction/gameInfo.dart';
import 'package:chain_reaction/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MenuWidgets extends StatelessWidget {
  // final int currentLevel;
  final GameCallback restartLevel;
  final GameCallback showInfo;
  // final GameCallback nextLevel;
  final double _horizPadding = 0;
  final double _vertPadding = 0;
  final double _elevation = 10;

  // const MenuWidgets({this.currentLevel, this.restartLevel, this.nextLevel});
  const MenuWidgets({this.restartLevel, this.showInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(

                  /// reset button
                  padding: EdgeInsets.symmetric(
                      vertical: _vertPadding, horizontal: _horizPadding),
                  child: Container(
                      child: FloatingActionButton(
                          mini: true,
                          backgroundColor: Colors.red,
                          elevation: _elevation,
                          child: Icon(FontAwesomeIcons.undoAlt),
                          onPressed: () => {restartLevel()}))),
              Padding(

                  /// info button
                  padding: EdgeInsets.symmetric(
                      vertical: _vertPadding, horizontal: _horizPadding),
                  child: Container(
                      child: FloatingActionButton(
                          mini: true,
                          backgroundColor: Colors.blue,
                          elevation: _elevation,
                          child: Icon(FontAwesomeIcons.smile),
                          onPressed: () => {showInfo()}))),
            ]),

      ],
    );
  }
}

typedef GameCallback = void Function();
