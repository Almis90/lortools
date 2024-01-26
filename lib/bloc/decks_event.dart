part of 'decks_bloc.dart';

@immutable
sealed class DecksEvent {}

class DecksLoad extends DecksEvent {}

class DecksFilter extends DecksEvent {
  final List<String>? champions;
  final List<String>? regions;

  DecksFilter(this.champions, this.regions);
}
