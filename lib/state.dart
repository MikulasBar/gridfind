
import 'dart:collection';
import 'package:gridfind/gridfind.dart';

const dirs4 = [(1, 0), (0, 1), (-1, 0), (0, -1)];
const dirs8 = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1)];

abstract class PathFindingState {
  Point start;
  Point target;
  List<List<Node>> grid;
  HashMap<Point, Point> parents;
  Status status;
  List<(int, int)> dirs;

  PathFindingState({
    required this.start,
    required this.target,
    required this.grid,
    required this.parents,
    required this.status,
    required this.dirs,
  });

  PathFindingState.init(
    this.start,
    this.target,
    this.grid,
    bool allowDiagonals,
  )  : parents = HashMap(),
      status = Status.search,
      dirs = allowDiagonals ? dirs8 : dirs4;

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

  // void print() {

  //   for (var i = 0; i < width; i++) {
  //     for (var j = 0; j < height; j++) {
  //       stdout.write(grid[i][j].toChar());
  //     }
  //     stdout.writeln();
  //   }
  //   stdout.writeln();
  // }
}
