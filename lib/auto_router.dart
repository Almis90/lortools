import 'package:auto_route/auto_route.dart';
import 'package:lortools/auto_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoadingRoute.page, initial: true),
        AutoRoute(page: DecksRoute.page, initial: false),
      ];
}
