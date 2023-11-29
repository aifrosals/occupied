import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame_rive/flame_rive.dart';

import 'package:flutter/material.dart';

import 'board.dart';

class Piece extends RiveComponent with DragCallbacks, ParentIsA<Board>{
  final double tileSize;

  Piece({super.position, required this.tileSize, super.anchor, super.size, super.priority, required super.artboard});

  double py = 0.0;
  double px = 0.0;
  SMIBool? smiBool;
  SMITrigger? smiTrigger;

  @override
  Future<void> onLoad() async {
    // final skillsArtboard =
    // await loadArtboard(RiveFile.asset('birb.riv'));

    final controller = StateMachineController.fromArtboard(
      artboard,
      "birb",
    );

    smiBool = controller!.findSMI('dance');
    smiTrigger = controller!.findSMI('look up');

    artboard.addController(controller!);

    //
    // add(RiveComponent(artboard: skillsArtboard, position: Vector2(-(width / 2) + 31, -(width / 2) + 31), size: Vector2(tileSize,tileSize)));
  }


  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if(isDragged) {
      // add(
      //   OpacityEffect.to(
      //     0.7,
      //     EffectController(duration: 0.4),
      //   ),
      // );
    } else {
      // add(
      //   OpacityEffect.fadeIn(
      //     EffectController(duration: 0.75),
      //   ),
      // );
    }
  }

  void removePiece() async {

    
    parent.remove(this);
  }


  @override
  void onDragStart(event) async {
    try {
      super.onDragStart(event);
      debugPrint('Drag started $position');
      px = position.x;
      py = position.y;
      priority = 25;

      smiTrigger?.fire();
      await Future.delayed(const Duration(milliseconds: 500));
      smiBool?.value = true;
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
      smiBool?.value = false;
      debugPrint('Drag ended');
    } catch(e) {
      debugPrint(e.toString());
    }

  }

  // @override
  // set debugMode(bool debugMode) {
  //   super.debugMode = false;
  // }

}
