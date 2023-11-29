import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';

import 'package:flutter/material.dart';

import 'board.dart';

class Piece extends SpriteComponent with DragCallbacks, ParentIsA<Board>{
  final double tileSize;

  Piece({super.position, super.sprite, required this.tileSize, super.anchor, super.size, super.priority});

  double py = 0.0;
  double px = 0.0;


  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if(isDragged) {
      add(
        OpacityEffect.to(
          0.7,
          EffectController(duration: 0.4),
        ),
      );
    } else {
      add(
        OpacityEffect.fadeIn(
          EffectController(duration: 0.75),
        ),
      );
    }
  }

  void removePiece() async {

    
    parent.remove(this);
  }


  @override
  void onDragStart(event) {
    try {
      super.onDragStart(event);
      debugPrint('Drag started $position');
      px = position.x;
      py = position.y;
      priority = 25;
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  @override
  void onDragUpdate(event) {
    super.onDragUpdate(event);
    try {
      position += event.delta;
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  @override
  void onDragEnd(event) {
    super.onDragEnd(event);
    try {
      int nearestRow = -1;
      int nearestCol = -1;
      double minDistance = double.infinity;
      final board = parent;
      debugPrint('ancestor $parent');
      for (int row = 0; row < board.rows; row++) {
        for (int col = 0; col < board.cols; col++) {
          Vector2 tilePosition = board.getTilePosition(row, col);
          double distance = (position - tilePosition).length;

          if (distance < minDistance) {
            minDistance = distance;
            nearestRow = row;
            nearestCol = col;
          }
        }
      }
      final targetPosition = board.getTilePosition(nearestRow, nearestCol);
      final targetX = (targetPosition.x + (board.boardSize.width / 5 - size.x) / 50);
      final targetY = (targetPosition.y + (board.boardSize.height / 5 - size.y) / 50);

      position = Vector2(targetX, targetY);

      final tile = parent.componentsAtPoint(position + size / 2).whereType<Piece>().toList();
      if (tile.isNotEmpty) {
        if (tile.length > 1) {
          position = Vector2(px, py);
        }
      }
      priority = 0;
      debugPrint('Drag ended');
    } catch(e) {
      debugPrint(e.toString());
    }

  }

  @override
  set debugMode(bool debugMode) {
    super.debugMode = false;
  }

}
