import 'package:chain_reaction/gameInfo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuWidgets extends StatelessWidget {
  final int currentLevel;
  final GameCallback restartLevel;
  final double _horizPadding = 5;
  final double _elevation = 20;

  const MenuWidgets({this.currentLevel, this.restartLevel});

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
            // child: Container(
            // alignment: Alignment(0, -0.85),
            // child: FloatingActionButton(
            //     mini: true,
            //     backgroundColor: Colors.yellow,
            //     elevation: _elevation,
            //     child: Icon(Text("${currentLevel}")),
            //     onPressed: () => {}))),
            child: RaisedButton(
              onPressed: () {},
              child:
                  Text("Lv. ${(currentLevel+1000).toString()}", style: TextStyle(fontSize: 20)),
            ))
      ],
    );
  }
}

typedef GameCallback = void Function();
