import 'package:flutter/widgets.dart';
import 'package:savvy_navigator/navigator/savvy_page_manager.dart';

class SavvyPageManagerProvider extends InheritedNotifier<SavvyPageManager> {
  const SavvyPageManagerProvider({
    Key? key,
    required Widget child,
    required SavvyPageManager notifier,
  }) : super(
          child: child,
          notifier: notifier,
          key: key,
        );

  static SavvyPageManager? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SavvyPageManagerProvider>()?.notifier;
  }
}