import 'dart:collection';
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

    // We can return because the target node is reached.
    if (state.target.get(state.grid) == Node.closed) {
      state.status = Status.success;
      return;
    }

    for (var (i, j) in state.dirs) {
      Point newPos = Point(point.x + i, point.y + j);
      if (state.isUntraversable(newPos)) continue;
      Node newNode = newPos.get(state.grid);
      if (newNode == Node.closed) continue;

      if (newNode != Node.open) {
        state.parents[newPos] = point;
        state.open.add(newPos);
        newPos.set(state.grid, Node.open);
      }
    }
  }
}

class BFSState extends PathFindingState {
  late Queue<Point> open;

  BFSState({
    required super.start,
    required super.target,
    required super.grid,
    required super.status,
    required super.parents,
    required super.dirs,
    required this.open,
  });

  BFSState.init(
    Point start,
    Point target,
    List<List<Node>> grid,
    bool allowDiagonals,
  ) : super(
          start: start,
          target: target,
          grid: grid,
          status: Status.search,
          parents: HashMap(),
          dirs: allowDiagonals ? dirs8 : dirs4,
        ) {
    open = Queue<Point>();
    open.add(start);
    start.set(grid, Node.open);
  }

  @override
  BFSState copy() {
    return BFSState(
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