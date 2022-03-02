import 'package:flutter/material.dart';
import 'package:awesome_template/app/routes/app_routes.dart';
import 'package:awesome_template/r_router/r_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // void get() async {
  //   HttpResponse appResponse = await HttpClient()
  //       .get("consultant/Order", queryParameters: {'page': 1, 'pageSize': 10});
  //   if (appResponse.isSuccessful) {
  //     debugPrint("succeed====" + appResponse.data.toString());
  //   } else {
  //     debugPrint("failed====" + appResponse.error.toString());
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // HttpConfig(baseUrl: "https://gank.io/", proxy: "192.168.2.249:8888");
    // HttpConfig dioConfig = HttpConfig(
    //   baseUrl: "https://captcha.anji-plus.com/captcha-api",
    // );
    // HttpClient().init(dioConfig: dioConfig);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('appbarTitle'),
      ),
      body: Column(
        children: <Widget>[
          TextButton(
            onPressed: () {
              RRouter.navigateTo(
                AppRoutes.secondPage,
                body: {
                  'param1': '我来自第一页',
                },
              );
            },
            child: const Text('Get'),
          ),
        ],
      ),
    );
  }
}
