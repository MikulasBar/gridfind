import 'package:gridfind/gridfind.dart';

abstract class GridStrategy<S extends GridState> {
  void searchStep(S state);

  /// Find the whole path to the target given a state.
  ///
  /// If path doesn't exists return `null`.
  List<GridPoint>? solve(S state) {
    while (state.status == Status.searching) {
      searchStep(state);
    }

    return switch (state.status) {
      Status.success => constructPath(state),
      Status.failure => null,
      _ => throw Exception("Unreachable branch"),
    };
  }

  /// Reconstructs path from state that is already searched.
  ///
  /// This function assumes that the searching algorithm already end up on target.
  ///
  /// If There is no valid path, it will throw error.
  List<GridPoint> constructPath(S state) {
    List<GridPoint> path = [];
    var current = state.target;

    while (current != state.start) {
      path.add(current);
      current = state.parents[current]!;
    }

    path.add(state.start);

    return path;
  }
}
