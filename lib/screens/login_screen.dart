import 'package:flutter/material.dart';
import 'package:savvy_navigator/navigator/savvy_page_manager_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static MaterialPage page() => const MaterialPage(
        child: LoginScreen(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final result = await SavvyPageManagerProvider.of(context)!.pushWithUri('/post/123');
            print(result);
          },
          child: const Text(
            'login button',
          ),
        ),
      ),
    );
  }
}
