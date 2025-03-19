import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:gridfind/gridfind.dart';

class GridDijkstra extends GridStrategy<GridDijkstraState> {
  @override
  void searchStep(GridDijkstraState state) {
    // If there is no open GridNode, we are stuck.
    if (state.open.isEmpty) {
      state.status = Status.failure;
      return;
    }

    GridPoint point = state.open.removeFirst();
    point.set(state.grid, GridNode.closed);

    // If the target GridNode is reached, we are done.
    if (point == state.target) {
      state.status = Status.success;
      return;
    }

    for (var (i, j) in state.dirs) {
      GridPoint newPos = GridPoint(point.x + i, point.y + j);
      if (state.isUntraversable(newPos)) continue;

      GridNode newGridNode = newPos.get(state.grid);
      if (newGridNode == GridNode.closed) continue;

      int newGCost = state.gCost[point]! + 1; // Assuming uniform cost

      if (newGCost < (state.gCost[newPos] ?? double.infinity)) {
        state.parents[newPos] = point;
        state.gCost[newPos] = newGCost;

        if (newGridNode != GridNode.open) {
          state.open.add(newPos);
          newPos.set(state.grid, GridNode.open);
        }
      }
    }
  }
}

class GridDijkstraState extends GridState {
  late PriorityQueue<GridPoint> open;
  late HashMap<GridPoint, int> gCost;

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
    List<List<GridNode>> grid,
    bool allowDiagonals,
  ) : super.init(start, target, grid, allowDiagonals) {
    gCost = HashMap.from({start: 0});
    open = PriorityQueue<GridPoint>((a, b) => gCost[a]!.compareTo(gCost[b]!));
    open.add(start);
    start.set(grid, GridNode.open);
  }

  @override
  GridDijkstraState copy() {
    var newState = GridDijkstraState(
      start: start,
      target: target,
      grid: List.generate(grid.length, (i) => List.from(grid[i])),
      parents: HashMap.from(parents),
      dirs: List.from(dirs),
      gCost: HashMap.from(gCost),
      open: PriorityQueue<GridPoint>((a, b) => gCost[a]!.compareTo(gCost[b]!)),
      status: status,
    );

    newState.open = PriorityQueue<GridPoint>(
      (a, b) => newState.gCost[a]!.compareTo(newState.gCost[b]!),
    );

    newState.open.addAll(
      open.toList(),
    );

    return newState;
  }
}
