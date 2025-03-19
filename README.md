# Gridfind

[![Pub Version](https://img.shields.io/pub/v/gridfind.svg)](https://pub.dev/packages/gridfind)
[![Pub Points](https://img.shields.io/pub/points/gridfind)](https://pub.dev/packages/gridfind/score)
[![Pub Likes](https://img.shields.io/pub/likes/gridfind)](https://pub.dev/packages/gridfind/score)
[![Pub Popularity](https://img.shields.io/pub/popularity/gridfind)](https://pub.dev/packages/gridfind/score)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Gridfind is a Dart package that provides a collection of pathfinding algorithms for both 2D grids and graphs. It is designed to be easy to use.


## Features

### Grid-Based Pathfinding
- BFS
- DFS
- Dijkstra's Algorithm
- A* Algorithm
- Diagonal Movement Support: Option to allow diagonal movement in grid-based pathfinding.

### Graph-Based Pathfinding
- BFS
- Dijkstra's Algorithm
- A* Algorithm

## Examples

```dart
import 'package:gridfind/gridfind.dart';

void main() {
  final start = GridPoint(2, 3);
  final target = GridPoint(7, 6);
  const width = 10;
  const height = 18;
  final grid = List.generate(width, (_) => List.generate(height, (_) => GridNode.idle));
  var state =  GridAstarState.init(start, target, grid, false);
  final path = GridAstar().solve(state);

  print(path?.map((e) => e).join(' -> '));
}
```


## Contributing

Contributing is not currently possible.

This will change in the future.

## License

This project is licensed under the MIT License.
