import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:gridfind/gridfind.dart';

class GridDijkstra extends GridStrategy<GridDijkstraState> {
  @override
  void searchStep(GridDijkstraState state) {
    // If there is no open node, we are stuck.
    if (state.open.isEmpty) {
      state.status = Status.failure;
      return;
    }

    GridPoint point = state.open.removeFirst();
    point.set(state.grid, GridNode.closed);

    // If the target node is reached, we are done.
    if (point == state.target) {
      state.status = Status.success;
      return;
    }

    for (var (i, j) in state.dirs) {
      GridPoint newPoint = GridPoint(point.x + i, point.y + j);
      if (state.isUntraversable(newPoint)) continue;

      GridNode newNode = newPoint.get(state.grid);
      if (newNode == GridNode.closed) continue;

      int newGCost = state.gCost[point]! + 1; // Assuming uniform cost

      if (newGCost >= (state.gCost[newPoint] ?? double.infinity)) continue;

      state.parents[newPoint] = point;
      state.gCost[newPoint] = newGCost;

      if (newNode != GridNode.open) {
        state.open.add(newPoint);
        newPoint.set(state.grid, GridNode.open);
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

    newState.open.addAll(
      open.toList(),
    );

    return newState;
  }

  @override
  bool operator ==(Object other) {
    if (other is GridDijkstraState) {
      final mapEquality = const MapEquality();

      return other.start == start &&
          other.target == target &&
          mapEquality.equals(other.parents, parents) &&
          other.status == status;
    }
    return false;
  }
}
