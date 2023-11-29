import 'dart:io';
import 'dart:math';



import 'dart:async' as da;
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:occupied/piece.dart';

import 'board.dart';

void main() {

  runApp(GameWidget(game: CheckersGame()));
}

class CheckersGame extends FlameGame {
  late Board board;
  List<Piece> pieces = [];

  @override
  Future<void> onLoad() async {
    double padding = kIsWeb ? 200.0 : 1;
    final tileSize = (size[0] - 2 * padding) / 5;
    final boardHeight = size[1] - 2 * padding;
    final boardWidth = size[0] - 2 * padding;

    await Flame.images.load(
      'tree.png',
    );
    board = Board(boardSize: Size(boardWidth, boardHeight), priority: 0,);



    final allPositions = List.generate(5, (row) {
      return List.generate(5, (col) {
        return board.getTilePosition(row, col);
      });
    }).expand((list) => list).toList();

    allPositions.shuffle();
    final randomNumberOfPieces = Random().nextInt(25) + 1;

    for (int i = 0; i < randomNumberOfPieces; i++) {
      final randomPosition = allPositions[i];

      pieces.add(
        Piece(
          tileSize: tileSize,
          sprite: tree(tileSize, tileSize),
          position: randomPosition,
        ),
      );
    }

    board.addAll(pieces);

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      double boardY = (size[1] - board.height) / 4;

      board.position = Vector2(0, boardY);
    }

    add(board);
    removePieces(boardWidth, boardHeight);
  }



  @override
  bool get debugMode => false;

  void removePieces(boardWidth, boardHeight) {
    Random random = Random();

    da.Timer.periodic(const Duration(seconds: 10), (timer) {
      if (pieces.isNotEmpty) {
        int randomIndex = random.nextInt(pieces.length);
        final piece = pieces[randomIndex];
        piece.removePiece();
        pieces.removeAt(randomIndex);
        if(pieces.isEmpty) {
          timer.cancel();
          add(TextComponent(
              text: 'Game Over',
              position: Vector2(boardWidth / 2 - 60, boardHeight / 2 - 60),
              textRenderer: TextPaint(
                  style: const TextStyle(
                      color: Colors.green, fontSize: 25, fontWeight: FontWeight.bold))));
        }
      }
    });
  }
}

Sprite tree(double width, double height) {
  double xOffset = -(width / 2) + 31;
  double yOffset = -(height / 2) + 31;

  return Sprite(
    Flame.images.fromCache(
      'tree.png',
    ),
    srcPosition: Vector2(xOffset, yOffset),
    srcSize: Vector2(width, height),
  );
}
