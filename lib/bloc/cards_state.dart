part of 'cards_bloc.dart';

@immutable
sealed class CardsState {}

final class CardsInitial extends CardsState {}

final class CardsLoaded extends CardsState {
  final List<LorCard> filteredCards;
  final List<LorCard> allCards;

  CardsLoaded({
    required this.filteredCards,
    required this.allCards,
  });
}
