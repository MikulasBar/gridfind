


import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:gridfind/graph/graph.dart';
import 'package:gridfind/graph/state.dart';

class GraphDijkstraState extends GraphState {
  late PriorityQueue<ID> open;
  late HashMap<ID, double> gCost;
}