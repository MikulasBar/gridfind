
import 'dart:collection';
import 'dart:io';

import 'package:gridfind/gridfind.dart';

abstract class PathFindingState {
  HashSet<Point> open; // Theoretically it doesn't need to be HashSet but I'm too lazy to optimize it.
  Point start;
  Point target;
  List<List<Node>> grid;
  List<List<Point?>> parents;
  Status status;

  PathFindingState({
    required this.open,
    required this.start,
    required this.target,
    required this.grid,
    required this.parents,
    required this.status,
  });

  // This is fucntion that will construct and setup the state.
  static PathFindingState init(Point start, Point target, List<List<Node>> grid) {
    throw UnimplementedError("This function must be initialized");
  }

  int get width => grid.length;
  int get height => grid[0].length;

  bool isUntraversable(Point p) {
    return p.x < 0
      || p.y < 0
      || p.x >= grid.length
      || p.y >= grid[0].length
      || p.get(grid) == Node.obstacle;
  }

  void print() {
    for (var i = 0; i < width; i++) {
      for (var j = 0; j < height; j++) {
        stdout.write(grid[i][j].toChar());
      }
      stdout.writeln();
    }
    stdout.writeln();
  }
}
