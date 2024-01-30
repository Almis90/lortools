import 'package:darq/darq.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/bloc/decks_bloc.dart';
import 'package:lortools/models/card_deck.dart';
import 'package:lortools/models/lor_card.dart';

part 'predicted_cards_event.dart';
part 'predicted_cards_state.dart';

class PredictedCardsBloc
    extends Bloc<PredictedCardsEvent, PredictedCardsState> {
  PredictedCardsBloc(DecksBloc decksBloc) : super(PredictedCardsInitial()) {
    on<PredictedCardsClear>((event, emit) {
      emit(PredictedCardsUpdated(const []));
    });
    on<PredictedCardsUpdate>((event, emit) {
      var decks = decksBloc.filteredDecks;
      var cards = event.cards;
      var predictedDecks = decks.toList();

      for (var i = 0; i < decks.length; i++) {
        var deckCards = decks[i].cards;

        if (deckCards.isEmpty) {
          continue;
        }

        var hasCards = cards.every((opponentCard) => deckCards
            .any((deckCard) => opponentCard.cardCode == deckCard.cardCode));

        if (!hasCards) {
          predictedDecks.remove(decks[i]);
        }
      }

      var deckCards = predictedDecks.expand<CardDeck>(
          (deck) => deck.cards.map<CardDeck>((card) => CardDeck(
                card: card,
                deck: deck,
              )));

      var groupedByCardCode = deckCards
          .groupBy((carDeck) => carDeck.card.cardCode)
          .map((cardDeckGroup) {
        var card = cardDeckGroup.first.card;
        return PredictLorCard(card: card, percentages: [
          cardDeckGroup.count / predictedDecks.length * 100,
          cardDeckGroup.where((cardDeck) => cardDeck.card.count > 1).length /
              predictedDecks.length *
              100,
          cardDeckGroup.where((cardDeck) => cardDeck.card.count > 2).length /
              predictedDecks.length *
              100
        ]);
      }).toList();

      decksBloc.add(DecksPredicted(predictedDecks));
      emit(PredictedCardsUpdated(groupedByCardCode));
    });
    on<PredictedCardsLoad>((event, emit) {
      emit(PredictedCardsUpdated(event.cards
          .map((e) => PredictLorCard(
              card: e,
              percentages:
                  Iterable.generate(e.count).map((e) => 100.0).toList()))
          .toList()));
    });
  }
}
