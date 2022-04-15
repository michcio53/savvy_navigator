import 'package:flutter/widgets.dart';

class SavvyRoute {
  const SavvyRoute({
    required this.path,
    required this.buildPage,
    this.expectedPathParams = const [],
  });
  final String path;
  final List<String> expectedPathParams;
  final Page Function(
    Map<String, String> pathArgs,
  ) buildPage;
}
