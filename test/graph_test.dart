import 'dart:collection';

import 'package:gridfind/graph/graph.dart';
import 'package:test/test.dart';

void main() {
  final coords = HashMap<ID, (double, double)>.from({
    0: (0.0, 1.0),
    1: (1.0, 2.0),
    2: (1.0, 3.0),
    3: (-1.0, 1.0),
    4: (-2.0, 2.0),
    5: (-2.0, 3.0),
    6: (0.0, 4.0),
  });

  final edges = HashMap<ID, List<ID>>.from({
    0: [1, 2, 3],
    1: [0, 2, 4],
    2: [0, 1, 3, 5],
    3: [0, 2, 5],
    4: [1, 5],
    5: [2, 3, 4, 6],
    6: [3, 5],
  });

  group('BFS', () {
    test('solve', () {
      final startId = 0;
      final targetId = 6;
      var state = GraphBFSState.init(
        startId,
        targetId,
        HashMap.from(coords),
        HashMap.from(edges),
      );

      final path = GraphBFS().solve(state);

      expect(path, isNotNull);
      expect(path?.length, equals(4));
    });
  });

  group('Astar', () {
    test('solve', () {
      final startId = 0;
      final targetId = 6;
      var state = GraphAstarState.init(
        startId,
        targetId,
        HashMap.from(coords),
        HashMap.from(edges),
      );

      final path = GraphAstar().solve(state);

      expect(path, isNotNull);
      expect(path?.length, equals(4));
    });
  });

  group('Dijkstra', () {
    test('solve', () {
      final startId = 0;
      final targetId = 6;
      var state = GraphAstarState.init(
        startId,
        targetId,
        HashMap.from(coords),
        HashMap.from(edges),
      );

      final path = GraphAstar().solve(state);

      expect(path, isNotNull);
      expect(path?.length, equals(4));
    });
  });
}
