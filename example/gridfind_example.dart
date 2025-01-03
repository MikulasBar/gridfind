import 'package:gridfind/gridfind.dart';

void main() {
  final start = Point(2, 3);
  final target = Point(7, 6);
  const width = 10;
  const height = 18;
  final grid = List.generate(width, (_) => List.generate(height, (_) => Node.idle));
  var state = AstarState.init(start, target, grid, false);
  final path = Astar().solve(state);

  print(path);
}
