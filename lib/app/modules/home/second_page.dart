import 'package:flutter/material.dart';
import '/app/routes/app_routes.dart';
import '/r_router/r_router.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SecondPage'),
      ),
      body: Column(
        children: <Widget>[
          TextButton(
            onPressed: () {},
            child: const Text('Get'),
          ),
        ],
      ),
    );
  }
}
