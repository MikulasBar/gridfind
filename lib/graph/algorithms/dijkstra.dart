import 'dart:collection';
import 'package:collection/collection.dart';

import '../graph.dart';

class GraphDijkstra extends GraphStrategy<GraphDijkstraState> {
  @override
  void searchStep(GraphDijkstraState state) {
    // If there is no open node, we are stuck.
    if (state.open.isEmpty) {
      state.status = Status.failure;
      return;
    }

    ID pointId = state.open.removeFirst();
    GraphPoint point = state.getPoint(pointId);
    state.nodes[pointId] = GraphNode.closed;

    // If the target node is reached, we are done.
    if (state.nodes[state.targetId] == GraphNode.closed) {
      state.status = Status.success;
      return;
    }

    for (ID newId in state.edges[pointId] ?? []) {
      GraphNode newNode = state.getNode(newId);
      if (newNode == GraphNode.closed) continue;

      GraphPoint newPoint = state.getPoint(newId);
      double distToPrevious = newPoint.dist(point);
      double newGCost = state.gCost[pointId]! + distToPrevious;

      if (newGCost >= (state.gCost[newId] ?? double.infinity)) continue;

      state.parents[newId] = pointId;
      state.gCost[newId] = newGCost;

      if (newNode != GraphNode.open) {
        state.open.add(newId);
        state.nodes[newId] = GraphNode.open;
      }
    }
  }
}

class GraphDijkstraState extends GraphState {
  late PriorityQueue<ID> open;
  late HashMap<ID, double> gCost;

  GraphDijkstraState({
    required super.startId,
    required super.targetId,
    required super.nodes,
    required super.edges,
    required super.parents,
    required super.coords,
    required super.status,
    required this.open,
    required this.gCost,
  });

  GraphDijkstraState.init(
    ID startId,
    ID targetId,
    HashMap<ID, (double, double)> coords,
    HashMap<ID, List<ID>> edges,
  ) : super.init(startId, targetId, coords, edges) {
    gCost = HashMap.from({startId: 0.0});
    open = PriorityQueue<ID>((a, b) => gCost[a]!.compareTo(gCost[b]!));
    open.add(startId);
    nodes[startId] = GraphNode.open;
  }

  @override
  GraphState copy() {
    GraphDijkstraState state = GraphDijkstraState(
      startId: startId,
      targetId: targetId,
      status: status,
      parents: HashMap.from(parents),
      edges: HashMap.from(edges),
      coords: HashMap.from(coords),
      nodes: HashMap.from(nodes),
      open: PriorityQueue((a, b) => gCost[a]!.compareTo(gCost[b]!)),
      gCost: HashMap.from(gCost),
    );

    state.open.addAll(open.toList());

    return state;
  }
}
