import 'package:awesome_template/app/modules/main_page.dart';
import 'package:flutter/material.dart';
import '../modules/home/four_page.dart';
import '../modules/home/second_page.dart';
import '../modules/home/third_page.dart';
import '../modules/home/home_page.dart';
import '/r_router/page/error_page.dart';
import '/r_router/r_router.dart';

class AppRoutes {
  static const String root = '/';

  static void setupRoutes() {
    RRouter.setPathStrategy(true)
        .addRoutes(_getRoutes())
        .setErrorPage(_generateErrorPage());
  }

  static List<NavigatorRoute> _getRoutes() {
    return <NavigatorRoute>[
      NavigatorRoute(
        root,
        (routeContext) => const MainPage(),
      )
    ];
  }

  static ErrorPage _generateErrorPage() {
    return ErrorPageWrapper(
      notFound: (BuildContext context, Context routeContext) => Material(
        child: Center(
          child: Text('Page Not Found:${routeContext.path}'),
        ),
      ),
      error: (BuildContext context, FlutterErrorDetails flutterErrorDetails) =>
          Material(
        child: Center(
          child: Text(
              'Exception Page (${flutterErrorDetails.exceptionAsString()})'),
        ),
      ),
    );
  }
}
