# Gridfind

[![Pub Version](https://img.shields.io/pub/v/gridfind.svg)](https://pub.dev/packages/gridfind)
[![Pub Points](https://img.shields.io/pub/points/gridfind)](https://pub.dev/packages/gridfind/score)
[![Pub Likes](https://img.shields.io/pub/likes/gridfind)](https://pub.dev/packages/gridfind/score)
[![Pub Popularity](https://img.shields.io/pub/popularity/gridfind)](https://pub.dev/packages/gridfind/score)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Provides path finding algorithms for 2D n*m grid.

There is currently only GridBFS algorithm.

## Features

- Breadth-First Search (BFS) algorithm for pathfinding
- Easy to use API
- Customizable grid size and nodes

## Examples

```dart
import 'package:gridfind/gridfind.dart';

void main() {
  final start = Point(0, 0);
  final target = Point(2, 3);
  const size = 5;
  final grid = List.generate(size, (_) => List.generate(size, (_) => Node.idle));

  var state =  GridBFSState.init(start, target, grid);
  final path = BFS().solve(state);

  print(path);
}
```


## Contributing

Contributing is not currently possible.

This will change in the future.

## License

This project is licensed under the MIT License.
