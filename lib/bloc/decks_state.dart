part of 'decks_bloc.dart';

@immutable
sealed class DecksState {}

final class DecksInitial extends DecksState {}

final class DecksLoaded extends DecksState {
  final Decks decks;
  final Decks filteredDecks;

  DecksLoaded(this.decks, this.filteredDecks);
}
