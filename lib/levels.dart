import 'package:flutter/material.dart';

/// collection of all game levels
///   * Change this file to modify gameplay
class Levels {

  int _numberOfLevels;

  // Level(this._id, this._batchSize, this._sizeRange, this._speedRange, this._initialTime, this._timeBonusDecimal, this._targetScore)
  List<Level> _levels = [
    // Level(1, 10, Offset(2, 15), Offset(0.2, 7.5), 2000, 0.3, 10),
    Level(2, 30, Offset(3, 10), Offset(3.5, 5.5), 1000, 0.2, 10),
    // Level(2, 20, 0.3),
    // Level(3, 20, 0.5),
    // Level(4, 20, 0.7),
    // Level(5, 20, 0.8),
    // Level(6, 10, 0.9),
  ];

  Levels() {
    _numberOfLevels = 100; 

    // BatchSize range = [40 -> 10]
    var initBatch = 30;
    var finalBatch = 5;

    // Point Size ranges = [Offset(10,20) -> Offset(3,5)] 
    var initSizeMin = 10.0;
    var initSizeMax = 18.0;
    var finalSizeMin = 3.0;
    var finalSizeMax = 5.0;

    // Point Speed ranges = [Offset(10,20) -> Offset(3,5)] 
    var initSpeedMin = 0.2;
    var initSpeedMax = 1.5;
    var finalSpeedMin = 0.3;
    var finalSpeedMax = 0.9;

    // Initial Time ranges = [3000 -> 500] msec
    var initStartTime = 2000;
    var finalStartTime = 1000;

    for (int id = 1; id <= _numberOfLevels; id ++) {

      var currentBatchSize = initBatch - ((initBatch - finalBatch)/_numberOfLevels * id).floor();

      _levels.add(Level(
        id, 
        currentBatchSize, 
        Offset(initSizeMin - (initSizeMin - finalSizeMin)/_numberOfLevels * id, initSizeMax - (initSizeMax - finalSizeMax)/_numberOfLevels * id),
        Offset(initSpeedMin - (initSpeedMin - finalSpeedMin)/_numberOfLevels * id, initSpeedMax - (initSpeedMax - finalSpeedMax)/_numberOfLevels * id),
        initStartTime - ((initStartTime/finalStartTime)/_numberOfLevels * id).floor(), 
        0.3, 
        (currentBatchSize * 0.5)
      ));
    }
  }

  int get numberOfLevels => _numberOfLevels;

  Level levelById(int id) {
    for (Level levelObj in _levels) {
      if (levelObj._id == id) {
        return levelObj;
      }
    }

    return Level(null, 3, Offset(3, 20), Offset(0.5, 2.5), 3000, 0.5, 3);  // Level Not found
  }



}

/// Defines a single level
class Level {

  Key _key = UniqueKey();

  final int _id;
  final int _batchSize;
  final Offset _sizeRange;  // Range = [1.0, 30.0) , ranges of sizes , see: pointManager.radMax
  final Offset _speedRange; // Range = (0.0, inf) , ranges of the speed multipier, see: pointManager.speedMultiple
  final int _initialTime; // start time of the Game Timer in milliseconds
  final double _timeBonusDecimal; // Range =  [0.0 , 1.0) , percentage of _initialTime added with every caughtPoint
  final double _targetScore;

  Level(this._id, this._batchSize, this._sizeRange, this._speedRange, this._initialTime, this._timeBonusDecimal, this._targetScore) {
    // requires validation
    assert(this._batchSize > 0);
    assert(_sizeRange.dx > 0 && _sizeRange.dy > _sizeRange.dx);
    assert(_speedRange.dx > 0 && _speedRange.dy > _speedRange.dx);
    assert(_initialTime > 0);
    assert(_timeBonusDecimal >= 0 && _timeBonusDecimal < 1.0);

    // TODO make targetScore a calculated value
    assert(this._targetScore > 0);
  }

  int get levelID => _id;
  int get batchSize => _batchSize;
  double get sizeRangeMin => _sizeRange.dx;
  double get sizeRangeMax => _sizeRange.dy;
  double get speedRangeMin => _speedRange.dx;
  double get speedRangesMax => _speedRange.dy;
  int get initialTime => _initialTime;
  double get timeBonus => _timeBonusDecimal;
  double get targetScore => _targetScore;

}