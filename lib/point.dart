import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

/// Defines a point on the playing field that could be covered to gamePoints
/// Constructor: this.pos, this.rad, this.vel, this.parentKey
class Point {
  Offset pos; // position
  double rad;  // radius
  Offset vel; // direction of motion (speed and direction) as 2D vector
  final Paint _paint;
  bool moving = true;
  double _value = 1;

  // color randomization
  static List<Color> colorList = [Colors.green, Colors.red, Colors.blue, Colors.yellow, Colors.white];
  Color myColor = colorList[Random().nextInt(colorList.length)];

  Point(this.pos, this.rad, this.vel) : _paint = Paint()..color = Colors.red;

  Offset get nextPos => pos + vel;
  double get value => _value;

  void updateVelocity(Offset newVel) => vel = newVel;

  // stop moving
  void stop() { 
    moving = false; 
    vel = Offset(0,0);
  }

  /// updates point to new position
  void updatePos() {
    pos = pos + vel;
    // print("pos:\t $pos");
  }

  bool updatePoint() {

    try {
      updatePos();
      // updateVelocity();

      return true;
    } catch(e) {
      print("Error:\t $e");
      return false;
    }
  }

}
