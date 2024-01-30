import 'package:lortools/models/champion.dart';
import 'package:lortools/models/lor_card.dart';

class Deck {
  final List<Champion> champions;
  final List<String> regions;
  final double winrate;
  final double playrate;
  final String deckCode;
  final List<LorCard> cards;
  final int totalMatches;
  final String source;

  Deck({
    required this.winrate,
    required this.playrate,
    required this.totalMatches,
    required this.deckCode,
    required this.source,
    required this.champions,
    required this.cards,
    required this.regions,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Deck &&
        other.deckCode == deckCode &&
        other.source == source;
  }

  @override
  int get hashCode => deckCode.hashCode ^ source.hashCode;
}
