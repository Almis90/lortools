import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/models/lor_card.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

part 'opponent_cards_event.dart';
part 'opponent_cards_state.dart';

class OpponentCardsBloc extends Bloc<OpponentCardsEvent, OpponentCardsState> {
  OpponentCardsBloc() : super(OpponentCardsInitial()) {
    on<OpponentCardsAdd>((event, emit) {
      if (state is OpponentCardsUpdated) {
        var cards = (state as OpponentCardsUpdated).cards;

        var existingCard = cards.firstWhereOrNull(
            (element) => element.cardCode == event.card.cardCode);

        if (existingCard == null) {
          cards.add(event.card);
        } else {
          if (existingCard.count != 3) {
            existingCard.increaseCount();
          }
        }
        emit(OpponentCardsUpdated(cards));
      } else {
        emit(OpponentCardsUpdated([event.card]));
      }
    });
    on<OpponentCardsRemove>((event, emit) {
      if (state is OpponentCardsUpdated) {
        var cards = (state as OpponentCardsUpdated).cards;
        cards.remove(event.card);

        emit(OpponentCardsUpdated(cards));
      } else {
        emit(OpponentCardsUpdated(const []));
      }
    });
  }
}
