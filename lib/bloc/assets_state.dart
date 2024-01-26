part of 'assets_bloc.dart';

@immutable
sealed class AssetsState {}

final class AssetsInitial extends AssetsState {}

final class AssetsLoaded extends AssetsState {}
