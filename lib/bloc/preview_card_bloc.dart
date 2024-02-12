import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/models/lor_card.dart';

part 'preview_card_event.dart';
part 'preview_card_state.dart';

class PreviewCardBloc extends Bloc<PreviewCardEvent, PreviewCardState> {
  PreviewCardBloc() : super(PreviewCardInitialState()) {
    on<PreviewCardSelectEvent>(_onPreviewCardSelect);
    on<PreviewCardClearEvent>(_onPreviewCardClear);
  }

  FutureOr<void> _onPreviewCardSelect(
    PreviewCardSelectEvent event,
    Emitter<PreviewCardState> emit,
  ) {
    emit(PreviewCardSelectedState(card: event.card));
  }

  FutureOr<void> _onPreviewCardClear(
    PreviewCardClearEvent event,
    Emitter<PreviewCardState> emit,
  ) {
    emit(PreviewCardInitialState());
  }
}
