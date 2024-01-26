part of 'sets_bloc.dart';

@immutable
sealed class SetsState {}

final class SetsInitial extends SetsState {}

final class CardsLoaded extends SetsState {
  final List<LorCard> cards;

  CardsLoaded(this.cards);
}
