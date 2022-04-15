import 'dart:async';

import 'package:flutter/material.dart';
import 'package:savvy_navigator/navigator/savvy_page_manager.dart';

class SavvyDelegate extends RouterDelegate<Uri> with ChangeNotifier {
  SavvyDelegate({
    required this.savvyPageManager,
    required this.navigatorKey,
  }) {
    savvyPageManager.addListener(() {
      notifyListeners();
    });
  }

  final SavvyPageManager savvyPageManager;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: savvyPageManager.pageStack,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        return savvyPageManager.onPopPage(route, result);
      },
    );
  }

  @override
  Future<bool> popRoute() async {
    return true;
  }

  @override
  Future<void> setNewRoutePath(Uri configuration) async {
    savvyPageManager.pushWithReplace(configuration.path);
  }

  @override
  Uri? get currentConfiguration => Uri(
        path: savvyPageManager.appropriateHistory.last.url,
      );
}
