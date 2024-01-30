import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/models/lor_card.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

part 'opponent_cards_event.dart';
part 'opponent_cards_state.dart';

class OpponentCardsBloc extends Bloc<OpponentCardsEvent, OpponentCardsState> {
  final List<LorCard> cards = [];

  OpponentCardsBloc() : super(OpponentCardsInitial()) {
    on<OpponentCardsClear>(_onOpponentCardsClear);
    on<OpponentCardsAdd>(_onOpponentCardsAdd);
    on<OpponentCardsRemove>(_onOpponentCardsRemove);
  }

  FutureOr<void> _onOpponentCardsClear(event, emit) {
    cards.clear();
    emit(OpponentCardsUpdated(cards));
  }

  FutureOr<void> _onOpponentCardsAdd(event, emit) {
    if (cards.isNotEmpty) {
      var existingCard = cards.firstWhereOrNull(
          (element) => element.cardCode == event.card.cardCode);

      if (existingCard == null) {
        cards.add(event.card);
      } else {
        if (existingCard.count != 3) {
          existingCard.increaseCount();
        }
      }
    } else {
      cards.add(event.card);
    }
    emit(OpponentCardsUpdated(cards));
  }

  FutureOr<void> _onOpponentCardsRemove(event, emit) {
    if (state is OpponentCardsUpdated) {
      var cards = (state as OpponentCardsUpdated).cards;
      cards.remove(event.card);

      emit(OpponentCardsUpdated(cards));
    } else {
      emit(OpponentCardsUpdated(const []));
    }
  }
}
