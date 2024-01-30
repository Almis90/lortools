import 'package:darq/darq.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/bloc/decks_bloc.dart';
import 'package:lortools/models/lor_card.dart';

part 'predicted_cards_event.dart';
part 'predicted_cards_state.dart';

class PredictedCardsBloc
    extends Bloc<PredictedCardsEvent, PredictedCardsState> {
  PredictedCardsBloc(DecksBloc decksBloc) : super(PredictedCardsInitial()) {
    on<PredictedCardsUpdate>((event, emit) {
      var decks = decksBloc.filteredDecks;
      var cards = event.cards;
      var predictedCards = cards
          .map((e) => PredictLorCard(card: e, percentages: [0, 0, 0]))
          .toList();
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

      var deckCards = predictedDecks.expand((deck) => deck.cards.map((card) => {
            'card': card,
            'deck': deck,
          }));

      var groupedByCardCode = deckCards
          .groupBy((element) => (element['card'] as LorCard).cardCode)
          .map((e) =>
              PredictLorCard(card: e.first['card'] as LorCard, percentages: [
                e.count / predictedDecks.length * 100,
                (e.count - 1) / predictedDecks.length * 100,
                (e.count - 2) / predictedDecks.length * 100
              ]))
          .toList();

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
