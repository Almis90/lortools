part of 'settings_bloc.dart';

@immutable
sealed class SettingsState {}

final class SettingsLoadingState extends SettingsState {}

final class SettingsLoadedState extends SettingsState {
  final List<String> sources;
  final String region;
  final String format;
  final String rank;
  final String timePeriod;

  SettingsLoadedState({
    required this.sources,
    required this.region,
    required this.format,
    required this.rank,
    required this.timePeriod,
  });
}

final class SettingsUpdatedState extends SettingsState {
  final String successMessage;

  SettingsUpdatedState(this.successMessage);
}

final class SettingsErrorState extends SettingsState {
  final String errorMessage;

  SettingsErrorState(this.errorMessage);
}
