import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> setSources(List<String> sources) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setStringList('sources', sources);
  }

  Future<List<String>> getSources() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getStringList('sources') ?? ['Mastering Runeterra'];
  }

  Future<void> setRegion(String region) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('region', region);
  }

  Future<String> getRegion() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('region') ?? 'Everyone';
  }

  Future<void> setFormat(String format) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('format', format);
  }

  Future<String> getFormat() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('format') ?? 'Standard';
  }

  Future<void> setRank(String ranks) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('ranks', ranks);
  }

  Future<String> getRank() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('ranks') ?? 'All Ranks';
  }

  Future<void> setTimePeriod(String timePeriod) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('timePeriod', timePeriod);
  }

  Future<String> getTimePeriod() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('timePeriod') ?? 'Current Patch';
  }
}
