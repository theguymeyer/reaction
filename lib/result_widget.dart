import 'package:chain_reaction/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ResultWidget extends StatefulWidget {
  final int currentLevel;
  final GameCallback restartLevel;
  final GameCallback nextLevel;

  const ResultWidget({this.currentLevel, this.nextLevel, this.restartLevel});

  @override
  _ResultWidgetState createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget>
    with TickerProviderStateMixin {

  @override
  initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Stack(children: <Widget>[
      Selector<StatusNotifier, Status>(
          builder: (context, gameStatus, child) {
            return AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                height: 100,
                right: (gameStatus == Status.finished) ? 50 : -100,
                bottom: MediaQuery.of(context).size.height * (1.0 / 6) + 2,
                child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.undo,
                      size: 70,
                      color: Colors.yellow,
                    ),
                    onPressed: () => widget.restartLevel()));
          },
          selector: (buildContext, statusNotifier) => statusNotifier.getStatus),
      Selector<StatusNotifier, Status>(
          builder: (context, gameStatus, child) {
            return AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                height: 100,
                right: (gameStatus == Status.winner) ? 50 : 500,
                bottom: MediaQuery.of(context).size.height * (1.0 / 6) + 2,
                child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.arrowCircleRight,
                      size: 70,
                      color: Colors.lightGreen,
                    ),
                    onPressed: () => widget.nextLevel()));
          },
          selector: (buildContext, statusNotifier) => statusNotifier.getStatus)
    ]);
  }

}

typedef GameCallback = void Function();
