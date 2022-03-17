import 'package:awesome_template/app/modules/car/views/add_car_page.dart';
import 'package:flutter/material.dart';
import '../modules/car/views/car_page.dart';
import '../modules/main_page.dart';
import '/r_router/page/error_page.dart';
import '/r_router/r_router.dart';

class AppRoutes {
  static const String root = '/';
  static const String carPage = '/carPage';
  static const String addCarPage = '/addCarPage';

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
      ),
      NavigatorRoute(
        carPage,
        (routeContext) => const CarPage(),
      ),
      NavigatorRoute(
        addCarPage,
        (routeContext) => const AddCarPage(),
      ),
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
