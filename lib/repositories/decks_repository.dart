import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lortools/models/decks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DecksRepository {
  final Dio _dio = Dio();
  final String _url =
      'https://masteringruneterra.com/wp-content/plugins/deck-viewer/resource/meta-data.json';
  final String _corsUrl =
      'https://corsproxy.io/?${'https://masteringruneterra.com/wp-content/plugins/deck-viewer/resource/meta-data.json'}';

  Future<bool> fetchDecks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var decksJson = await _loadDecksJsonFromCache(prefs);

    if (decksJson == null) {
      var hasFetched = await _fetchAndCacheDecks(prefs);

      return hasFetched;
    }

    return true;
  }

  Future<Decks?> getDecks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var decksJson = await _loadDecksJsonFromCache(prefs);

    if (decksJson == null) {
      return null;
    }

    var decks = Decks.fromJson(json.decode(decksJson));

    return decks;
  }

  Future<String?> _loadDecksJsonFromCache(SharedPreferences prefs) async {
    String? cachedData = prefs.getString('cachedDecks');
    int? lastFetchTime = prefs.getInt('lastFetchTime');

    if (cachedData != null && lastFetchTime != null) {
      DateTime lastFetchDateTime =
          DateTime.fromMillisecondsSinceEpoch(lastFetchTime);
      if (DateTime.now().difference(lastFetchDateTime).inHours < 1) {
        return cachedData;
      }
    }
    return null;
  }

  Future<bool> _fetchAndCacheDecks(SharedPreferences prefs) async {
    try {
      var url = kIsWeb ? _corsUrl : _url;
      Response response = await _dio.get(url);
      if (response.statusCode == 200) {
        String responseData = json.encode(response.data);
        _saveToCache(prefs, responseData);
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

  void _saveToCache(SharedPreferences prefs, String data) {
    prefs.setString('cachedDecks', data);
    prefs.setInt('lastFetchTime', DateTime.now().millisecondsSinceEpoch);
  }

  void _logError(String message) {
    if (kDebugMode) {
      print(message);
    }
  }
}
