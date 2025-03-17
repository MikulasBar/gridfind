

import 'dart:collection';

import 'package:gridfind/gridfind.dart';

class GridDFS extends GridStrategy<GridDFSState> {

  @override
  void searchStep(GridDFSState state) {
    // If there is no open NodeState, we are stuck.
    if (state.open.isEmpty) {
      state.status = Status.failure;
      return;
    }

    GridPoint point = state.open.removeLast();
    point.set(state.grid, NodeState.closed);

    // We can return because the target NodeState is reached.
    if (state.target.get(state.grid) == NodeState.closed) {
      state.status = Status.success;
      return;
    }

    for (var (i, j) in state.dirs) {
      GridPoint newPos = GridPoint(point.x + i, point.y + j);
      if (state.isUntraversable(newPos)) continue;
      NodeState newNodeState = newPos.get(state.grid);
      if (newNodeState == NodeState.closed) continue;

      if (newNodeState != NodeState.open) {
        state.parents[newPos] = point;
        state.open.add(newPos);
        newPos.set(state.grid, NodeState.open);
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
    List<List<NodeState>> grid,
    bool allowDiagonals,
  ) : super.init(start, target, grid, allowDiagonals) {
    open = [start];
    start.set(grid, NodeState.open);
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