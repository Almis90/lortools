part of 'predicted_cards_bloc.dart';

@immutable
sealed class PredictedCardsEvent {}

class PredictedCardsUpdate extends PredictedCardsEvent {
  final List<LorCard> cards;

  PredictedCardsUpdate(this.cards);
}

class PredictedCardsLoad extends PredictedCardsEvent {
  final List<LorCard> cards;

  PredictedCardsLoad(this.cards);
}
