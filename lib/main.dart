import 'package:flutter/material.dart';
import 'package:savvy_navigator/navigator/savvy_page_manager.dart';
import 'package:savvy_navigator/navigator/savvy_page_manager_provider.dart';
import 'package:savvy_navigator/screens/login_screen.dart';
import 'package:savvy_navigator/screens/post_login_screen.dart';
import 'package:savvy_navigator/navigator/savvy_delegate.dart';
import 'package:savvy_navigator/navigator/savvy_route.dart';
import 'package:savvy_navigator/navigator/savvy_route_information_parser.dart';

void main() {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  runApp(MyApp(
    navigatorKey: navigatorKey,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
    required this.navigatorKey,
  }) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;
  final savvyPageManager = SavvyPageManager(
    initialPagePath: '/',
    routes: [
      SavvyRoute(
        path: '/',
        buildPage: (pathArgs) {
          return LoginScreen.page();
        },
      ),
      SavvyRoute(
        path: '/post/:id',
        expectedPathParams: [':id'],
        buildPage: (pathArgs) {
          return PostLoginScreen.page(pathArgs[':id'] ?? '');
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SavvyPageManagerProvider(
      notifier: savvyPageManager,
      child: MainApp(
        navigatorKey: navigatorKey,
        savvyPageManager: savvyPageManager,
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({
    Key? key,
    required this.savvyPageManager,
    required this.navigatorKey,
  }) : super(key: key);

  final SavvyPageManager savvyPageManager;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: SavvyRouteInformationParser(),
      routerDelegate: SavvyDelegate(
        savvyPageManager: savvyPageManager,
        navigatorKey: navigatorKey,
      ),
    );
  }
}
