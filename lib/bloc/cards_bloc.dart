import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/models/lor_card.dart';
import 'package:lortools/repositories/sets_repository.dart';

part 'cards_event.dart';
part 'cards_state.dart';

class CardsBloc extends Bloc<CardsEvent, CardsState> {
  final SetsRepository setsRepository;
  List<LorCard> allCards = [];
  List<LorCard> filteredCards = [];
  String name = '';
  List<String> regions = [];

  CardsBloc(this.setsRepository) : super(CardsInitial()) {
    on<CardsLoadFromAllSets>(_onCardsLoadFromAllSets);
    on<CardsFilter>(_onCardsFilter);
    on<FilterCardsByName>(_onCardsFilterByName);
  }

  Future<void> _onCardsLoadFromAllSets(
    CardsLoadFromAllSets state,
    Emitter<CardsState> emit,
  ) async {
    var setCards = await setsRepository.getAllCardsFromAllSet();
    allCards = filteredCards = setCards
        .map(
          (e) => LorCard(
            cardCode: e.cardCode ?? 'unknown',
            collectible: e.collectible ?? false,
            cost: e.cost ?? -1,
            name: e.name ?? 'unknown',
            deckSet: e.deckSet ?? 'unknown',
            regions: e.regions ?? [],
            rarity: e.rarity ?? 'unknown',
          ),
        )
        .toList();

    emit(CardsLoaded(filteredCards: filteredCards, allCards: allCards));
  }

  void _onCardsFilter(CardsFilter event, Emitter<CardsState> emit) {
    regions = event.regions ?? [];

    filteredCards = filterCardsByName(allCards, name);
    filteredCards = filterCardsByRegion(filteredCards, regions);

    emit(CardsLoaded(filteredCards: filteredCards, allCards: allCards));
  }

  FutureOr<void> _onCardsFilterByName(
    FilterCardsByName event,
    Emitter emit,
  ) {
    name = event.name;

    filteredCards = filterCardsByName(allCards, name);
    filteredCards = filterCardsByRegion(filteredCards, regions);

    emit(CardsLoaded(filteredCards: filteredCards, allCards: allCards));
  }

  List<LorCard> filterCardsByName(List<LorCard> cards, String name) {
    return cards
        .where((element) =>
            element.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  List<LorCard> filterCardsByRegion(List<LorCard> cards, List<String> regions) {
    return regions.isEmpty
        ? cards
        : cards
            .where((e) => e.regions.any((element) => regions.contains(element)))
            .toList();
  }
}
