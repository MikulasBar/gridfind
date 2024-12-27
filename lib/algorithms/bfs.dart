import 'dart:collection';

import 'package:gridfind/gridfind.dart';
// I need to make it my own because dart doesn't have it.
const _maxIntVal = 2 ^ 63 - 1;

class BFS extends PathFindingStrategy<BFSState> {
  @override
  void searchStep(BFSState state) {
    // If there is no open node, we are stuck.
    if (state.open.isEmpty) { 
      state.status = Status.failure;
      return;
    }

    Point point = state.findLowestCost();
    point.set(state.grid, Node.closed);
    state.open.remove(point);

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

      final newPosParent = newPos.get(state.parents);
      final parentCost = newPosParent?.get(state.cost);
      final pointCost = point.get(state.cost);
      // First check the node because when it's not open it will throw error due to the ! null check.
      if (newNode != Node.open || parentCost! > pointCost) {
        newPos.set(state.parents, point);

        int parentCost = point.get(state.cost);
        // Every values is derived from parent: parentCost + 1.
        // Start have 0.
        // This is the cost calculation of BFS.
        // Closer to start is better.
        newPos.set(state.cost, parentCost + 1); 

        newPos.set(state.grid, Node.open);
        state.open.add(newPos);
      }
    }
  }
}

class BFSState extends PathFindingState {
  List<List<int>> cost;

  BFSState({
    required super.open,
    required super.start,
    required super.target,
    required super.grid,
    required super.parents,
    required super.status,
    required this.cost,
  });

  static BFSState init(Point start, Point target, List<List<Node>> grid) {
    var state = BFSState(
      cost: List.generate(grid.length, (_) => List.generate(grid[0].length, (_) => _maxIntVal)),
      parents: List.generate(grid.length, (_) => List.generate(grid[0].length, (_) => null)),
      open: HashSet.from([start]),
      status: Status.search,
      start: start,
      target: target,
      grid: grid,
    );
      
    target.set(state.grid, Node.idle);
    start.set(state.cost, 0);
    start.set(state.grid, Node.open);

    return state;
  }

  Point findLowestCost() {
    final init = (_maxIntVal, Point(-1, -1));
    final (min, node) = open.fold(init, (acc, point) {
      final newCost = point.get(cost);
      if (acc.$1 > newCost) {
        return (newCost, point);
      }
      return acc;
    });

    return node;
  }

}
