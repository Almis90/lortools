part of 'decks_bloc.dart';

@immutable
sealed class DecksEvent {}

class DecksLoad extends DecksEvent {}

class DecksFilterByChampions extends DecksEvent {
  final List<String>? champions;

  DecksFilterByChampions(this.champions);
}

class DecksFilterByRegions extends DecksEvent {
  final List<String>? regions;

  DecksFilterByRegions(this.regions);
}
