import 'dart:collection';

import '../status.dart';
import 'graph.dart';
import 'point.dart';
import 'node.dart';

abstract class GraphState {
  ID startId;
  ID targetId;
  HashMap<ID, HashSet<ID>> edges;
  HashMap<ID, (double, double)> coords;
  HashMap<ID, GraphNode> nodes;
  HashMap<ID, ID> parents;
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

  GraphPoint getPoint(ID id) {
    final point = coords[id];
    return GraphPoint(id, point!.$1, point.$2);
  }

  GraphNode getNode(ID id) {
    return nodes[id] ?? GraphNode.idle;
  }
}
