import 'dart:math' as m;
import 'dart:ui';

import 'package:shax_caruur/game/game_controller_intf.dart';
import 'package:shax_caruur/models/player.dart';
import 'package:shax_caruur/models/position.dart';

class GameController implements IController {
  late double pieceRadius;
  late double jointsRadius;
  @override
  double get getPieceRadius => pieceRadius;
  @override
  double get getPositionRadius => jointsRadius;
  // this will be total size of screen;
  late Size totalSize;
  //margin and some space that i needed while making board square... if mobile this from top is half of what remained from *boardSize*
  late double margin;
  late double _fromTop;
  late double _fromLeft;
  // this is boardSize;
  late Size _size;
  Piece? _theOneWefound; // for what was selected when drag starts;
  //this set contains positions those player can habit
  final Set<Position> _positions = {};
  //this are plebbles that player will play
  final Set<Piece> _pieces = {};
  @override
  set setTheOneWeFound(Piece piece) {
    _theOneWefound = piece;
  }

  @override
  Piece? get getTheOneWefound => _theOneWefound;

  @override
  Size get boardSize => _size;

  @override
  double get fromTop => _fromTop;

  @override
  double get fromleft => _fromLeft;

  //when game starts based on screen size it keeps size;
  @override
  void setSize(Size size) {
    totalSize = size;
    margin = totalSize.width * 0.05;
  }

  @override
  Set<Position> get getPositions => _positions;
  @override
  Set<Piece> get getPieces => _pieces;
  //this method calculates then stores positions and pieces .... those numbers are made on try and error but they are
  /// solid ffor every screen;
  @override
  void fillPositionsAndPieces() {
    pieceRadius = totalSize.width / 15;
    List<Piece> pieces = [
      Piece(
        id: 100,
        pieceRadius: pieceRadius,
        coordinate: Offset(
          totalSize.width / 2 - 2 * pieceRadius,
          totalSize.height / 7,
        ),
        player: Player.red,
      ),
      Piece(
        pieceRadius: pieceRadius,
        id: 101,
        coordinate: Offset(totalSize.width / 2, totalSize.height / 7),
        player: Player.red,
      ),
      Piece(
        pieceRadius: pieceRadius,
        id: 102,
        coordinate: Offset(
          totalSize.width / 2 + 2 * pieceRadius,
          totalSize.height / 7,
        ),
        player: Player.red,
      ), // this three for rock
      Piece(
        pieceRadius: pieceRadius,
        id: 103,
        coordinate: Offset(
          totalSize.width / 2 - 2 * pieceRadius,
          totalSize.height - totalSize.height / 10,
        ),
        player: Player.green,
      ),
      Piece(
        pieceRadius: pieceRadius,
        id: 104,
        coordinate: Offset(
          totalSize.width / 2,
          totalSize.height - totalSize.height / 10,
        ),
        player: Player.green,
      ),
      Piece(
        pieceRadius: pieceRadius,
        id: 105,
        coordinate: Offset(
          totalSize.width / 2 + 2 * pieceRadius,
          totalSize.height - totalSize.height / 10,
        ),
        player: Player.green,
      ), // this three for rock
    ];
    _pieces.clear();
    _pieces.addAll(pieces);
    //REGISTER JOINTS DEPEND ON SCREEN
    _fromTop = margin;
    _fromLeft = margin;
    final minside = m.min(totalSize.width, totalSize.height);
    final double boardSide = (minside - 2 * margin);
    final maxside = m.max(totalSize.width, totalSize.height);
    final diff = maxside - boardSide;
    final half = diff / 2;
    if (totalSize.width < totalSize.height) _fromTop += half;
    if (totalSize.width > totalSize.height) _fromLeft += half;
    _size = Size.square(boardSide); //size of board
    jointsRadius = _size.width / 30;
    final Offset center = Offset(_size.width / 2, _size.height / 2);

    List<Position> actualPositions = [
      Position(
        coordinate: Offset(0 + _fromLeft, 0 + _fromTop),
        positionId: 1,
        legalMovesFromHere: [2, 5, 4],
        radius: jointsRadius,
      ),
      Position(
        radius: jointsRadius,
        coordinate: Offset(center.dx + _fromLeft, 0 + _fromTop),
        positionId: 2,
        legalMovesFromHere: [1, 5, 3],
      ),
      Position(
        radius: jointsRadius,
        coordinate: Offset(_size.width + _fromLeft, 0 + _fromTop),
        positionId: 3,
        legalMovesFromHere: [2, 5, 6],
      ),

      Position(
        radius: jointsRadius,
        coordinate: Offset(0 + _fromLeft, center.dy + _fromTop),
        positionId: 4,
        legalMovesFromHere: [1, 5, 7],
      ),
      Position(
        coordinate: Offset(center.dx + _fromLeft, center.dy + _fromTop),
        radius: jointsRadius,
        positionId: 5,
        legalMovesFromHere: [1, 2, 3, 4, 6, 7, 8, 9],
      ),
      Position(
        radius: jointsRadius,
        coordinate: Offset(_size.width + _fromLeft, center.dy + _fromTop),
        positionId: 6,
        legalMovesFromHere: [3, 5, 9],
      ),
      Position(
        radius: jointsRadius,
        coordinate: Offset(0 + _fromLeft, _size.height + _fromTop),
        positionId: 7,
        legalMovesFromHere: [8, 5, 4],
      ),
      Position(
        radius: jointsRadius,
        coordinate: Offset(center.dx + _fromLeft, _size.height + _fromTop),
        positionId: 8,
        legalMovesFromHere: [7, 5, 9],
      ),
      Position(
        radius: jointsRadius,
        coordinate: Offset(_size.width + _fromLeft, _size.height + fromTop),
        positionId: 9,
        legalMovesFromHere: [8, 5, 6],
      ),
    ];
    _positions.clear();
    _positions.addAll(actualPositions);
  }

