import 'package:flutter/material.dart';
import '../../../r_router/common/r_router.dart';
import '../../routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('_HomePageState.build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('appbarTitle'),
      ),
      body: Column(
        children: <Widget>[
          TextButton(
            onPressed: () {
              RRouter.navigateTo(AppRoutes.carPage);
            },
            child: const Text('本地数据库+Provider'),
          ),
        ],
      ),
    );
  }
}
