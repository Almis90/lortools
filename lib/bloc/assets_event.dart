part of 'assets_bloc.dart';

@immutable
sealed class AssetsEvent {}

class AssetsLoad extends AssetsEvent {}
