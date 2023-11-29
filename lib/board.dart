

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'main.dart';

class Board extends PositionComponent {
  @override
  bool get debugMode => false;

  final Size boardSize;
  final int rows = 5;
  final int cols = 5;

  Board({required this.boardSize, super.priority, super.children, super.anchor, super.position});


  @override
  set debugMode(bool debugMode) {
    super.debugMode = false;
  }

  @override
  void render(Canvas c) {
    double tileSize = boardSize.width / cols;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        Color color = (row + col) % 2 == 0 ? Colors.white : Colors.black;
        Paint paint = Paint()..color = color;
        c.drawRect(Rect.fromLTWH(col * tileSize, row * tileSize, tileSize, tileSize), paint);
      }
    }


  }


  Vector2 getTilePosition(int row, int col) {
    double tileSize = boardSize.width / cols;
    double x = col * tileSize;
    double y = row * tileSize;
    return Vector2(x, y);
  }


  // @override
  // void onDragStart(DragStartEvent event) {
  //   super.onDragStart(event);
  //
  // }
  //
  // @override
  // void onDragUpdate(DragUpdateEvent event) {
  //
  // }
  //
  // @override
  // void onDragEnd(DragEndEvent event) {
  //   super.onDragEnd(event);
  //   debugPrint('drag ended on board');
  //
  // }
  //
  // @override
  // void onDragCancel(DragCancelEvent event) {
  //   super.onDragCancel(event);
  //
  // }
  //
  // @override
  // void update(double t) {
  //   // Update logic if needed
  // }



}




