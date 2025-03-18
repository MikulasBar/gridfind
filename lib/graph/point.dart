

import 'dart:math';

class GraphPoint {
  int id;
  double x;
  double y;

  GraphPoint(this.id, this.x, this.y);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is GraphPoint &&
      other.id == id &&
      other.x == x &&
      other.y == y;
  }

  @override
  int get hashCode => id.hashCode ^ x.hashCode ^ y.hashCode;

  GraphPoint copyWith({
    int? id,
    double? x,
    double? y,
  }) {
    return GraphPoint(
      id ?? this.id,
      x ?? this.x,
      y ?? this.y,
    );
  }

  double dist(GraphPoint other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }
}