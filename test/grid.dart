import 'package:gridfind/grid/grid.dart';
import 'package:test/test.dart';

void main() {
  final start = GridPoint(2, 3);
  final target = GridPoint(7, 6);
  const width = 10;
  const height = 18;

  group('Astar', () {
    test('solve', () {
      final grid = createNewGrid(width, height);
      var state =  GridAstarState.init(start, target, grid, false);
      final path = GridAstar().solve(state);

      expect(path, isNotNull);
      expect(path?.length, equals(9));
    });

    test('solve with diagonal', () {
      final grid = createNewGrid(width, height);
      var state =  GridAstarState.init(start, target, grid, true);
      final path = GridAstar().solve(state);

      expect(path, isNotNull);
      expect(path?.length, equals(6));
    });
  });


  group('BFS', () {
    test('solve', () {
      final grid = createNewGrid(width, height);
      var state =  GridBFSState.init(start, target, List.from(grid), false);
      final path = GridBFS().solve(state);

      expect(path, isNotNull);
      expect(path?.length, equals(9));
    });

    test('solve with diagonal', () {
      final grid = createNewGrid(width, height);
      var state =  GridBFSState.init(start, target, List.from(grid), true);
      final path = GridBFS().solve(state);

      expect(path, isNotNull);
      expect(path?.length, equals(6));
    });
  });


  group('Dijkstra', () {
    test('solve', () {
      final grid = createNewGrid(width, height);
      var state =  GridDijkstraState.init(start, target, List.from(grid), false);
      final path = GridDijkstra().solve(state);

      expect(path, isNotNull);
      expect(path?.length, equals(9));
    });

    test('solve with diagonal', () {
      final grid = createNewGrid(width, height);
      var state =  GridDijkstraState.init(start, target, List.from(grid), true);
      final path = GridDijkstra().solve(state);

      expect(path, isNotNull);
      expect(path?.length, equals(6));
    });
  });
}

List<List<GridNode>> createNewGrid(int width, int height) {
  return List.generate(width, (_) => List.generate(height, (_) => GridNode.idle));
}