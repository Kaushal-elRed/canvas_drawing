import 'dart:convert';

import 'package:flutter/material.dart';

class DrawPoint {
  List<Offset> points;
  Color color;
  double size;
  int id;
  DrawPoint({
    required this.points,
    this.color = Colors.black,
    this.size = 12,
    required this.id,
  });

  DrawPoint copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
    int? id,
  }) {
    return DrawPoint(
      points: points ?? this.points,
      color: color ?? this.color,
      size: size ?? this.size,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({
      'points': points.map((x) => {'dx': x.dx, 'dy': x.dy}).toList()
    });
    result.addAll({'color': color.value});
    result.addAll({'size': size});
    result.addAll({'id': id});

    return result;
  }

  factory DrawPoint.fromMap(Map<String, dynamic> map) {
    return DrawPoint(
      points: List<Offset>.from(
          map['points']?.map((x) => Offset(x['dx'], x['dy']))),
      color: Color(map['color']),
      size: map['size']?.toDouble() ?? 0.0,
      id: map['id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DrawPoint.fromJson(String source) =>
      DrawPoint.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DrawPoint(points: $points, color: $color, size: $size, id: $id)';
  }
}

// {'dx': x.dx, 'dy': x.dy}

// Offset(x['dx'], x['dy'])