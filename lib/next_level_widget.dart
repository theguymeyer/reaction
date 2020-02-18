import 'package:chain_reaction/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class NextLevelWidget extends StatefulWidget {
  final int currentLevel;
  final GameCallback restartLevel;
  final GameCallback nextLevel;

  const NextLevelWidget({this.currentLevel, this.nextLevel, this.restartLevel});

  @override
  _NextLevelWidgetState createState() => _NextLevelWidgetState();
}

class _NextLevelWidgetState extends State<NextLevelWidget>
    with SingleTickerProviderStateMixin {

  static Color _startColor = Colors.yellow;
  static Color _endColor = Colors.blue;

  Tween<double> _tween;
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
      duration: new Duration(milliseconds: 700),
    );

    /// tween interpolation
    _colorTween = ColorTween(begin: _startColor, end: _endColor);
    _tween = Tween(begin: 0.0, end: 1.0);

    /// animation - countdown timer bar
    _nextLevelAnimation = _colorTween.animate(_nextLevelAnimationController)
      ..addListener(() {
        // this makes the button colors tween repeat - provides engaging effect!
        if (_nextLevelAnimation.value == _startColor) {
          _nextLevelAnimationController.forward();
        } else if (_nextLevelAnimation.value == _endColor) {
          _nextLevelAnimationController.reverse();
        }
      })
      ..addStatusListener((AnimationStatus status) {
      });

    _nextLevelAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(children: <Widget>[
      AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          width:
              (Provider.of<StatusNotifier>(context).getStatus ==
                      Status.winner)
                  ? 120
                  : 10,
          height: 100,
          right: -5,
          bottom: MediaQuery.of(context).size.height * (1.0 / 6) + 2,
          child: IconButton(
              icon: Icon(FontAwesomeIcons.arrowCircleRight, size: 70, color: _nextLevelAnimation.value,),
              onPressed: () => widget.nextLevel()))
    ]);
  }
}

typedef GameCallback = void Function();
