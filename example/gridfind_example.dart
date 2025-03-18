import 'package:gridfind/gridfind.dart';

void main() {
  final start = GridPoint(2, 3);
  final target = GridPoint(7, 6);
  const width = 10;
  const height = 18;
  final grid = List.generate(width, (_) => List.generate(height, (_) => GridNode.idle));
  var state =  GridAstarState.init(start, target, grid, false);
  final path = GridAstar().solve(state);

  print(path);
}
