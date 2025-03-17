

import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:gridfind/gridfind.dart';

class GridDijkstra extends GridStrategy<GridDijkstraState> {
  @override
  void searchStep(GridDijkstraState state) {
    // If there is no open NodeState, we are stuck.
    if (state.open.isEmpty) {
      state.status = Status.failure;
      return;
    }

    GridPoint point = state.open.removeFirst();
    point.set(state.grid, NodeState.closed);

    // If the target NodeState is reached, we are done.
    if (point == state.target) {
      state.status = Status.success;
      return;
    }

    for (var (i, j) in state.dirs) {
      GridPoint newPos = GridPoint(point.x + i, point.y + j);
      if (state.isUntraversable(newPos)) continue;

      NodeState newNodeState = newPos.get(state.grid);
      if (newNodeState == NodeState.closed) continue;

      int newGCost = state.gCost[point]! + 1; // Assuming uniform cost

      if (newGCost < (state.gCost[newPos] ?? double.infinity)) {
        state.parents[newPos] = point;
        state.gCost[newPos] = newGCost;

        if (newNodeState != NodeState.open) {
          state.open.add(newPos);
          newPos.set(state.grid, NodeState.open);
        }
      }
    }
  }
}


class GridDijkstraState extends GridState {
  late PriorityQueue<GridPoint> open;
  late Map<GridPoint, int> gCost;

  GridDijkstraState({
    required super.start,
    required super.target,
    required super.grid,
    required super.status,
    required super.parents,
    required super.dirs,
    required this.open,
    required this.gCost,
  });

  GridDijkstraState.init(
    GridPoint start,
    GridPoint target,
    List<List<NodeState>> grid,
    bool allowDiagonals,
  ) : super.init(start, target, grid, allowDiagonals) {
    gCost = {start: 0};
    open = PriorityQueue<GridPoint>((a, b) => gCost[a]!.compareTo(gCost[b]!));
    open.add(start);
    start.set(grid, NodeState.open);
  }

  @override
  GridDijkstraState copy() {
    var newState = GridDijkstraState(
      start: start,
      target: target,
      grid: List.generate(grid.length, (i) => List.from(grid[i])),
      parents: HashMap.from(parents),
      dirs: List.from(dirs),
      gCost: Map.from(gCost),
      open: PriorityQueue<GridPoint>((a, b) => gCost[a]!.compareTo(gCost[b]!)),
      status: status,
    );

    newState.open = PriorityQueue<GridPoint>((a, b) => newState.gCost[a]!.compareTo(newState.gCost[b]!));
    newState.open.addAll(open.toList());

    return newState;
  }
}