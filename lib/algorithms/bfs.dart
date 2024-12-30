import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:gridfind/gridfind.dart';

class BFS extends PathFindingStrategy<BFSState> {
  @override
  void searchStep(BFSState state) {
    // If there is no open node, we are stuck.
    if (state.open.isEmpty) { 
      state.status = Status.failure;
      return;
    }

    Point point = state.open.removeFirst();
    point.set(state.grid, Node.closed);

    // We can return because the cost is checked when target node is open.
    // And parent is already set from that stage.  
    if (state.target.get(state.grid) == Node.closed) {
      state.status = Status.success;
      return;
    }

    // TODO: change the list of directions. User should be able to change if diagonal is allowed.
    for (var (i, j) in [(1, 0), (-1, 0), (0, 1), (0, -1)]) {
      Point newPos = Point(point.x + i, point.y + j);
      if (state.isUntraversable(newPos)) continue;
      Node newNode = newPos.get(state.grid);
      // We first need to check if the point is out of bounds and then get the Node.
      if (newNode == Node.closed) continue;

      final newPosParent = state.parents[newPos];
      final parentCost = state.cost[newPosParent];
      final pointCost = state.cost[point]!;
      // First check the node because when it's not open it will throw error due to the ! null check.
      if (newNode != Node.open || parentCost! > pointCost) {
        state.parents[newPos] = point;
        // Every values is derived from parent: parentCost + 1.
        // Closer to start is better.
        state.cost[newPos] = pointCost + 1;
        state.open.remove(newPos);
        state.open.add(newPos);
        newPos.set(state.grid, Node.open);
      }
    }
  }
}

class BFSState extends PathFindingState {
  late HeapPriorityQueue<Point> open;
  late HashMap<Point, int> cost;

  BFSState({
    required super.start,
    required super.target,
    required super.grid,
    required super.status,
    required super.parents,
    required this.cost,
    required this.open,
  });

  BFSState.init(
    super.start,
    super.target,
    super.grid,
  ) : super.init() {
    cost = HashMap.from({start: 0});
    open = HeapPriorityQueue<Point>((a, b) => cost[a]!.compareTo(cost[b]!));
    open.add(start);
    start.set(grid, Node.open);
  }

  @override
  BFSState copy() {
    return BFSState(
      status: status,
      start: start,
      target: target,
      grid: List.generate(grid.length, (i) => List.from(grid[i])),
      parents: HashMap.from(parents),
      cost: HashMap.from(cost),
      open: open..addAll(open.toList())
    );
  }
}