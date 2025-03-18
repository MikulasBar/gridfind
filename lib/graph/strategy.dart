import 'package:gridfind/graph/point.dart';
import 'package:gridfind/status.dart';

import 'state.dart';

abstract class GraphStrategy<S extends GraphState> {
  void searchStep(S state);

  /// Find the whole path to the target given a state.
  ///
  /// If path doesn't exists return `null`.
  List<GraphPoint>? solve(S state) {
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
  List<GraphPoint> constructPath(S state) {
    List<GraphPoint> path = [];
    var current = state.target;

    while (current != state.start) {
      path.add(current);
      final parentId = state.parents[current.id]!;
      current = state.getPoint(parentId);
    }

    path.add(state.start);

    return path;
  }
}
