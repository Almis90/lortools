class Champion {
  final String name;
  final String cardCode;
  final String imageUrl;

  Champion({
    required this.name,
    required this.cardCode,
    required this.imageUrl,
  });

  @override
  bool operator ==(Object other) =>
      other is Champion && cardCode == other.cardCode;

  @override
  int get hashCode => name.hashCode ^ imageUrl.hashCode;
}
