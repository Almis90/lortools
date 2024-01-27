import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/repositories/decks_repository.dart';
import 'package:lortools/repositories/sets_repository.dart';

part 'assets_event.dart';
part 'assets_state.dart';

class AssetsBloc extends Bloc<AssetsEvent, AssetsState> {
  final SetsRepository setsRepository;
  final DecksRepository decksRepository;

  AssetsBloc(this.setsRepository, this.decksRepository)
      : super(AssetsInitial()) {
    on<AssetsEvent>((event, emit) async {
      var hasFetchedSets = await setsRepository.fetchSets();
      var hasFetchedDecks = await decksRepository.fetchDecks();

      if (hasFetchedSets && hasFetchedDecks) {
        emit(AssetsLoaded());
      }
    });
  }
}