  //this method checks if current player can win
  @override
  Set<Position>? canHeWin({required Player currentPlayer}) {
    final Set<Piece> piecesPlayed = _piecesPlayed();
    final Set<Piece> currentPlayersplayedPieces = piecesPlayed
        .where((p) => p.player == currentPlayer)
        .toSet();
    if (currentPlayersplayedPieces.length < 3) return null;
    List<int> firstRow = [1, 2, 3];
    List<int> secondRow = [4, 5, 6];
    List<int> thirdRow = [7, 8, 9];
    List<int> firstColunn = [1, 4, 7];
    List<int> secondColumn = [2, 5, 8];
    List<int> thirdColumn = [3, 6, 9];
    List<int> primaryDiagnal = [1, 5, 9];
    List<int> secondaryDiagnal = [3, 5, 7];
    List<List<int>> winableLines = [
      firstRow,
      secondRow,
      thirdRow,
      firstColunn,
      secondColumn,
      thirdColumn,
      primaryDiagnal,
      secondaryDiagnal,
    ];
    for (List<int> winableLine in winableLines) {
      final bool heWonWithThisLine = currentPlayersplayedPieces.every(
        (p) => winableLine.contains(p.positionId),
      );
      if (heWonWithThisLine) {
        return _positions
            .where((p) => winableLine.contains(p.positionId))
            .toSet();
      }
    }

    return null;
  }

  @override
  void hitPiece({
    required Offset whereYouTapped,
    required Player currentPlayer,
  }) {
    final Set<Piece> pocket = _pieces
        .where((e) => e.player == currentPlayer)
        .toSet();
    for (Piece piece in pocket) {
      final Offset diff = whereYouTapped - piece.coordinate;
      final distance = diff.distance;
      if (distance <= pieceRadius * 1.5) {
        if (piece.positionId == null) {
          //if piece is not played yet, do it
          _theOneWefound = piece;
          return;
        } else {
          //if piece was played before
          final bool isAllPutOnBoard =
              _allpiecesPut(); //check if all others are played as well
          if (isAllPutOnBoard) {
            //if all other were played on, then move it on board
            _theOneWefound = piece;
            return;
          } else {
            _theOneWefound = null;
          }
        }
      }
    }
  }

  @override
  bool putPieceOnPosition({required Offset whereDragEnds}) {
    for (Position position in _positions) {
      final Offset diff = whereDragEnds - position.coordinate;
      final double distance = diff.distance;
      if (distance <= (pieceRadius * 2 + jointsRadius * 2)) {
        final bool occupied = _thisPositionIsOccupied(position.positionId);
        if (!occupied) {
          if (_theOneWefound!.positionId == null) {
            _theOneWefound = _theOneWefound!.copyWith(
              newcoordinate: position.coordinate,
              posId: position.positionId,
            );
            _pieces.removeWhere((e) => e.id == _theOneWefound!.id);
            _pieces.add(_theOneWefound!);
            _theOneWefound = null;
            return true;
          } else {
            //this position can go only legal ones
            if (_isLegal(_theOneWefound!.positionId!, position)) {
              _theOneWefound = _theOneWefound!.copyWith(
                newcoordinate: position.coordinate,
                posId: position.positionId,
              );
              _pieces.removeWhere((e) => e.id == _theOneWefound!.id);
              _pieces.add(_theOneWefound!);
              _theOneWefound = null;
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  bool _thisPositionIsOccupied(int posId) {
    for (Piece p in _pieces) {
      if (p.positionId != null) {
        if (p.positionId == posId) {
          return true;
        }
      }
    }
    return false;
  }

  bool _allpiecesPut() {
    return _pieces.every((piece) => piece.positionId != null);
  }

  Set<Piece> _piecesPlayed() {
    return _pieces.where((e) => e.positionId != null).toSet();
  }

  bool _isLegal(int positionId, Position nwPosition) {
    final Position whereItISAt = _positions.firstWhere(
      (p) => p.positionId == positionId,
    );
    return whereItISAt.legalMovesFromHere.contains(nwPosition.positionId);
  }

  @override
  void dispose() {
    _theOneWefound = null;
    _positions.clear();
    _pieces.clear();
  }

  @override
  void restart() {
    _theOneWefound = null;
    _positions.clear();
    _pieces.clear();
    fillPositionsAndPieces();
  }
}
