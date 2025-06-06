import 'dart:collection';
import 'package:collection/collection.dart';
import 'package:gridfind/gridfind.dart';

class GridBFS extends GridStrategy<GridBFSState> {
  @override
  void searchStep(GridBFSState state) {
    // If there is no open node, we are stuck.
    if (state.open.isEmpty) {
      state.status = Status.failure;
      return;
    }

    GridPoint point = state.open.removeFirst();
    point.set(state.grid, GridNode.closed);

    // We can return because the target node is reached.
    if (state.target.get(state.grid) == GridNode.closed) {
      state.status = Status.success;
      return;
    }

    for (var (i, j) in state.dirs) {
      GridPoint newPoint = GridPoint(point.x + i, point.y + j);
      if (state.isUntraversable(newPoint)) continue;
      GridNode newNode = newPoint.get(state.grid);
      if (newNode == GridNode.closed) continue;

      if (newNode != GridNode.open) {
        state.parents[newPoint] = point;
        state.open.add(newPoint);
        newPoint.set(state.grid, GridNode.open);
      }
    }
  }
}

class GridBFSState extends GridState {
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
    List<List<GridNode>> grid,
    bool allowDiagonals,
  ) : super.init(start, target, grid, allowDiagonals) {
    open = Queue<GridPoint>();
    open.add(start);
    start.set(grid, GridNode.open);
  }

  @override
  GridBFSState copy() {
    return GridBFSState(
      start: start,
      target: target,
      grid: List.generate(grid.length, (i) => List.from(grid[i])),
      parents: HashMap.from(parents),
      dirs: List.from(dirs),
      open: Queue.from(open),
      status: status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is GridBFSState) {
      final mapEquality = const MapEquality();

      return other.start == start &&
          other.target == target &&
          mapEquality.equals(other.parents, parents) &&
          other.status == status;
    }
    return false;
  }
}
