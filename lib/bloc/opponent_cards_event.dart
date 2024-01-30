part of 'opponent_cards_bloc.dart';

@immutable
sealed class OpponentCardsEvent {}

class OpponentCardsClear extends OpponentCardsEvent {}

class OpponentCardsAdd extends OpponentCardsEvent {
  final LorCard card;

  OpponentCardsAdd(this.card);
}

class OpponentCardsRemove extends OpponentCardsEvent {
  final LorCard card;

  OpponentCardsRemove(this.card);
}
