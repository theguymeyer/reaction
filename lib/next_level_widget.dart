// import 'package:chain_reaction/gameInfo.dart';
import 'package:chain_reaction/notifiers.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class NextLevelWidget extends StatefulWidget {
  final int currentLevel;
  // final GameCallback restartLevel;
  final GameCallback nextLevel;

  const NextLevelWidget({this.currentLevel, this.nextLevel});

  @override
  _NextLevelWidgetState createState() => _NextLevelWidgetState();
}

class _NextLevelWidgetState extends State<NextLevelWidget> with SingleTickerProviderStateMixin {
  // final double _horizPadding = 0;

  // final double _vertPadding = 5;

  // final double _elevation = 20;
  Color _startColor = Colors.transparent;
  Color _endColor = Colors.white;

  Tween<Color> _colorTween;
  Animation<Color> _nextLevelAnimation;
  AnimationController _nextLevelAnimationController;

  @override
  initState() {
    super.initState();

        /// Use this to Count down till game over
    _nextLevelAnimationController = new AnimationController(
      vsync: this,

      // countdown time (TODO add to gameInfo variable API)
      duration: new Duration(milliseconds: 2000),
    );

    /// tween interpolation
    _colorTween = ColorTween(begin: _startColor, end: _endColor);

    /// animation - countdown timer bar
    _nextLevelAnimation = _colorTween.animate(_nextLevelAnimationController)
      ..addListener(() {

        if (_nextLevelAnimation.value == _startColor) {
            _nextLevelAnimationController.forward();
        } else if (_nextLevelAnimation.value == _endColor) {
          _nextLevelAnimationController.reverse();
        }

      })
      ..addStatusListener((AnimationStatus status) {
        // if (status == AnimationStatus.completed) {
          
        // print("${_nextLevelAnimation.value}");

        //   setState(() {
        //     _nextLevelAnimationController.reverse();
        //   }); 
        // // } else if (status == AnimationStatus.values.)
        // }
      }
    );

    _nextLevelAnimationController.forward();

  }

  @override
  Widget build(BuildContext context) {
    return Column(

        /// next level button
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Consumer<StatusNotifier>(builder: (context, myStatusNotifer, _) {
            if (myStatusNotifer.getStatus == Status.winner) {
              return GestureDetector(
                // behavior: HitTestBehavior.translucent,
                onTapDown: (details) => widget.nextLevel(),

                child: Text(
                  "Tap To Continue",
                  style: TextStyle(
                    color: _nextLevelAnimation.value,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w600,
                    // backgroundColor: Colors.green,
                  ),
                ),
              );
            }

            else {
              return Text("");
            }

            // return Text(
            //   "Lv. ${(widget.currentLevel).toString()}",
            //   style: TextStyle(
            //     fontSize: 30.0,
            //     fontWeight: FontWeight.w600,
            //     // backgroundColor: Colors.green,
              // ),
            // );

            // (myStatusNotifer.getStatus == Status.winner)
            //     ? RaisedButton(
            //         elevation: _elevation,
            //         color: Colors.yellow,
            //         child: Text("Lv. ${(currentLevel + 1).toString()}",
            //             style: TextStyle(fontSize: 20)),
            //         onPressed: () {
            //           nextLevel();
            //         },
            //       )
            //     : RaisedButton(
            //         child: Text("Lv. ${(currentLevel).toString()}",
            //             style: TextStyle(fontSize: 20)),
            //         onPressed: () {},
            //       );
          })
        ]);
  }
}

typedef GameCallback = void Function();
