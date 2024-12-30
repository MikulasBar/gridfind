
import 'dart:math';

class Point {
  int x;
  int y;

  Point(this.x, this.y);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Point) return false;
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

  int taxicab(Point rhs) {
    return (x - rhs.x).abs() + (y - rhs.y).abs();
  }

  int chebyshev(Point rhs) {
    return max((x - rhs.x).abs(), (y - rhs.y).abs());
  } 
}

