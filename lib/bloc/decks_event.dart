part of 'decks_bloc.dart';

@immutable
sealed class DecksEvent {}

class DecksInitialize extends DecksEvent {}

class DecksFilterByChampions extends DecksEvent {
  final List<String>? champions;

  DecksFilterByChampions(this.champions);
}

class DecksFilterByRegions extends DecksEvent {
  final List<String>? regions;

  DecksFilterByRegions(this.regions);
}

class DecksLoad extends DecksEvent {
  final List<Deck> decks;

  DecksLoad(this.decks);
}
