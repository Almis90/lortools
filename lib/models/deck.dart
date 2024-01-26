import 'package:lortools/models/champion.dart';

class Deck {
  final List<Champion>? champions;
  final double winrate;
  final double playrate;
  final int totalMatches;

  Deck({
    required this.winrate,
    required this.playrate,
    required this.totalMatches,
    this.champions,
  });
}
