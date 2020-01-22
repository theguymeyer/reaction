// import 'dart:html';

import 'package:chain_reaction/levels.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';

/// contains: {current score, level batch size, ...}
class GameInfo {

  Levels _allLevels = new Levels();
  int _currentLevel;  /// Level numbering starts from 1 (...humans)

  double _timeBonusPerCatch = 0.6;
  int _batchSize;
  double _score = 0;

  GameInfo(this._currentLevel) {

    _currentLevel = this._currentLevel;
    _batchSize = _allLevels.levelById(_currentLevel).batchSize;
  }

  int get thisLevel => _currentLevel;
  double get timeBonusPerCatch => _timeBonusPerCatch;
  int get batchSize => _batchSize;
  double get score => _score;
  int get numberOfLevels => _allLevels.numberOfLevels;
  double get targetScoreForCurrentLevel => _allLevels.levelById(_currentLevel).targetScore;

  void resetScore() { _score = 0; }
  void addPoints(double points) { _score += points; }

}

