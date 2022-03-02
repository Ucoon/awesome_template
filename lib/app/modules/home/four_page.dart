import 'package:flutter/material.dart';

class FourPage extends StatelessWidget {
  const FourPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FourPage'),
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
