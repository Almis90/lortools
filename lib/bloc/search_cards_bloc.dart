import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_cards_event.dart';
part 'search_cards_state.dart';

class SearchCardsBloc extends Bloc<SearchCardsEvent, SearchCardsState> {
  SearchCardsBloc() : super(const SearchCardsInitial('')) {
    on<SearchCardsToggle>((event, emit) {
      if (state is SearchCardsActive) {
        emit(SearchCardsInitial(event.name));
      } else {
        emit(SearchCardsActive(event.name));
      }
    });
  }
}
