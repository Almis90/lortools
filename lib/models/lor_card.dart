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
  });

  void increaseCount() {
    count++;
  }
}
