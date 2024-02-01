import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/repositories/settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;
  final String unknownError =
      'Oops! Something went wrong. Please try again later. If the problem persists, contact support.';

  SettingsBloc({required this.settingsRepository})
      : super(SettingsLoadingState()) {
    on<LoadSettingsEvent>(_onLoadSettingsEvent);
    on<UpdateSourcesEvent>(_onUpdateSourcesEvent);
    on<UpdateRegionEvent>(_onUpdateRegionsEvent);
    on<UpdateFormatEvent>(_onUpdateFormatEvent);
    on<UpdateRankEvent>(_onUpdateRanksEvent);
    on<UpdateTimePeriodEvent>(_onUpdateTimePeriodEvent);
  }

  Future<FutureOr<void>> _onLoadSettingsEvent(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoadingState());

    var sources = await settingsRepository.getSources();
    var region = await settingsRepository.getRegion();
    var format = await settingsRepository.getFormat();
    var rank = await settingsRepository.getRank();
    var timePeriod = await settingsRepository.getTimePeriod();

    emit(SettingsLoadedState(
      sources: sources,
      region: region,
      format: format,
      rank: rank,
      timePeriod: timePeriod,
    ));
  }

  Future<void> _onUpdateSourcesEvent(
    UpdateSourcesEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      if (event.sources.isEmpty) {
        emit(SettingsErrorState(
            'Failed to update sources, at least one must be selected.'));
      } else {
        await settingsRepository.setSources(event.sources);
        emit(SettingsUpdatedState('Sources updated successfully'));
      }
    } catch (e) {
      emit(SettingsErrorState(unknownError));
    }
  }

  Future<void> _onUpdateRegionsEvent(
    UpdateRegionEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await settingsRepository.setRegion(event.region);
      emit(SettingsUpdatedState('Regions updated successfully'));
    } catch (e) {
      emit(SettingsErrorState(unknownError));
    }
  }

  Future<void> _onUpdateFormatEvent(
    UpdateFormatEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await settingsRepository.setFormat(event.format);
      emit(SettingsUpdatedState('Format updated successfully'));
    } catch (e) {
      emit(SettingsErrorState(unknownError));
    }
  }

  Future<void> _onUpdateRanksEvent(
    UpdateRankEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await settingsRepository.setRank(event.ranks);
      emit(SettingsUpdatedState('Ranks updated successfully'));
    } catch (e) {
      emit(SettingsErrorState(unknownError));
    }
  }

  Future<void> _onUpdateTimePeriodEvent(
    UpdateTimePeriodEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await settingsRepository.setTimePeriod(event.timePeriod);
      emit(SettingsUpdatedState('Time period updated successfully'));
    } catch (e) {
      emit(SettingsErrorState(unknownError));
    }
  }
}
