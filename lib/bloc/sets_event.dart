part of 'sets_bloc.dart';

@immutable
sealed class SetsEvent {}

class LoadAllCardsFromAllSets extends SetsEvent {}

class CardsFilter extends SetsEvent {
  final List<String>? champions;
  final List<String>? regions;

  CardsFilter(this.champions, this.regions);
}

class FilterCardsByName extends SetsEvent {
  final String name;

  FilterCardsByName(this.name);
}
