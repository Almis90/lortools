import 'package:shared_preferences/shared_preferences.dart';

class DecksTutorialRepository {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<int> getStep() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt('decks_tutorial_step') ?? 0;
  }

  Future setStep(int step) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt('decks_tutorial_step', step);
  }

  Future<bool> getSkipped() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('decks_tutorial_skipped') ?? false;
  }

  Future setSkipped(bool hasSkipped) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('decks_tutorial_skipped', hasSkipped);
  }

  Future<bool> getFinished() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('decks_tutorial_finished') ?? false;
  }

  Future setFinished(bool hasFinished) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('decks_tutorial_finished', hasFinished);
  }
}
