
class Point {
  int x;
  int y;

  Point(this.x, this.y);

  /// Gets value from grid.
  T get<T>(List<List<T>> grid) {
    return grid[x][y];
  }

  /// Sets value into grid.
  void set<T>(List<List<T>> grid, T val) {
    grid[x][y] = val;
  }

  int taxicabDist(Point rhs) {
    return (x - rhs.x).abs() + (y - rhs.y).abs();
  }
}

