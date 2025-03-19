import 'dart:collection';

import 'package:gridfind/graph/node.dart';
import 'package:gridfind/status.dart';

import '../graph.dart';
import '../strategy.dart';
import '../state.dart';

class GraphBFS extends GraphStrategy<GraphBFSState> {
  @override
  void searchStep(GraphBFSState state) {
    // If there is no open open node, we are stuck.
    if (state.open.isEmpty) {
      state.status = Status.failure;
      return;
    }

    ID pointId = state.open.removeFirst();
    state.nodes[pointId] = GraphNode.closed;

    // We can return because the target is reached.
    if (state.nodes[state.targetId] == GraphNode.closed) {
      state.status = Status.success;
      return;
    }

    for (ID newId in state.edges[pointId] ?? []) {
      GraphNode newNode = state.getNode(newId);
      if (newNode == GraphNode.closed) continue;

      if (newNode != GraphNode.open) {
        state.parents[newId] = pointId;
        state.open.add(newId);
        state.nodes[newId] = GraphNode.open;
      }
    }
  }
}

class GraphBFSState extends GraphState {
  late Queue<ID> open;

  GraphBFSState({
    required super.startId,
    required super.targetId,
    required super.status,
    required super.parents,
    required super.edges,
    required super.coords,
    required super.nodes,
    required this.open,
  });

  GraphBFSState.init(
    ID startId,
    ID targetId,
    HashMap<ID, (double, double)> coords,
    HashMap<ID, List<ID>> edges,
  ) : super.init(startId, targetId, coords, edges) {
    open = Queue<ID>();
    open.add(startId);
  }

  @override
  GraphBFSState copy() {
    return GraphBFSState(
      startId: startId,
      targetId: targetId,
      coords: HashMap.from(coords),
      edges: HashMap.from(edges),
      parents: HashMap.from(parents),
      nodes: HashMap.from(nodes),
      open: Queue.from(open),
      status: status,
    );
  }
}
