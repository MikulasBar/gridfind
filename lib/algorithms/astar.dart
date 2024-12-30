
import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:gridfind/gridfind.dart';

class Astar extends PathFindingStrategy<AstarState> {
  @override
  void searchStep(AstarState state) {
    // If there is no open node, we are stuck.
    if (state.open.isEmpty) {
      state.status = Status.failure;
      return;
    }

    Point point = state.open.removeFirst();
    point.set(state.grid, Node.closed);

    // If the target node is reached, we are done.
    if (state.target.get(state.grid) == Node.closed) {
      state.status = Status.success;
      return;
    }

    for (var (i, j) in state.dirs) {
      Point newPos = Point(point.x + i, point.y + j);
      if (state.isUntraversable(newPos)) continue;

      Node newNode = newPos.get(state.grid);
      if (newNode == Node.closed) continue;

      int newGCost = state.gCost[point]! + 1; // Assuming uniform cost

      if (newGCost < (state.gCost[newPos] ?? double.infinity)) {
        state.parents[newPos] = point;
        state.gCost[newPos] = newGCost;
        state.fCost[newPos] = newGCost + state.heuristic(newPos, state.target);

        if (newNode != Node.open) {
          state.open.add(newPos);
          newPos.set(state.grid, Node.open);
        }
      }
    }
  }
}


class AstarState extends PathFindingState {
  late PriorityQueue<Point> open;
  late Map<Point, int> fCost;
  late Map<Point, int> gCost; 
  late int Function(Point, Point) heuristic;

  AstarState({
    required super.start,
    required super.target,
    required super.grid,
    required super.status,
    required super.parents,
    required super.dirs,
    required this.open,
    required this.fCost,
    required this.gCost,
    required this.heuristic,
  });

  AstarState.init(
    Point start,
    Point target,
    List<List<Node>> grid,
    bool allowDiagonals,
  ) : super.init(start, target, grid, allowDiagonals) {
    heuristic = allowDiagonals ? chebyshev : taxicab;
    gCost = {start: 0};
    fCost = {start: heuristic(start, target)};
    open = PriorityQueue<Point>((a, b) => fCost[a]!.compareTo(fCost[b]!));
    open.add(start);
    start.set(grid, Node.open);
  }

  @override
  AstarState copy() {
    var newState = AstarState(
      start: start,
      target: target,
      grid: List.generate(grid.length, (i) => List.from(grid[i])),
      parents: HashMap.from(parents),
      dirs: List.from(dirs),
      gCost: Map.from(gCost),
      fCost: Map.from(fCost),
      open: PriorityQueue<Point>((a, b) => fCost[a]!.compareTo(fCost[b]!)),
      status: status,
      heuristic: heuristic,
    );

    newState.open = PriorityQueue<Point>((a, b) => newState.fCost[a]!.compareTo(newState.fCost[b]!));
    newState.open.addAll(open.toList());

    return newState;
  }
}

int taxicab(Point lhs, Point rhs) {
  return (lhs.x - rhs.x).abs() + (lhs.y - rhs.y).abs();
}

int chebyshev(Point lhs, Point rhs) {
  return max((lhs.x - rhs.x).abs(), (lhs.y - rhs.y).abs());
} 