import 'dart:collection';
import 'package:gridfind/gridfind.dart';

class GridBFS extends GridStrategy< GridBFSState> {
  @override
  void searchStep( GridBFSState state) {
    // If there is no open NodeState, we are stuck.
    if (state.open.isEmpty) {
      state.status = Status.failure;
      return;
    }

    GridPoint point = state.open.removeFirst();
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

class  GridBFSState extends GridState {
  late Queue<GridPoint> open;

   GridBFSState({
    required super.start,
    required super.target,
    required super.grid,
    required super.status,
    required super.parents,
    required super.dirs,
    required this.open,
  });

   GridBFSState.init(
    GridPoint start,
    GridPoint target,
    List<List<NodeState>> grid,
    bool allowDiagonals,
  ) : super.init(start, target, grid, allowDiagonals) {
    open = Queue<GridPoint>();
    open.add(start);
    start.set(grid, NodeState.open);
  }

  @override
   GridBFSState copy() {
    return  GridBFSState(
      start: start,
      target: target,
      grid: List.generate(grid.length, (i) => List.from(grid[i])),
      parents: HashMap.from(parents),
      dirs: List.from(dirs),
      open: Queue.from(open),
      status: status,
    );
  }
}