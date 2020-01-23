import 'dart:ui';
import 'dart:math' as math;

import 'point.dart';

/// Class responsible for [Point]-related tasks
class PointManager {

  static double radMax = 15;  // to have variant radiis
  double radOffset = radMax / 2 + 1;
  double speedMultiple = (4.5); // to have variant point speeds
  double speedOffset = 0.5;

  PointManager();

  // generate new points for game
  List<Point> addNewPoints(List<Point> pointsList, int batchSize, Size size) {
    var rng = new math.Random();

    for (var i = 0; i < batchSize; i++) {
      var velocityAngle = rng.nextDouble() * (2 * math.pi);

      pointsList.add(
        Point(
          Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height) * (0.8) 
            + Offset(radMax + radOffset + 1, radMax + radOffset + 1),
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

    if (myPoint.pos.dx + myPoint.rad >= fieldWidth || myPoint.pos.dx - myPoint.rad <= 0) {
      // change horiz speed - collision with side wall
      return Offset(myPoint.vel.dx * -1, myPoint.vel.dy);

    } else if (myPoint.pos.dy + myPoint.rad >= fieldHeight || myPoint.pos.dy - myPoint.rad <= 0) {
      // change vert speed - collision with top/bottom wall
      return Offset(myPoint.vel.dx, myPoint.vel.dy * -1);
    }

    return myPoint.vel;
  }

}
