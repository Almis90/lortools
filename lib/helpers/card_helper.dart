class CardHelper {
  static String getImageUrlFromCode(String code) {
    return 'https://masteringruneterra.com/wp-content/plugins/deck-viewer/assets/images/champions/${code}.webp';
  }

  static String getImageUrlFromCodeAndSet(String code, String set, bool? full) {
    var img =
        'http://dd.b.pvp.net/latest/${set.toLowerCase()}/en_us/img/cards/$code${(full ?? true ? '-full' : '')}.png';

    return img;
  }
}
