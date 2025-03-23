class GridPoint {
  int x;
  int y;

  GridPoint(this.x, this.y);

  @override
  bool operator ==(Object other) {
    if (other is! GridPoint) return false;
    return x == other.x && y == other.y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  /// Gets value from grid.
  T get<T>(List<List<T>> grid) {
    return grid[x][y];
  }

  /// Sets value into grid.
  void set<T>(List<List<T>> grid, T val) {
    grid[x][y] = val;
  }

  @override
  String toString() {
    return '($x, $y)';
  }
}
