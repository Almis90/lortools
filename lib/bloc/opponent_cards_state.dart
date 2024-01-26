part of 'opponent_cards_bloc.dart';

@immutable
sealed class OpponentCardsState {}

final class OpponentCardsInitial extends OpponentCardsState {}

final class OpponentCardsUpdated extends OpponentCardsState {
  final List<LorCard> cards;

  OpponentCardsUpdated(this.cards);
}
