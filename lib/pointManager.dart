import 'dart:ui';
import 'dart:math' as math;

import 'package:chain_reaction/gameInfo.dart';
import 'package:chain_reaction/main.dart';

import 'point.dart';

/// Class responsible for [Point]-related tasks
class PointManager {

  GameInfo gameInfo;

  static double radMax;  // to have variant radiis
  double radOffset;
  double speedMultiple; // to have variant point speeds
  double speedOffset;

  PointManager(this.gameInfo) {
    radMax = gameInfo.currentLevel.sizeRangeMax - gameInfo.currentLevel.sizeRangeMin;
    radOffset = (gameInfo.currentLevel.sizeRangeMax + gameInfo.currentLevel.sizeRangeMin) / 2 + 1;
    speedMultiple = gameInfo.currentLevel.speedRangesMax - gameInfo.currentLevel.speedRangeMin;
    speedOffset = (gameInfo.currentLevel.speedRangesMax + gameInfo.currentLevel.speedRangeMin) / 2 + 1;
  }

  // generate new points for game
  List<Point> addNewPoints(List<Point> pointsList, int batchSize, Size size) {
    var rng = new math.Random();

    for (var i = 0; i < batchSize; i++) {
      var velocityAngle = rng.nextDouble() * (2 * math.pi);

      // if angles are shallow (within 10% of x/y axis) increase them by 45 degrees
      if (math.sin(velocityAngle).abs() > 0.9 || math.sin(velocityAngle).abs() < 0.1) { velocityAngle += math.pi / 4; }

      pointsList.add(
        Point(
          Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height) * (0.8)
            + Offset(radMax + radOffset, radMax + radOffset), // to not create points outside field
          rng.nextDouble() * radMax + radOffset,
          (Offset(math.cos(velocityAngle), math.sin(velocityAngle)) * (speedMultiple * rng.nextDouble() + speedOffset) )
        )
      );
    }

    return pointsList;
  }

  /// returns Offset object that represents updated velocity
  ///   if, no wall collisions detected => return unchanged Offset object
  Offset updatePointVelocity(Point myPoint, Size size) {

    // final RenderBox renderBoxRed = parentKey.currentContext.findRenderObject();
    final fieldHeight = size.height;
    final fieldWidth = size.width;


    /// splitting this into individual if statements corrects the issue of the disappearing balls
    /// Objective: if a ball moves outside playing field it will be 'dragged' back into play 
    if (myPoint.pos.dy + myPoint.rad >= fieldHeight) {
      // collision with bottom
      return Offset(myPoint.vel.dx, myPoint.vel.dy.abs() * -1);
    } else if (myPoint.pos.dy - myPoint.rad <= 0) {
      // collision with top
      return Offset(myPoint.vel.dx, myPoint.vel.dy.abs());
    } else if (myPoint.pos.dx + myPoint.rad >= fieldWidth) {
      // collision with right side
      return Offset((myPoint.vel.dx).abs() * -1, myPoint.vel.dy);
    } else if (myPoint.pos.dx - myPoint.rad <= 0) {
      // collision with left side
      return Offset(myPoint.vel.dx.abs(), myPoint.vel.dy);
    }

    return myPoint.vel;
  }

}
