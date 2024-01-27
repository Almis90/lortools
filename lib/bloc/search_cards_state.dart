part of 'search_cards_bloc.dart';

@immutable
sealed class SearchCardsState {
  final String name;

  const SearchCardsState(this.name);
}

final class SearchCardsInitial extends SearchCardsState {
  const SearchCardsInitial(super.name);
}

final class SearchCardsActive extends SearchCardsState {
  const SearchCardsActive(super.name);
}
