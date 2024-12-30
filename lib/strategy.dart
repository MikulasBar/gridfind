import 'package:gridfind/gridfind.dart';


abstract class PathFindingStrategy<S extends PathFindingState> {
  void searchStep(S state);

  /// Find the whole path to the target given a state.
  /// 
  /// If path doesn't exists return `null`.
  List<Point>? solve(S state) {
    var status = state.status;
    while (status == Status.search) {
      // state.print(); // debug purposes only
      searchStep(state);
      status = state.status;
    }

    return switch (status) {
      Status.success => constructPath(state),
      Status.failure => null,
      _ => throw Exception("Unreachable branch"),
    };
  }

  /// Reconstructs path from state that is already searched.
  /// 
  /// This function assumes that the searching algorithm already end up on target.
  /// 
  /// If There is not valid path, it will throw error.
  List<Point> constructPath(S state) {
    List<Point> path = [];
    var current = state.target;

    while (current != state.start) {
      path.add(current);
      current = state.parents[current]!;
    }

    path.add(state.start);

    return path;
  }
}