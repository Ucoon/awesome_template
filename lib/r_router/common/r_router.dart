library r_router;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide SearchDelegate;
import 'package:path_tree/path_tree.dart';

import '../page/custom_page_route.dart';
import '../page/error_page.dart';
import '../utils/string.dart';
import 'web_config/path_strategy_io.dart'
    if (dart.library.html) 'web_config/path_strategy_web.dart';
import '../translate_builder/transaction_builder.dart';

part 'context.dart';

part 'navigator_route.dart';

part 'params.dart';

part 'r_router_delegate.dart';

part 'r_router_information_parse.dart';

part 'r_router_observer.dart';

part 'r_router_register.dart';

part 'redirect.dart';

RRouterBasic RRouter = RRouterBasic();

typedef PopHome = Future<bool> Function();

typedef PageBuilder = Page<dynamic> Function(Context ctx, WidgetBuilder builder,
    PageTransitionsBuilder pageTransitionsBuilder);

//Custom Page Builder
CustomPage<dynamic> _kDefaultCustomPageBuilder(Context ctx,
        WidgetBuilder builder, PageTransitionsBuilder pageTransitionsBuilder) =>
    CustomPage<dynamic>(
        child:
            Builder(builder: (BuildContext context) => builder.call(context)),
        buildCustomRoute: (BuildContext context, CustomPage<dynamic> page) =>
            PageBasedCustomPageRoute(
                page: page, pageTransitionsBuilder: pageTransitionsBuilder),
        key: ValueKey(ctx.at.microsecondsSinceEpoch),
        name: ctx.path,
        arguments: ctx.toJson(),
        restorationId: ctx.path);

Future<bool> _kDefaultPopHome() => Future.value(false);

class RRouterBasic {
  final RRouterRegister _register = RRouterRegister();
  final RRouterObserver _observer = RRouterObserver();
  final RRouterDelegate _delegate = RRouterDelegate();

  late final RRouterInformationParser _informationParser =
      RRouterInformationParser();

  PageTransitionsBuilder _defaultTransitionBuilder;
  final List<RouteInterceptor> _interceptor;

  NavigatorObserver get observer {
    addComplete();
    return _observer;
  }

  RRouterDelegate get delegate {
    addComplete();
    return _delegate;
  }

  RRouterInformationParser get informationParser {
    return _informationParser;
  }

  NavigatorState get navigator {
    assert(_observer.navigator != null, 'please add the observer into app');
    return _observer.navigator!;
  }

  BuildContext get context {
    assert(_observer.navigator != null, 'please add the observer into app');
    return navigator.context;
  }

  ErrorPage _errorPage;

  PageBuilder _pageBuilder;

  PopHome _popHome;

  RRouterBasic(
      {ErrorPage? errorPage,
      List<RouteInterceptor>? interceptor,
      PageBuilder? pageBuilder,
      PopHome? popHome})
      : _errorPage = errorPage ?? DefaultErrorPage(),
        _defaultTransitionBuilder = DefaultTransitionBuilder(),
        _interceptor = interceptor ?? <RouteInterceptor>[],
        _pageBuilder = pageBuilder ?? _kDefaultCustomPageBuilder,
        _popHome = popHome ?? _kDefaultPopHome;

  /// path strategy mode
  ///
  /// if true ? will use http://localhost:8080/index.html
  /// if false ? will use http://localhost:8080/#/index.html
  RRouterBasic setPathStrategy(bool isUsePath) {
    setUrlPathStrategy(isUsePath);
    return this;
  }

  /// default transition builder
  ///
  /// [pageTransitionsBuilder] default page Transition builder
  RRouterBasic setDefaultTransitionBuilder(
      PageTransitionsBuilder pageTransitionsBuilder) {
    _defaultTransitionBuilder = pageTransitionsBuilder;
    return this;
  }

  /// default print
  ///
  /// [msg] you want to print msg.
  void _print(Object msg) {
    debugPrint(msg.toString());
  }

  /// set Error Page
  ///
  /// [errorPage] found in ErrorPage Class
  RRouterBasic setErrorPage(ErrorPage errorPage) {
    _errorPage = errorPage;
    return this;
  }

  /// set default page builder
  ///
  /// [pageBuilder] generate page.
  RRouterBasic setPageBuilder(PageBuilder pageBuilder) {
    _pageBuilder = pageBuilder;
    return this;
  }

  /// set pop home method
  ///
  /// [popHome] if return false will did pop home.
  ///           or if true will hold.
  RRouterBasic setPopHome(PopHome popHome) {
    _popHome = popHome;
    return this;
  }

  /// add Routes
  ///
  /// [routes] You want to add routes.
  RRouterBasic addRoutes(Iterable<NavigatorRoute> routes) {
    _register.add(routes);
    return this;
  }

  /// add Route
  ///
  /// [route] You want to add route
  /// [isReplaceRouter] if ture will replace route
  RRouterBasic addRoute(NavigatorRoute route, {bool? isReplaceRouter}) {
    _register.addRoute(route, isReplaceRouter: isReplaceRouter);
    return this;
  }

  /// add route observer
  ///
  /// [observer] Navigator Observer
  RRouterBasic addObserver(NavigatorObserver observer) {
    _delegate.addObserver(observer);
    return this;
  }

  /// add route observers
  ///
  /// [observers] Navigator Observer List
  RRouterBasic addObservers(Iterable<NavigatorObserver> observers) {
    _delegate.addObservers(observers);
    return this;
  }

