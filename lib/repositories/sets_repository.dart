import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lortools/models/set.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetsRepository {
  final Dio _dio = Dio();
  final String _url =
      'https://dd.b.pvp.net/latest/set{0}/en_us/data/set{0}-en_us.json';
  final List<String> _setVersions = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '6cde',
    '7',
    '7b',
    '8',
  ];

  Future<List<SetCard>> getAllCardsFromAllSet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<SetCard> cards = [];

    for (var i = 0; i < _setVersions.length; i++) {
      var setJson = await _loadSetFromCache(prefs, _setVersions[i]);

      if (setJson != null) {
        List<dynamic> jsonData = json.decode(setJson);

        cards.addAll(jsonData.map<SetCard>((jsonItem) {
          return SetCard.fromJson(jsonItem as Map<String, dynamic>);
        }));
      }
    }

    return cards;
  }

  Future<bool> fetchSets() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    for (var i = 0; i < _setVersions.length; i++) {
      var setJson = await _loadSetFromCache(prefs, _setVersions[i]);

      if (setJson == null) {
        var hasFetched = await _fetchAndCacheSet(prefs, _setVersions[i]);

        return hasFetched;
      }
    }

    return true;
  }

  Future<bool> _fetchAndCacheSet(
      SharedPreferences prefs, String version) async {
    try {
      _dio.options.headers['User-Agent'] =
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15';

      Response response = await _dio.get(_url.replaceAll('{0}', version));
      if (response.statusCode == 200) {
        String responseData = json.encode(response.data);
        _saveToCache(prefs, version, responseData);
        return true;
      } else {
        _logError('Failed to load decks: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _logError('Error occurred while fetching data: $e');
      return false;
    }
  }

  Future<String?> _loadSetFromCache(
      SharedPreferences prefs, String version) async {
    String? cachedData = prefs.getString('cached_set_$version');
    int? lastFetchTime = prefs.getInt('cached_set_fetch_time_$version');

    if (cachedData != null && lastFetchTime != null) {
      DateTime lastFetchDateTime =
          DateTime.fromMillisecondsSinceEpoch(lastFetchTime);
      if (DateTime.now().difference(lastFetchDateTime).inDays < 1) {
        return cachedData;
      }
    }
    return null;
  }

  Future<String?> fetchCard(String version, String cardCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var cachedDecks = await _getCards(prefs, version);

    var card =
        cachedDecks?.firstWhere((element) => element.cardCode == cardCode);

    if (card == null) {
      return null;
    }

    return card.name;
  }

  Future<List<SetCard>?> _getCards(
      SharedPreferences prefs, String version) async {
    String? cachedData = prefs.getString('cached_set_$version');
    int? lastFetchTime = prefs.getInt('cached_set_fetch_time_$version');

    if (cachedData != null && lastFetchTime != null) {
      DateTime lastFetchDateTime =
          DateTime.fromMillisecondsSinceEpoch(lastFetchTime);
      if (DateTime.now().difference(lastFetchDateTime).inHours < 1) {
        List<dynamic> jsonData = json.decode(cachedData);
        var cards = jsonData.map((data) => SetCard.fromJson(data)).toList();

        return cards;
      }
    }
    return null;
  }

  void _saveToCache(SharedPreferences prefs, String version, String data) {
    prefs.setString('cached_set_$version', data);
    prefs.setInt('cached_set_fetch_time_$version',
        DateTime.now().millisecondsSinceEpoch);
  }

  void _logError(String message) {
    if (kDebugMode) {
      print(message);
    }
  }
}
