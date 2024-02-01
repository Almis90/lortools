import 'dart:async';
import 'package:darq/darq.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/bloc/decks_bloc.dart';
import 'package:lortools/models/card_deck.dart';
import 'package:lortools/models/deck.dart';
import 'package:lortools/models/lor_card.dart';

part 'predicted_cards_event.dart';
part 'predicted_cards_state.dart';

class PredictedCardsBloc
    extends Bloc<PredictedCardsEvent, PredictedCardsState> {
  final List<PredictLorCard> lorCards = [];
  final DecksBloc decksBloc;

  PredictedCardsBloc(this.decksBloc) : super(PredictedCardsInitial()) {
    on<PredictedCardsClear>(_onPredictedCardsClear);
    on<PredictedCardsUpdate>(_onPredictedCardsUpdate);
    on<PredictedCardsLoad>(_onPredictedCardsLoad);
  }

  FutureOr<void> _onPredictedCardsClear(
    PredictedCardsClear event,
    Emitter emit,
  ) {
    lorCards.clear();
    emit(PredictedCardsInitial());
  }

  FutureOr<void> _onPredictedCardsUpdate(
    PredictedCardsUpdate event,
    Emitter emit,
  ) {
    if (event.cards.isEmpty) {
      emit(PredictedCardsInitial());
      decksBloc.add(DecksInitialize());
    } else {
      var predictedDecks = _filterDecks(decksBloc.filteredDecks, event.cards);
      var deckCards = _transformDecksToCardDecks(predictedDecks);
      var groupedByCardCode =
          _groupByCardCode(deckCards, predictedDecks.length);

      decksBloc.add(DecksLoad(predictedDecks));
      emit(PredictedCardsUpdated(groupedByCardCode));
    }
  }

  List<Deck> _filterDecks(List<Deck> decks, List<LorCard> cards) {
    return decks.where(
      (deck) {
        var deckCards = deck.cards;
        return deckCards.isNotEmpty &&
            cards.every(
              (opponentCard) => deckCards.any(
                (deckCard) =>
                    opponentCard.cardCode == deckCard.cardCode &&
                    opponentCard.count <= deckCard.count,
              ),
            );
      },
    ).toList();
  }

  Iterable<CardDeck> _transformDecksToCardDecks(List<Deck> decks) {
    return decks.expand(
      (deck) => deck.cards.map(
        (card) => CardDeck(
          card: card,
          deck: deck,
        ),
      ),
    );
  }

  List<PredictLorCard> _groupByCardCode(
      Iterable<CardDeck> deckCards, int totalDecks) {
    return deckCards.groupBy((cardDeck) => cardDeck.card.cardCode).map(
      (cardDeckGroup) {
        var count = cardDeckGroup.length;
        var card = cardDeckGroup.first.card;

        return PredictLorCard(
          card: card,
          percentages: [
            count / totalDecks * 100,
            cardDeckGroup.where((cd) => cd.card.count > 1).length /
                totalDecks *
                100,
            cardDeckGroup.where((cd) => cd.card.count > 2).length /
                totalDecks *
                100,
          ],
        );
      },
    ).toList();
  }

  FutureOr<void> _onPredictedCardsLoad(
    PredictedCardsLoad event,
    Emitter emit,
  ) {
    var predictedCards = event.cards
        .map(
          (card) => PredictLorCard(
            card: card,
            percentages: List.filled(
              card.count,
              100.0,
            ),
          ),
        )
        .toList();

    emit(PredictedCardsUpdated(predictedCards));
  }
}
