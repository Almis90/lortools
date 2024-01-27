part of 'sets_bloc.dart';

@immutable
sealed class SetsState {}

final class SetsInitial extends SetsState {}

final class CardsLoaded extends SetsState {
  final List<LorCard> filteredCards;
  final List<LorCard> allCards;

  CardsLoaded({
    required this.filteredCards,
    required this.allCards,
  });
}
