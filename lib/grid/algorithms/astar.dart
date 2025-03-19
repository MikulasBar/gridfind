import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:gridfind/grid/grid.dart';

class GridAstar extends GridStrategy<GridAstarState> {
  @override
  void searchStep(GridAstarState state) {
    // If there is no open GridNode, we are stuck.
    if (state.open.isEmpty) {
      state.status = Status.failure;
      return;
    }

    GridPoint point = state.open.removeFirst();
    point.set(state.grid, GridNode.closed);

    // If the target GridNode is reached, we are done.
    if (state.target.get(state.grid) == GridNode.closed) {
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
        state.fCost[newPos] = newGCost + state.heuristic(newPos, state.target);

        if (newGridNode != GridNode.open) {
          state.open.add(newPos);
          newPos.set(state.grid, GridNode.open);
        }
      }
    }
  }
}

class GridAstarState extends GridState {
  late PriorityQueue<GridPoint> open;
  late HashMap<GridPoint, int> fCost;
  late HashMap<GridPoint, int> gCost;
  late int Function(GridPoint, GridPoint) heuristic;

  GridAstarState({
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

  GridAstarState.init(
    GridPoint start,
    GridPoint target,
    List<List<GridNode>> grid,
    bool allowDiagonals,
  ) : super.init(start, target, grid, allowDiagonals) {
    heuristic = allowDiagonals ? chebyshev : taxicab;
    gCost = HashMap.from({start: 0});
    fCost = HashMap.from({start: heuristic(start, target)});
    open = PriorityQueue<GridPoint>((a, b) => fCost[a]!.compareTo(fCost[b]!));
    open.add(start);
    start.set(grid, GridNode.open);
  }

  @override
  GridAstarState copy() {
    var newState = GridAstarState(
      start: start,
      target: target,
      grid: List.generate(grid.length, (i) => List.from(grid[i])),
      parents: HashMap.from(parents),
      dirs: List.from(dirs),
      gCost: HashMap.from(gCost),
      fCost: HashMap.from(fCost),
      open: PriorityQueue<GridPoint>((a, b) => fCost[a]!.compareTo(fCost[b]!)),
      status: status,
      heuristic: heuristic,
    );

    newState.open = PriorityQueue<GridPoint>(
        (a, b) => newState.fCost[a]!.compareTo(newState.fCost[b]!));
    newState.open.addAll(open.toList());

    return newState;
  }
}

int taxicab(GridPoint lhs, GridPoint rhs) {
  return (lhs.x - rhs.x).abs() + (lhs.y - rhs.y).abs();
}

int chebyshev(GridPoint lhs, GridPoint rhs) {
  return max((lhs.x - rhs.x).abs(), (lhs.y - rhs.y).abs());
}
