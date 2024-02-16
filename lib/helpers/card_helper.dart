class CardHelper {
  static String getImageUrlFromCode(String code) {
    return 'https://firebasestorage.googleapis.com/v0/b/lortools.appspot.com/o/champions%2F$code.png?alt=media';
  }

  static String getImageUrlFromCodeAndSet(
      {required String code, required String set, bool? full}) {
    var img =
        'https://dd.b.pvp.net/latest/${set.toLowerCase()}/en_us/img/cards/$code${(full ?? true ? '-full' : '')}.png';

    return img;
  }
}
