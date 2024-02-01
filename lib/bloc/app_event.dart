part of 'app_bloc.dart';

@immutable
sealed class AppEvent {}

class AppPackageInfoLoadEvent extends AppEvent {}
