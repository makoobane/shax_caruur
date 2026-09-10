import 'package:flutter/material.dart';
import 'package:shax_caruur/models/player.dart' show Player;
import 'package:shax_caruur/presentations/widgets/confetti.dart';
import 'package:shax_caruur/presentations/widgets/score_shower.dart';
import 'package:shax_caruur/presentations/widgets/shaxPiecesWidget.dart'
    show ShaxPiecesPaint;
import 'package:shax_caruur/state_management/home_cubit.dart';

import 'package:shax_caruur/state_management/home_states.dart';
import 'package:shax_caruur/utils.dart' as utils;

class Shaxboardwidget extends StatelessWidget {
  final HomeCubit homeCubit;
  final HomeStates state;
  final Size totalSize;
  const Shaxboardwidget({
    super.key,
    required this.totalSize,
    required this.homeCubit,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final double margin = totalSize.width * 0.05;

    return Stack(
      children: [
        //this one draw the grid of cross and diagnal with rectangle
        CustomPaint(
          painter: ShaxBoardPainter(homeCubit, state: state, margin: margin),
          size: totalSize,
        ),
        //this one paints pieces or plebbles
        ShaxPiecesPaint(
          state: state,
          totalSize: totalSize,
          margin: margin,
          homeCubit: homeCubit,
        ),
        //this one shows score
        ScoreShower(size: totalSize),
        //those two buttons show which player is active and crucial for restarting the game
        if (state.currentPlayer == Player.red)
          Positioned(
            top: totalSize.height / 9,
            right: 0,
            child: IconButton(
              onPressed: () {
                homeCubit.restart();
              },
              icon: const Icon(
                Icons.radio_button_checked,
                color: Colors.redAccent,
                size: 50,
              ),
            ),
          ),
        if (state.currentPlayer == Player.green)
          Positioned(
            top: totalSize.height - totalSize.height / 7.5,
            right: 0,
            child: IconButton(
              onPressed: () {
                homeCubit.restart();
              },
              icon: const Icon(
                Icons.radio_button_checked,
                color: Colors.green,
                size: 50,
              ),
            ),
          ),
        //if one player wins this one shows he won
        if (state.runtimeType == EndgameState)
          Positioned(
            left: totalSize.width / 2,
            top: totalSize.height / 2,
            child: ConfettiApp(),
          ),
      ],
    );
  }
}

class ShaxBoardPainter extends CustomPainter {
  final HomeCubit homeCubit;
  final HomeStates state;
  final double margin;
  const ShaxBoardPainter(
    this.homeCubit, {
    required this.state,
    required this.margin,
  });
  @override
  void paint(Canvas canvas, Size totalSize) {
    utils.drawShax(canvas, homeCubit: homeCubit, state: state);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
