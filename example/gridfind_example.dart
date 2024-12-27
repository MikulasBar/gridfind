import 'package:gridfind/gridfind.dart';

void main() {
  final start = Point(0, 0);
  final target = Point(2, 3);
  const size = 5;
  final grid = List.generate(size, (_) => List.generate(size, (_) => Node.idle));

  var state = BFSState.init(start, target, grid);
  final path = BFS().solve(state);

  print(path);
}
