import 'package:flutter/material.dart';
import 'package:savvy_navigator/navigator/savvy_page_manager_provider.dart';

class PostLoginScreen extends StatelessWidget {
  const PostLoginScreen({Key? key, required this.id}) : super(key: key);

  static MaterialPage page(String id) => MaterialPage(
        child: PostLoginScreen(id: id),
      );

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ID is $id'),
            ElevatedButton(
              onPressed: () => SavvyPageManagerProvider.of(context)!.popFromRouter('Return result'),
              child: const Text(
                'Go back',
              ),
            )
          ],
        ),
      ),
    );
  }
}
