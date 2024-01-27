part of 'search_cards_bloc.dart';

@immutable
sealed class SearchCardsEvent {}

class SearchCardsToggle extends SearchCardsEvent {
  final String name;

  SearchCardsToggle(this.name);
}
