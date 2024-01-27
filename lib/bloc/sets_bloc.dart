import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/models/lor_card.dart';
import 'package:lortools/repositories/sets_repository.dart';

part 'sets_event.dart';
part 'sets_state.dart';

class SetsBloc extends Bloc<SetsEvent, SetsState> {
  final SetsRepository setsRepository;
  List<LorCard> allCards = [];
  List<LorCard> filteredCards = [];
  String name = '';
  List<String> regions = [];

  SetsBloc(this.setsRepository) : super(SetsInitial()) {
    on<LoadAllCardsFromAllSets>((event, emit) async {
      var setCards = await setsRepository.getAllCardsFromAllSet();
      allCards = filteredCards = setCards
          .map(
            (e) => LorCard(
              cardCode: e.cardCode ?? '',
              collectible: e.collectible ?? false,
              cost: e.cost ?? 0,
              name: e.name ?? '',
              deckSet: e.deckSet ?? '',
              regions: e.regions ?? [],
              rarity: e.rarity ?? '',
            ),
          )
          .toList();

      emit(CardsLoaded(filteredCards: filteredCards, allCards: allCards));
    });
    on<CardsFilter>((event, emit) async {
      regions = event.regions ?? [];

      filteredCards = filterCardsByName(allCards, name);
      filteredCards = filterCardsByRegion(filteredCards, regions);

      emit(CardsLoaded(filteredCards: filteredCards, allCards: allCards));
    });
    on<FilterCardsByName>((event, emit) {
      name = event.name;

      filteredCards = filterCardsByName(allCards, name);
      filteredCards = filterCardsByRegion(filteredCards, regions);

      emit(CardsLoaded(filteredCards: filteredCards, allCards: allCards));
    });
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
