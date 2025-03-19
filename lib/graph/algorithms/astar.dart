import 'dart:collection';

import 'package:collection/collection.dart';

import '../graph.dart';

class GraphAstar extends GraphStrategy<GraphAstarState> {
  @override
  void searchStep(GraphAstarState state) {
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
      state.fCost[newId] = newGCost + newPoint.dist(state.target);

      if (newNode != GraphNode.open) {
        state.open.add(newId);
        state.nodes[newId] = GraphNode.open;
      }
    }
  }
}

class GraphAstarState extends GraphState {
  late PriorityQueue<ID> open;
  late HashMap<ID, double> fCost;
  late HashMap<ID, double> gCost;

  GraphAstarState({
    required super.startId,
    required super.targetId,
    required super.status,
    required super.parents,
    required super.edges,
    required super.coords,
    required super.nodes,
  });

  GraphAstarState.init(
    ID startId,
    ID targetId,
    HashMap<ID, (double, double)> coords,
    HashMap<ID, List<ID>> edges,
  ) : super.init(startId, targetId, coords, edges) {
    gCost = HashMap.from({startId: 0.0});
    fCost = HashMap.from({startId: start.dist(target)});
    open = PriorityQueue<ID>((a, b) => fCost[a]!.compareTo(fCost[b]!));
    open.add(startId);
    nodes[startId] = GraphNode.open;
  }

  @override
  GraphState copy() {
    return GraphAstarState(
      startId: startId,
      targetId: targetId,
      status: status,
      parents: HashMap.from(parents),
      edges: HashMap.from(edges),
      coords: HashMap.from(coords),
      nodes: HashMap.from(nodes),
    );
  }
}
