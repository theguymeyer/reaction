import 'package:flutter/material.dart';

/// collection of all game levels
///   * Change this file to modify gameplay
class Levels {

  int _numberOfLevels;

  List<Level> _levels = [
    Level(1, 100, 0.2),
    Level(2, 20, 0.3),
    Level(3, 20, 0.5),
    Level(4, 20, 0.7),
    Level(5, 20, 0.8),
    Level(6, 10, 0.9),
  ];

  Levels() {_numberOfLevels = _levels.length; }

  int get numberOfLevels => _numberOfLevels;

  Level levelById(int id) {
    for (Level levelObj in _levels) {
      if (levelObj._id == id) {
        return levelObj;
      }
    }

    return Level(null, 1, 0.1);  // Level Not found
  }

}

/// Defines a single level
class Level {

  Key _key = UniqueKey();

  int _id;
  int _batchSize;
  double _difficulty;  // Range = ( 0.0 , 1.0 ]
  double _targetScore;

  Level(this._id, this._batchSize, this._difficulty) {
    // requires validation
    assert(this._batchSize > 0);
    assert(this._difficulty > 0 && this._difficulty <= 1.0);

    _targetScore = (this._batchSize * this._difficulty);
    assert(this._targetScore > 0);
  }

  int get batchSize => _batchSize;
  double get difficulty => _difficulty;
  double get targetScore => _targetScore;
}