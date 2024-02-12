part of 'decks_tutorial_bloc.dart';

@immutable
sealed class DecksTutorialState {}

final class DecksTutorialInitialState extends DecksTutorialState {}

final class DecksTutorialFirstTimeState extends DecksTutorialState {}

final class DecksTutorialActiveState extends DecksTutorialState {}

final class DecksTutorialSkippedState extends DecksTutorialState {}

final class DecksTutorialFinishedState extends DecksTutorialState {}
