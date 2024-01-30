part of 'predicted_cards_bloc.dart';

@immutable
sealed class PredictedCardsState {}

final class PredictedCardsInitial extends PredictedCardsState {}

final class PredictedCardsUpdated extends PredictedCardsState {
  final List<PredictLorCard> cards;

  PredictedCardsUpdated(this.cards);
}
