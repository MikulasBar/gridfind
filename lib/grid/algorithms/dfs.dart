import 'dart:collection';

import 'package:gridfind/gridfind.dart';

class GridDFS extends GridStrategy<GridDFSState> {
  @override
  void searchStep(GridDFSState state) {
    // If there is no open GridNode, we are stuck.
    if (state.open.isEmpty) {
      state.status = Status.failure;
      return;
    }

    GridPoint point = state.open.removeLast();
    point.set(state.grid, GridNode.closed);

    // We can return because the target GridNode is reached.
    if (state.target.get(state.grid) == GridNode.closed) {
      state.status = Status.success;
      return;
    }

    for (var (i, j) in state.dirs) {
      GridPoint newPos = GridPoint(point.x + i, point.y + j);
      if (state.isUntraversable(newPos)) continue;
      GridNode newGridNode = newPos.get(state.grid);
      if (newGridNode == GridNode.closed) continue;

      if (newGridNode != GridNode.open) {
        state.parents[newPos] = point;
        state.open.add(newPos);
        newPos.set(state.grid, GridNode.open);
      }
    }
  }
}

class GridDFSState extends GridState {
  late List<GridPoint> open;

  GridDFSState({
    required super.start,
    required super.target,
    required super.grid,
    required super.status,
    required super.parents,
    required super.dirs,
    required this.open,
  });

  GridDFSState.init(
    GridPoint start,
    GridPoint target,
    List<List<GridNode>> grid,
    bool allowDiagonals,
  ) : super.init(start, target, grid, allowDiagonals) {
    open = [start];
    start.set(grid, GridNode.open);
  }

  @override
  GridDFSState copy() {
    return GridDFSState(
      start: start,
      target: target,
      grid: List.generate(grid.length, (i) => List.from(grid[i])),
      parents: HashMap.from(parents),
      dirs: List.from(dirs),
      open: List.from(open),
      status: status,
    );
  }
}
