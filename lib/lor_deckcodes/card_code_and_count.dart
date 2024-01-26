class CardCodeAndCount {
  String cardCode;
  int count;
  CardCodeAndCount(this.cardCode, this.count);

  @override
  String toString() {
    return "$cardCode:$count";
  }
}
