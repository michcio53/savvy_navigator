import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:savvy_navigator/navigator/savvy_route.dart';

class SavvyPageManager extends ChangeNotifier {
  SavvyPageManager({
    required String initialPagePath,
    required this.routes,
  }) {
    pushWithReplace(initialPagePath);
  }

  final List<SavvyRoute> routes;

  List<PageWithUrl> get appropriateHistory => List.unmodifiable(_pageWithUrl);

  List<Page> get pageStack => List.unmodifiable(_pageWithUrl.map((element) => element.page).toList());

  final List<PageWithUrl> _pageWithUrl = [];

  final Map<String, Completer<dynamic>> _completers = {};

  void popFromRouter([dynamic value]) {
    if (_pageWithUrl.length <= 1) {
      return;
    }
    final lastAppropriate = _pageWithUrl.last;
    final completer = _completers[lastAppropriate.url];

    if (value != null) {
      completer?.complete(value);
    }
    _completers.remove(lastAppropriate.url);
    _pageWithUrl.removeLast();
    notifyListeners();
  }

  bool onPopPage(Route<dynamic> route, dynamic result) {
    popFromRouter();
    return true;
  }

  PageWithUrl? _reveicePageWithResult(SavvyRoute savvyRoute, String uri) {
    final parsedUri = Uri(path: uri);
    if (_isCorrectRoute(savvyRoute.path, uri)) {
      final pathArgs = _receivePathArgs(savvyRoute.path, parsedUri.path, savvyRoute.expectedPathParams);
      final page = savvyRoute.buildPage(pathArgs);
      return PageWithUrl(page: page, url: uri);
    }
    return null;
  }

  Future pushWithUri(String uri) async {
    for (final savvyRoute in routes) {
      final pageWithUrl = _reveicePageWithResult(savvyRoute, uri);
      if (pageWithUrl != null) {
        return _pushWithResult(pageWithUrl);
      }
    }
  }

  void pushWithReplace(String uri) {
    for (final savvyRoute in routes) {
      final pageWithUrl = _reveicePageWithResult(savvyRoute, uri);
      if (pageWithUrl != null) {
        _pageWithUrl.clear();
        _pageWithUrl.add(pageWithUrl);
        notifyListeners();
        break;
      }
    }
  }

  Future _pushWithResult(PageWithUrl pageWithResult) {
    final completer = Completer();
    _pageWithUrl.add(pageWithResult);
    _completers[pageWithResult.url] = completer;
    notifyListeners();
    return completer.future;
  }

  bool _isCorrectRoute(String templateUrl, String receivedConfiguration) {
    final pathRegExp = pathToRegExp(templateUrl);
    return pathRegExp.hasMatch(receivedConfiguration);
  }

  Map<String, String> _receivePathArgs(String templateUrl, String receivedConfiguration, List<String> expectedArgs) {
    final pathRegExp = pathToRegExp(templateUrl);
    final match = pathRegExp.matchAsPrefix(receivedConfiguration);

    if (match != null) {
      return extract(expectedArgs, match);
    } else {
      return {};
    }
  }

  Future<void> setNewRoutePath(Uri configuration) async {
    for (final savvyRoute in routes) {
      final pageWithUrl = _reveicePageWithResult(savvyRoute, configuration.path);
      if (pageWithUrl != null) {
        _pushWithResult(pageWithUrl);
      }
      break;
    }
  }
}

class PageWithUrl extends Equatable {
  const PageWithUrl({
    required this.page,
    required this.url,
  });

  final Page page;
  final String url;

  @override
  List<Object?> get props => [page, url];
}
