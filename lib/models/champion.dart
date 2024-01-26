class Champion {
  final String title;
  final String imageUrl;

  Champion({
    required this.title,
    required this.imageUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Champion &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode => title.hashCode ^ imageUrl.hashCode;
}
