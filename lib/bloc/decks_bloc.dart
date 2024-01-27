import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/bloc/sets_bloc.dart';
import 'package:lortools/helpers/card_helper.dart';
import 'package:lortools/lor_deckcodes/deck_encoder.dart';
import 'package:lortools/models/champion.dart';
import 'package:lortools/models/deck.dart';
import 'package:lortools/models/lor_card.dart';
import 'package:lortools/repositories/decks_repository.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

part 'decks_event.dart';
part 'decks_state.dart';

class DecksBloc extends Bloc<DecksEvent, DecksState> {
  final DeckEncoder deckEncoder = DeckEncoder();
  List<Deck> allDecks = [];
  List<Deck> filteredDecks = [];
  List<String> champions = [];
  List<String> regions = [];

  DecksBloc(DecksRepository decksRepository, SetsBloc setsBloc)
      : super(DecksInitial()) {
    on<DecksLoad>((event, emit) async {
      var decks = await decksRepository.getDecks();

      if (decks == null) {
        return;
      }

      decks.stats?.seven?.europe?.expand<Deck>((deckStatsServer) {
        var decksInfo = deckStatsServer.bestDecks?.split('/');
        return decksInfo?.map((deckInfo) {
              var deckStats = deckInfo.split(',');
              return Deck(
                  champions: deckStatsServer.assets?.champions
                      ?.map(_listStringToChampion)
                      .toList(),
                  regions: deckStatsServer.assets?.regions,
                  cards: deckEncoder.getDeckFromCode(deckStats[0]).map((e) {
                    var cardInfo = setsBloc.allCards.firstWhereOrNull(
                        (element) => element.cardCode == e.cardCode);

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
                    );
                  }).toList(),
                  winrate: double.parse(deckStats[2]),
                  playrate: double.parse(deckStats[3]),
                  totalMatches: int.parse(deckStats[1]),
                  deckCode: deckStats[0],
                  source: 'MasteringRuneterra');
            }) ??
            [];
      }).forEach((deck) {
        allDecks.add(deck);
      });
      filteredDecks = allDecks.toList();

      emit(DecksLoaded(
        allDecks: allDecks,
        filteredDecks: filteredDecks,
      ));
    });

    on<DecksFilterByChampions>((event, emit) async {
      champions = event.champions ?? [];

      filteredDecks = regions.isEmpty
          ? allDecks
          : allDecks
              .where((deck) =>
                  deck.regions?.any((region) => regions.contains(region)) ??
                  false)
              .toList();
      filteredDecks = filteredDecks
          .where((deck) => champions.every((champion) =>
              deck.champions?.any((card) => card.cardCode == champion) ??
              false))
          .toList();

      emit(DecksLoaded(
        allDecks: allDecks,
        filteredDecks: filteredDecks,
      ));
    });

    on<DecksFilterByRegions>((event, emit) async {
      regions = event.regions ?? [];

      filteredDecks = allDecks
          .where((deck) =>
              deck.regions?.any((region) => regions.contains(region)) ?? false)
          .toList();
      filteredDecks = filteredDecks
          .where((deck) =>
              deck.champions
                  ?.any((champion) => champions.contains(champion.cardCode)) ??
              false)
          .toList();

      emit(DecksLoaded(
        allDecks: allDecks,
        filteredDecks: filteredDecks,
      ));
    });
  }

  Champion _listStringToChampion(List<String> championInfo) {
    return Champion(
      name: championInfo[0],
      cardCode: championInfo[1],
      imageUrl: CardHelper.getImageUrlFromCode(championInfo[1]),
    );
  }
}
