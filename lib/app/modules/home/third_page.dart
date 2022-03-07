import 'package:flutter/material.dart';
import '/app/routes/app_routes.dart';
import '/r_router/r_router.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ThirdPage'),
      ),
      body: Column(
        children: <Widget>[
          TextButton(
            onPressed: () {
              RRouter.navigateTo(AppRoutes.fourPage);
            },
            child: const Text('Get'),
          ),
        ],
      ),
    );
  }
}
