import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<AppPackageInfoLoadEvent>((event, emit) async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      emit(AppPackageInfoLoadedState(
        appName: appName,
        packageName: packageName,
        version: version,
        buildNumber: buildNumber,
      ));
    });
  }
}
