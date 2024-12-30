

import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:gridfind/gridfind.dart';

class Dijkstra extends PathFindingStrategy<DijkstraState> {
  @override
  void searchStep(DijkstraState state) {
    // If there is no open node, we are stuck.
    if (state.open.isEmpty) {
      state.status = Status.failure;
      return;
    }

    Point point = state.open.removeFirst();
    point.set(state.grid, Node.closed);

    // If the target node is reached, we are done.
    if (point == state.target) {
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

        if (newNode != Node.open) {
          state.open.add(newPos);
          newPos.set(state.grid, Node.open);
        }
      }
    }
  }
}


class DijkstraState extends PathFindingState {
  late PriorityQueue<Point> open;
  late Map<Point, int> gCost;

  DijkstraState({
    required super.start,
    required super.target,
    required super.grid,
    required super.status,
    required super.parents,
    required super.dirs,
    required this.open,
    required this.gCost,
  });

  DijkstraState.init(
    Point start,
    Point target,
    List<List<Node>> grid,
    bool allowDiagonals,
  ) : super.init(start, target, grid, allowDiagonals) {
    gCost = {start: 0};
    open = PriorityQueue<Point>((a, b) => gCost[a]!.compareTo(gCost[b]!));
    open.add(start);
    start.set(grid, Node.open);
  }

  @override
  DijkstraState copy() {
    var newState = DijkstraState(
      start: start,
      target: target,
      grid: List.generate(grid.length, (i) => List.from(grid[i])),
      parents: HashMap.from(parents),
      dirs: List.from(dirs),
      gCost: Map.from(gCost),
      open: PriorityQueue<Point>((a, b) => gCost[a]!.compareTo(gCost[b]!)),
      status: status,
    );

    newState.open = PriorityQueue<Point>((a, b) => newState.gCost[a]!.compareTo(newState.gCost[b]!));
    newState.open.addAll(open.toList());

    return newState;
  }
}