import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/models/lor_card.dart';

part 'predicted_cards_event.dart';
part 'predicted_cards_state.dart';

class PredictedCardsBloc
    extends Bloc<PredictedCardsEvent, PredictedCardsState> {
  PredictedCardsBloc() : super(PredictedCardsInitial()) {
    on<PredictedCardsUpdate>((event, emit) {});
  }
}
