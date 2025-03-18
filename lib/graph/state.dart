import 'dart:collection';

import '../status.dart';
import 'point.dart';
import 'node.dart';

abstract class GraphState {
  int startId;
  int targetId;
  HashMap<int, HashSet<int>> edges;
  HashMap<int, (double, double)> coords;
  HashMap<int, GraphNode> nodes;
  HashMap<int, int> parents = HashMap<int, int>();
  Status status;

  GraphState({
    required this.edges,
    required this.coords,
    required this.nodes,
    required this.parents,
    required this.startId,
    required this.targetId,
    required this.status,
  });

  GraphState.init(
    this.startId,
    this.targetId,
    this.coords,
    this.edges,
  )   : parents = HashMap(),
        status = Status.searching,
        nodes = HashMap();

  GraphState copy();

  GraphPoint get start => getPoint(startId);
  GraphPoint get target => getPoint(targetId);

  GraphPoint getPoint(int id) {
    final point = coords[id];
    return GraphPoint(id, point!.$1, point.$2);
  }

  GraphNode getNode(int id) {
    return nodes[id] ?? GraphNode.idle;
  }
}
