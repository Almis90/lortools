part of 'app_bloc.dart';

@immutable
sealed class AppState {}

final class AppInitial extends AppState {}

final class AppPackageInfoLoadedState extends AppState {
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;

  AppPackageInfoLoadedState({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
  });
}
