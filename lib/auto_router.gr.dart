// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:lortools/pages/decks_page.dart' as _i1;
import 'package:lortools/pages/loading_page.dart' as _i2;

abstract class $AppRouter extends _i3.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    DecksRoute.name: (routeData) {
      return _i3.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.DecksPage(),
      );
    },
    LoadingRoute.name: (routeData) {
      return _i3.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.LoadingPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.DecksPage]
class DecksRoute extends _i3.PageRouteInfo<void> {
  const DecksRoute({List<_i3.PageRouteInfo>? children})
      : super(
          DecksRoute.name,
          initialChildren: children,
        );

  static const String name = 'DecksRoute';

  static const _i3.PageInfo<void> page = _i3.PageInfo<void>(name);
}

/// generated route for
/// [_i2.LoadingPage]
class LoadingRoute extends _i3.PageRouteInfo<void> {
  const LoadingRoute({List<_i3.PageRouteInfo>? children})
      : super(
          LoadingRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoadingRoute';

  static const _i3.PageInfo<void> page = _i3.PageInfo<void>(name);
}
