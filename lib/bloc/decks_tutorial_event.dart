part of 'decks_tutorial_bloc.dart';

@immutable
sealed class DecksTutorialEvent {}

class DecksTutorialShowEvent extends DecksTutorialEvent {
  final bool force;

  DecksTutorialShowEvent({required this.force});
}

class DecksTutorialSkipEvent extends DecksTutorialEvent {}

class DecksTutorialNextEvent extends DecksTutorialEvent {}

class DecksTutorialFinishEvent extends DecksTutorialEvent {}

class DecksTutorialPreviousEvent extends DecksTutorialEvent {}
