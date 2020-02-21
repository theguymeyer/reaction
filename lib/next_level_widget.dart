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
    with TickerProviderStateMixin {
  static Color _startColor = Colors.yellow;
  static Color _endColor = Colors.blue;

  Tween<Color> _nextColorTween;
  Tween<Color> _restartColorTween;

  Animation<Color> _nextAnimation;
  AnimationController _nextAnimationController;

  Animation<Color> _restartAnimation;
  AnimationController _restartAnimationController;

  @override
  initState() {
    super.initState();

    /// Use this to Count down till game over
    _nextAnimationController = new AnimationController(
      vsync: this,

      // countdown time (TODO add to gameInfo variable API)
      duration: new Duration(milliseconds: 700),
    );

    /// Use this to Count down till game over
    _restartAnimationController = new AnimationController(
      vsync: this,

      // countdown time (TODO add to gameInfo variable API)
      duration: new Duration(milliseconds: 700),
    );

    /// tween interpolation
    _nextColorTween = ColorTween(begin: _startColor, end: _endColor);
    _restartColorTween = ColorTween(begin: Colors.black, end: Colors.red);

    /// animation - countdown timer bar
    _nextAnimation = _nextColorTween.animate(_nextAnimationController)
      ..addListener(() {})
      ..addStatusListener((AnimationStatus status) {
        // this makes the button colors tween repeat - provides engaging effect!
        if (_nextAnimation.value == _startColor) {
          _nextAnimationController.forward();
        } else if (_nextAnimation.value == _endColor) {
          _nextAnimationController.reverse();
        }
      });

    _restartAnimation = _restartColorTween.animate(_restartAnimationController)
      ..addListener(() {})
      ..addStatusListener((AnimationStatus status) {});

    // _nextAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    triggerNextLevelButton();

    return Stack(children: <Widget>[
      Selector<StatusNotifier, Status>(
          builder: (context, gameStatus, child) {
            if (gameStatus == Status.finished) {
              triggerRestartLevelButton();
            }
            return AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                height: 100,
                right: (gameStatus == Status.finished) ? 50 : -100,
                bottom: MediaQuery.of(context).size.height * (1.0 / 6) + 2,
                child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.undo,
                      size: 70,
                      color: _restartAnimation.value,
                    ),
                    onPressed: () => widget.restartLevel()));
          },
          selector: (buildContext, statusNotifier) => statusNotifier.getStatus),
      Selector<StatusNotifier, Status>(
          builder: (context, gameStatus, child) {
            if (gameStatus == Status.finished) {
              triggerNextLevelButton();
            }
            return AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                height: 100,
                right: (gameStatus == Status.winner) ? 50 : 500,
                bottom: MediaQuery.of(context).size.height * (1.0 / 6) + 2,
                child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.arrowCircleRight,
                      size: 70,
                      color: _nextAnimation.value,
                    ),
                    onPressed: () => widget.nextLevel()));
          },
          selector: (buildContext, statusNotifier) => statusNotifier.getStatus)
    ]);
  }

  void triggerNextLevelButton() {
    _restartAnimationController.stop();
    _nextAnimationController.forward();
  }

  void triggerRestartLevelButton() {
    _nextAnimationController.stop();
    _restartAnimationController.forward();
  }
}

typedef GameCallback = void Function();
