class LorCard {
  final String cardCode;
  final bool collectible;
  final String name;
  final String deckSet;
  final int cost;
  final List<String> regions;
  final String rarity;
  int count = 0;

  LorCard({
    required this.cardCode,
    required this.collectible,
    required this.name,
    required this.deckSet,
    required this.cost,
    required this.regions,
    required this.rarity,
    this.count = 1,
  });

  void increaseCount() {
    count++;
  }

  static LorCard unknown = LorCard(
      cardCode: 'cardCode',
      collectible: false,
      name: 'Unknown',
      deckSet: 'Unknown',
      cost: -1,
      regions: [],
      rarity: 'Unknown');
}

class PredictLorCard {
  final LorCard card;
  final List<double> percentages;

  PredictLorCard({
    required this.card,
    required this.percentages,
  });
}
