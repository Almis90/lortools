part of 'decks_bloc.dart';

@immutable
sealed class DecksState {}

final class DecksInitial extends DecksState {}

final class DecksLoaded extends DecksState {
  final List<Deck> allDecks;
  final List<Deck> filteredDecks;

  DecksLoaded({
    required this.allDecks,
    required this.filteredDecks,
  });
}
