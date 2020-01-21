/// contains: {current score, level batch size, ...}
class GameInfo {
  double _score = 0;
  int _batchSize = 10;

  int get batchSize => _batchSize;
  double get score => _score;
  void resetScore() => _score = 0;
  void addPoints(double points) { _score += points; }
}