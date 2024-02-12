import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/repositories/decks_tutorial_repository.dart';

part 'decks_tutorial_event.dart';
part 'decks_tutorial_state.dart';

class DecksTutorialBloc extends Bloc<DecksTutorialEvent, DecksTutorialState> {
  final DecksTutorialRepository decksTutorialRepository;

  DecksTutorialBloc({required this.decksTutorialRepository})
      : super(DecksTutorialInitialState()) {
    on<DecksTutorialSkipEvent>(_onDecksTutorialSkipEvent);
    on<DecksTutorialFinishEvent>(_onDecksTutorialFinishEvent);
    on<DecksTutorialNextEvent>(_onDecksTutorialNextEvent);
    on<DecksTutorialPreviousEvent>(_onDecksTutorialPreviousEvent);
    on<DecksTutorialShowEvent>(_onDecksTutorialShowEvent);
  }

  FutureOr<void> _onDecksTutorialShowEvent(
    DecksTutorialShowEvent event,
    Emitter<DecksTutorialState> emit,
  ) async {
    var hasSkipped = await decksTutorialRepository.getSkipped();
    var hasFinished = await decksTutorialRepository.getFinished();

    if (event.force || (!hasSkipped && !hasFinished)) {
      if (hasSkipped || hasFinished) {
        decksTutorialRepository.setStep(0);
      }
      emit(DecksTutorialActiveState());
    }
  }

  FutureOr<void> _onDecksTutorialSkipEvent(
    event,
    Emitter<DecksTutorialState> emit,
  ) {
    decksTutorialRepository.setSkipped(true);
    decksTutorialRepository.setFinished(false);
    emit(DecksTutorialSkippedState());
  }

  FutureOr<void> _onDecksTutorialFinishEvent(
    DecksTutorialFinishEvent event,
    Emitter<DecksTutorialState> emit,
  ) {
    decksTutorialRepository.setSkipped(false);
    decksTutorialRepository.setFinished(true);
    emit(DecksTutorialFinishedState());
  }

  FutureOr<void> _onDecksTutorialNextEvent(
    DecksTutorialNextEvent event,
    Emitter<DecksTutorialState> emit,
  ) async {
    var step = await decksTutorialRepository.getStep();

    decksTutorialRepository.setSkipped(false);
    decksTutorialRepository.setStep(step + 1);
  }

  FutureOr<void> _onDecksTutorialPreviousEvent(
    DecksTutorialPreviousEvent event,
    Emitter<DecksTutorialState> emit,
  ) async {
    var step = await decksTutorialRepository.getStep();

    decksTutorialRepository.setSkipped(false);
    decksTutorialRepository.setStep(step - 1);
  }
}
