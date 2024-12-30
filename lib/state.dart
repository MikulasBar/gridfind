
import 'dart:collection';
import 'dart:io';
import 'package:gridfind/gridfind.dart';

abstract class PathFindingState {
  Point start;
  Point target;
  List<List<Node>> grid;
  HashMap<Point, Point> parents;
  Status status;

  PathFindingState({
    required this.start,
    required this.target,
    required this.grid,
    required this.parents,
    required this.status,
  });

  PathFindingState.init(
    this.start,
    this.target,
    this.grid,
  )  : parents = HashMap(),
      status = Status.search;

  PathFindingState copy();

  int get width => grid.length;
  int get height => grid[0].length;

  bool isUntraversable(Point p) {
    return p.x < 0
      || p.y < 0
      || p.x >= width
      || p.y >= height
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
