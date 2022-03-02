import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app/routes/app_routes.dart';
import 'package:awesome_template/generated/l10n.dart';
import 'package:awesome_template/r_router/common/r_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ///注册路由配置
  AppRoutes.setupRoutes();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 667), // iOS@2倍尺寸
      builder: () => MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        routerDelegate: RRouter.delegate,
        routeInformationParser: RRouter.informationParser,
        locale: const Locale('zh', 'CN'), //当前的语言
        supportedLocales: S.delegate.supportedLocales, //支持的语言
        localizationsDelegates: const [
          //intl的delegate
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
