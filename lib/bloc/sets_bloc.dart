import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/models/lor_card.dart';
import 'package:lortools/repositories/sets_repository.dart';

part 'sets_event.dart';
part 'sets_state.dart';

class SetsBloc extends Bloc<SetsEvent, SetsState> {
  final SetsRepository setsRepository;
  List<LorCard> cards = [];
  List<LorCard> filteredCards = [];

  SetsBloc(this.setsRepository) : super(SetsInitial()) {
    on<LoadAllCardsFromAllSets>((event, emit) async {
      var setCards = await setsRepository.getAllCardsFromAllSet();
      cards = filteredCards = setCards
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

      emit(CardsLoaded(filteredCards: filteredCards, allCards: cards));
    });
    on<CardsFilter>((event, emit) async {
      filteredCards = event.regions?.isEmpty ?? true
          ? cards
          : cards
              .where((e) => e.regions
                  .any((element) => event.regions?.contains(element) ?? true))
              .toList();

      emit(CardsLoaded(filteredCards: filteredCards, allCards: cards));
    });
  }
}
