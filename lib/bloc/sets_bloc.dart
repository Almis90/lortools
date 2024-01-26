import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/models/lor_card.dart';
import 'package:lortools/repositories/sets_repository.dart';

part 'sets_event.dart';
part 'sets_state.dart';

class SetsBloc extends Bloc<SetsEvent, SetsState> {
  final SetsRepository setsRepository;

  SetsBloc(this.setsRepository) : super(SetsInitial()) {
    on<LoadAllCardsFromAllSets>((event, emit) async {
      var setCards = await setsRepository.getAllCardsFromAllSet();
      var cards = setCards
          .map((e) => LorCard(
                cardCode: e.cardCode ?? '',
                collectible: e.collectible ?? false,
                cost: e.cost ?? 0,
                name: e.name ?? '',
                deckSet: e.deckSet ?? '',
              ))
          .toList();

      emit(CardsLoaded(cards));
    });
  }
}
