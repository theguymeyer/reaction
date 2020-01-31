// import 'dart:html';

import 'package:chain_reaction/levels.dart';
import 'package:chain_reaction/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';

/// contains: {current score, level batch size, ...}
class GameInfo {

  /// Level numbering starts from 1 (...humans)
  final Levels _allLevels = new Levels();
  int _currentLevel;

  double _timeBonusPerCatch = 0.3;
  int _batchSize;
  static double _score = 0;

  GameInfo(this._currentLevel) {
    _currentLevel = this._currentLevel;
    _batchSize = _allLevels.levelById(_currentLevel).batchSize;
  }

  int get currentLevelID => _currentLevel;
  double get timeBonusPerCatch => _timeBonusPerCatch;
  int get batchSize => _batchSize;
  double get score => _score;
  // double get totalScore => _totalScore.score;
  int get numberOfLevels => _allLevels.numberOfLevels;
  double get targetScoreForCurrentLevel =>
      _allLevels.levelById(_currentLevel).targetScore;
  Level get currentLevel => _allLevels.levelById(_currentLevel);
  int get initialTimerValue => _allLevels.levelById(_currentLevel).initialTime;

  void resetScore() {
    _score = 0;
  }

  void addPoints(double points) {
    _score += points;
    // Provider.of<TotalScore>(context) _totalScore.addTotalPoints(points);
  }

  bool reachedTarget() {
    return (_score >= targetScoreForCurrentLevel) ? true : false;
  }
}
