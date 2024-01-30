part of 'cards_bloc.dart';

@immutable
sealed class CardsEvent {}

class CardsLoadFromAllSets extends CardsEvent {}

class CardsFilter extends CardsEvent {
  final List<String>? champions;
  final List<String>? regions;

  CardsFilter(this.champions, this.regions);
}

class FilterCardsByName extends CardsEvent {
  final String name;

  FilterCardsByName(this.name);
}