  /// add interceptor
  ///
  /// [interceptor]  add interceptor.
  RRouterBasic addInterceptor(RouteInterceptor interceptor) {
    _interceptor.add(interceptor);
    return this;
  }

  /// add interceptors
  ///
  /// [interceptors]  add interceptor list.
  RRouterBasic addInterceptors(List<RouteInterceptor> interceptors) {
    _interceptor.addAll(interceptors);
    return this;
  }

  /// When you add Route complete ,you should use it
  void addComplete() {
    _register._build();
    ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
      return Material(
        child: Builder(
            builder: (BuildContext context) =>
                _errorPage.errorPage(context, flutterErrorDetails)),
      );
    };
  }

  /// Navigate to Route
  /// [path]  page path
  /// [body] page require arguments
  /// [replace] if ture will replace current page to navigate new page.
  /// [clearTrace] if ture will clear all page  to navigate new page.
  /// [isSingleTop] if ture will only path is not current path navigate.
  /// [result] went replace is true, this will able.
  /// [pageTransitions] you navigate transition , if null will use default page transitions builder.
  Future<dynamic> navigateTo<T extends Object?, TO extends Object?>(String path,
      {dynamic body,
      bool? replace,
      bool? clearTrace,
      bool? isSingleTop,
      TO? result,
      PageTransitionsBuilder? pageTransitions}) async {
    PageTransitionsBuilder? _pageTransitions;
    WidgetBuilder? builder;
    final ctx = Context(
      path,
      body: body,
    );
    if (_interceptor.isNotEmpty) {
      dynamic result;
      for (final interceptor in _interceptor) {
        result = await interceptor(ctx);
        if (result == true) {
          return;
        }
      }
    }
    NavigatorRoute? handler = _register.match(ctx.uri);
    if (handler != null) {
      final interceptor = handler.getInterceptor();
      if (interceptor.isNotEmpty) {
        dynamic result;
        for (final interceptor in interceptor) {
          result = await interceptor(ctx);
          if (result == true) {
            return;
          }
        }
      }
      final result = await handler(ctx);
      if (result is WidgetBuilder) {
        builder = result;
        _pageTransitions = pageTransitions ?? handler.defaultPageTransaction;
      } else if (result is Redirect) {
        return await navigateTo(result.path,
            body: body,
            replace: replace,
            clearTrace: clearTrace,
            isSingleTop: isSingleTop,
            result: result,
            pageTransitions: pageTransitions);
      } else {
        return SynchronousFuture(result);
      }
    } else {
      builder = (BuildContext context) => _errorPage.notFoundPage(context, ctx);
    }

    _pageTransitions ??= _defaultTransitionBuilder;

    dynamic navigateResult;

    if (isSingleTop == true && _observer.topPath == path) {
      return null;
    }

    if (clearTrace == true) {
      navigateResult = await _delegate
          .clearTracePush(_pageNamed(ctx, builder, _pageTransitions));
    } else if (replace == true) {
      navigateResult = await _delegate.replacePush<T, TO>(
          _pageNamed(ctx, builder, _pageTransitions), result);
    } else {
      navigateResult =
          await _delegate.push(_pageNamed(ctx, builder, _pageTransitions));
    }
    return SynchronousFuture(navigateResult);
  }

  /// generate page by name(Navigation2.0)
  ///
  /// [ctx] route context
  /// [builder] widget builder
  /// [pageTransitionsBuilder] page transactions builder
  Page<dynamic> _pageNamed(Context ctx, WidgetBuilder builder,
      PageTransitionsBuilder pageTransitionsBuilder) {
    return _pageBuilder(ctx, builder, pageTransitionsBuilder);
  }

  /// Pop the top-most route off the navigator.
  ///
  /// [result] you want to pop value.
  pop<T extends Object?>([T? result]) {
    return _delegate.pop<T>(result);
  }

  /// Whether the navigator can be popped.
  ///
  /// {@macro flutter.widgets.navigator.canPop}
  ///
  /// See also:
  ///
  ///  * [Route.isFirst], which returns true for routes for which [canPop]
  ///    returns false.
  bool canPop() {
    return _delegate.canPop();
  }

  /// Consults the current route's [Route.willPop] method, and acts accordingly,
  /// potentially popping the route as a result; returns whether the pop request
  /// should be considered handled.
  ///
  /// {@macro flutter.widgets.navigator.maybePop}
  ///
  /// See also:
  ///
  ///  * [Form], which provides an `onWillPop` callback that enables the form
  ///    to veto a [pop] initiated by the app's back button.
  ///  * [ModalRoute], which provides a `scopedWillPopCallback` that can be used
  ///    to define the route's `willPop` method.
  Future<bool> maybePop<T extends Object?>([T? result]) {
    return _delegate.maybePop<T>(result);
  }

  /// run route method
  ///
  /// [path] your register path.
  /// [body] post body
  Future<WidgetBuilder?> runRoute(String path, dynamic body) async {
    final ctx = Context(
      path,
      body: body,
    );
    NavigatorRoute? handler = _register.match(ctx.uri);
    if (handler != null) {
      final result = await handler(ctx);
      if (result is WidgetBuilder) {
        return result;
      } else if (result is Redirect) {
        return runRoute(result.path, body);
      }
    }
    return null;
  }
}

extension RRouterBuildContextExtension on BuildContext {
  /// get ctx from route
  Context get readCtx {
    final modal = ModalRoute.of(this);
    assert(modal != null, 'Please use RRoute navigateTo');
    assert(modal!.settings.arguments is Map, 'Please use RRoute navigateTo');

    return Context.fromJson(modal!.settings.arguments as Map);
  }
}
