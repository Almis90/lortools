import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/repositories/decks_repository.dart';
import 'package:lortools/repositories/cards_repository.dart';

part 'assets_event.dart';
part 'assets_state.dart';

class AssetsBloc extends Bloc<AssetsEvent, AssetsState> {
  final CardsRepository cardsRepository;
  final DecksRepository decksRepository;

  AssetsBloc(this.cardsRepository, this.decksRepository)
      : super(AssetsInitial()) {
    on<AssetsEvent>((event, emit) async {
      var hasFetchedSets = await cardsRepository.fetchSets();
      var hasFetchedDecks = await decksRepository.fetchDecks();

      if (hasFetchedSets && hasFetchedDecks) {
        emit(AssetsLoaded());
      }
    });
  }
}
