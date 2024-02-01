part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}

class LoadSettingsEvent extends SettingsEvent {}

class UpdateSourcesEvent extends SettingsEvent {
  final List<String> sources;

  UpdateSourcesEvent(this.sources);
}

class UpdateRegionEvent extends SettingsEvent {
  final String region;

  UpdateRegionEvent(this.region);
}

class UpdateFormatEvent extends SettingsEvent {
  final String format;

  UpdateFormatEvent(this.format);
}

class UpdateRankEvent extends SettingsEvent {
  final String ranks;

  UpdateRankEvent(this.ranks);
}

class UpdateTimePeriodEvent extends SettingsEvent {
  final String timePeriod;

  UpdateTimePeriodEvent(this.timePeriod);
}
