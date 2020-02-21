import 'package:chain_reaction/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RepeatLevelWidget extends StatefulWidget {
  // final int currentLevel;
  final GameCallback restartLevel;
  // final GameCallback nextLevel;

  const RepeatLevelWidget({this.restartLevel});

  @override
  _RepeatLevelWidgetState createState() => _RepeatLevelWidgetState();
}

class _RepeatLevelWidgetState extends State<RepeatLevelWidget>
    with TickerProviderStateMixin {
  static Color _startColor = Colors.red;
  static Color _endColor = Colors.black;

  // Tween<double> _tween;
  Tween<Color> _colorTween;
  Animation<Color> _restartAnimation;
  AnimationController _restartAnimationController;

  @override
  initState() {
    super.initState();

    _restartAnimationController = new AnimationController(
      vsync: this,

      // countdown time (TODO add to gameInfo variable API)
      duration: new Duration(milliseconds: 500),
    );

    /// tween interpolation
    _colorTween = ColorTween(begin: _startColor, end: _endColor);
    // _tween = Tween(begin: 0.0, end: 1.0);

    /// animation - countdown timer bar
    _restartAnimation = _colorTween.animate(_restartAnimationController)
      ..addListener(() {
        // print(_restartAnimation.value);
      })
      ..addStatusListener((AnimationStatus status) {
        // this makes the button colors tween repeat - provides engaging effect!
        if (_restartAnimation.value == _startColor) {
          _restartAnimationController.forward();
        } else if (_restartAnimation.value == _endColor) {
          _restartAnimationController.reverse();
        }
      });

    // _restartAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // print(Provider.of<StatusNotifier>(context).getStatus);
    if (Provider.of<StatusNotifier>(context).getStatus == Status.finished) {
      _restartAnimationController.forward();
    }

    return Stack(children: <Widget>[
      AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          // width: 120,
          //     (Provider.of<StatusNotifier>(context).getStatus ==
          //             Status.finished)
          //         ? 120
          //         : 10,
          height: 100,
          left: (Provider.of<StatusNotifier>(context).getStatus ==
                  Status.finished)
              ? 10
              : 150,
          bottom: MediaQuery.of(context).size.height * (1.0 / 6) + 2,
          child: IconButton(
              icon: Icon(
                FontAwesomeIcons.arrowCircleRight,
                size: 55,
                color: _restartAnimation.value,
              ),
              onPressed: () => widget.restartLevel()))
    ]);
  }
}

typedef GameCallback = void Function();
