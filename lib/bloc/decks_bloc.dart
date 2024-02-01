import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/bloc/cards_bloc.dart';
import 'package:lortools/helpers/card_helper.dart';
import 'package:lortools/helpers/string_extensions.dart';
import 'package:lortools/lor_deckcodes/card_code_and_count.dart';
import 'package:lortools/lor_deckcodes/deck_encoder.dart';
import 'package:lortools/models/champion.dart';
import 'package:lortools/models/deck.dart';
import 'package:lortools/models/decks.dart';
import 'package:lortools/models/lor_card.dart';
import 'package:lortools/repositories/decks_repository.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

part 'decks_event.dart';
part 'decks_state.dart';

class DecksBloc extends Bloc<DecksEvent, DecksState> {
  final DeckEncoder deckEncoder = DeckEncoder();
  final DecksRepository decksRepository;
  final CardsBloc cardsBloc;
  List<Deck> allDecks = [];
  List<Deck> filteredDecks = [];
  List<String> champions = [];
  List<String> regions = [];

  DecksBloc(this.decksRepository, this.cardsBloc) : super(DecksInitial()) {
    on<DecksInitialize>(_onDecksInitialize);

    on<DecksLoad>(_onDecksLoad);

    on<DecksFilterByChampions>(_onDecksFilterByChampions);

    on<DecksFilterByRegions>(_onDecksFilterByRegions);
  }

  FutureOr<void> _onDecksInitialize(
    DecksInitialize event,
    Emitter<DecksState> emit,
  ) async {
    allDecks.clear();

    var decks = await decksRepository.getDecks();

    if (decks == null) {
      return;
    }

    decks.stats?.seven?.europe?.expand<Deck>((deckStatsServer) {
      var decksInfo = deckStatsServer.bestDecks?.split('/');
      return decksInfo?.map((deckInfo) {
            return deckStringToDeck(deckInfo, deckStatsServer, cardsBloc);
          }) ??
          [];
    }).forEach((deck) {
      allDecks.add(deck);
    });
    filteredDecks = allDecks.toList();
    filteredDecks.sort(_sortByWinrate);

    emit(DecksLoaded(
      allDecks: allDecks,
      filteredDecks: filteredDecks,
    ));
  }

  FutureOr<void> _onDecksLoad(
    DecksLoad event,
    Emitter<DecksState> emit,
  ) {
    filteredDecks = event.decks;
    emit(DecksLoaded(allDecks: allDecks, filteredDecks: filteredDecks));
  }

  FutureOr<void> _onDecksFilterByChampions(
    DecksFilterByChampions event,
    Emitter<DecksState> emit,
  ) {
    champions = event.champions ?? [];

    filteredDecks = _filterDecksByRegions();
    filteredDecks = _filterDecksByChampions();
    filteredDecks.sort(_sortByWinrate);

    emit(DecksLoaded(
      allDecks: allDecks,
      filteredDecks: filteredDecks,
    ));
  }

  FutureOr<void> _onDecksFilterByRegions(
    DecksFilterByRegions event,
    Emitter<DecksState> emit,
  ) {
    regions = event.regions ?? [];

    filteredDecks = _filterDecksByRegions();
    filteredDecks = _filterDecksByChampions();
    filteredDecks.sort(_sortByWinrate);

    emit(DecksLoaded(
      allDecks: allDecks,
      filteredDecks: filteredDecks,
    ));
  }

  Deck deckStringToDeck(
      String deckInfo, DeckStatsServer deckStatsServer, CardsBloc cardsBloc) {
    var deckStats = deckInfo.split(',');
    return Deck(
        champions: deckStatsServer.assets?.champions
                ?.map(_listStringToChampion)
                .toList() ??
            [],
        regions: deckStatsServer.assets?.champions
                ?.map(_listStringToRegions)
                .toList() ??
            [],
        cards: deckEncoder
            .getDeckFromCode(deckStats[0])
            .map(
              (e) => _cardCodeAndCountToCard(cardsBloc.allCards, e),
            )
            .toList(),
        winrate: double.parse(deckStats[2]),
        playrate: double.parse(deckStats[3]),
        totalMatches: int.parse(deckStats[1]),
        deckCode: deckStats[0],
        source: 'Mastering Runeterra');
  }

  LorCard _cardCodeAndCountToCard(List<LorCard> allCards, CardCodeAndCount e) {
    var cardInfo =
        allCards.firstWhereOrNull((lorCard) => lorCard.cardCode == e.cardCode);

    if (cardInfo == null) {
      return LorCard.unknown;
    }

    return LorCard(
      cardCode: e.cardCode,
      collectible: cardInfo.collectible,
      name: cardInfo.name,
      deckSet: cardInfo.deckSet,
      cost: cardInfo.cost,
      regions: cardInfo.regions,
      rarity: cardInfo.rarity,
      count: e.count,
    );
  }

  List<Deck> _filterDecksByChampions() {
    return filteredDecks
        .where((deck) => champions.every((champion) =>
            deck.champions.any((card) => card.cardCode == champion)))
        .toList();
  }

  List<Deck> _filterDecksByRegions() {
    return regions.isEmpty
        ? allDecks
        : allDecks
            .where((deck) =>
                regions.every((region) => deck.regions.contains(region)))
            .toList();
  }

  Champion _listStringToChampion(List<String> championInfo) {
    return Champion(
      name: championInfo[0],
      cardCode: championInfo[1],
      imageUrl: CardHelper.getImageUrlFromCode(championInfo[1]),
    );
  }

  String _listStringToRegions(List<String> championInfo) {
    var region = championInfo[2];

    if (region == "bandlecity") {
      return "Bandle City";
    } else if (region == "piltoverzaun") {
      return "Piltover & Zaun";
    } else if (region == "shadowisles") {
      return "Shadow Isles";
    } else {
      return region.toTitleCase();
    }
  }

  int _sortByWinrate(Deck a, Deck b) {
    return b.winrate.compareTo(a.winrate);
  }
}
