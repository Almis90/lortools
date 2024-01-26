import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/models/decks.dart';
import 'package:lortools/repositories/decks_repository.dart';

part 'decks_event.dart';
part 'decks_state.dart';

class DecksBloc extends Bloc<DecksEvent, DecksState> {
  Decks? _lastFetchedDecks;

  DecksBloc(DecksRepository decksRepository) : super(DecksInitial()) {
    on<DecksLoad>((event, emit) async {
      var decks = await decksRepository.getDecks();

      if (decks == null) {
        return;
      }

      _lastFetchedDecks = decks;

      emit(DecksLoaded(decks, decks));
    });

    on<DecksFilter>((event, emit) async {
      var decks = _lastFetchedDecks?.clone();

      if (decks != null) {
        decks.stats?.seven?.europe?.removeWhere((element) {
          if (event.champions?.every((x) =>
                  element.assets?.champions?.map((e) => e[0]).contains(x) ??
                  false) ??
              false) {
            return false;
          }
          return true;
        });
        decks.stats?.seven?.europe?.removeWhere((element) {
          if (event.regions?.every((x) =>
                  element.assets?.champions
                      ?.map((e) => e[2])
                      .contains(x.toLowerCase()) ??
                  false) ??
              false) {
            return false;
          }
          return true;
        });

        emit(DecksLoaded(_lastFetchedDecks!, decks));
      }
    });
  }
}
