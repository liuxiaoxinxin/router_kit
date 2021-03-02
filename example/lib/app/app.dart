import 'dart:async';

import 'package:example/app/app.manifest.g.dart';
import 'package:example/pages/not_found/not_found_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:router_annotation/router_annotation.dart' as rca;

part 'app.g.dart';

Future<dynamic> _globalA(dynamic /* BuildContext */ context, String routeName, {Object arguments, Future<dynamic> Function() next}) {
  assert(context is BuildContext);
  return next?.call();
}

@rca.Manifest(
  interceptors: <rca.RouteInterceptor>[
    _globalA,
    App._globalB,
  ],
)
class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  static Future<dynamic> _globalB(dynamic /* BuildContext */ context, String routeName, {Object arguments, Future<dynamic> Function() next}) {
    assert(context is BuildContext);
    return next?.call();
  }

  static Future<dynamic> globalAuth(dynamic /* BuildContext */ context, String routeName, {Object arguments, Future<dynamic> Function() next}) async {
    assert(context is BuildContext);
    dynamic isLoggedin = false;
    if (isLoggedin != null && isLoggedin is bool && isLoggedin) {
      return next?.call();
    }
    return null;
  }

  // static Future<T> pushByNamed<T extends Object>(BuildContext context, String routeName,
  //     {Object arguments, List<Future<dynamic> Function(dynamic, String, {Object arguments, Future<dynamic> Function() next})> interceptors}) {
  //   List<Future<dynamic> Function(dynamic, String, {Object arguments, Future<dynamic> Function() next})> allInterceptors =
  //       <Future<dynamic> Function(dynamic, String, {Object arguments, Future<dynamic> Function() next})>[
  //     if (interceptors?.isNotEmpty ?? false) ...interceptors,
  //     if (AppProvider.interceptors?.isNotEmpty ?? false) ...AppProvider.interceptors,
  //   ];
  //
  //   List<Future<dynamic> Function()> dispatchers = <Future<dynamic> Function()>[
  //     () => Navigator.of(context).pushNamed(routeName, arguments: arguments),
  //   ];
  //   for (Future<dynamic> Function(dynamic, String, {Object arguments, Future<dynamic> Function() next}) interceptor in allInterceptors.reversed) {
  //     Future<dynamic> Function() next = dispatchers.last;
  //     dispatchers.add(() => interceptor.call(context, routeName, arguments: arguments, next: next));
  //   }
  // }

  static Future<T> pushNamed<T extends Object>(BuildContext context, String routeName,
      {Object arguments, List<Future<dynamic> Function(dynamic, String, {Object arguments, Future<dynamic> Function() next})> interceptors}) {
    List<Future<dynamic> Function(dynamic, String, {Object arguments, Future<dynamic> Function() next})> allInterceptors =
        <Future<dynamic> Function(dynamic, String, {Object arguments, Future<dynamic> Function() next})>[
      if (interceptors?.isNotEmpty ?? false) ...interceptors,
      if (AppProvider.interceptors?.isNotEmpty ?? false) ...AppProvider.interceptors,
    ];
    List<Future<dynamic> Function()> dispatchers = <Future<dynamic> Function()>[
      () => Navigator.of(context).pushNamed(routeName, arguments: arguments),
    ];
    for (Future<dynamic> Function(dynamic, String, {Object arguments, Future<dynamic> Function() next}) interceptor in allInterceptors.reversed) {
      Future<dynamic> Function() next = dispatchers.last;
      dispatchers.add(() => interceptor.call(context, routeName, arguments: arguments, next: next));
    }
    return dispatchers.last.call();
  }

  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: _onGenerateRoute,
      onUnknownRoute: _onUnknownRoute,
      builder: (BuildContext context, Widget child) {
        /// 禁用系统字体控制
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0,
            boldText: false,
          ),
          child: child,
        );
      },
      onGenerateTitle: (BuildContext context) {
        return 'RouterKit';
      },
      theme: ThemeData.light().copyWith(
        platform: TargetPlatform.iOS,
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    if (AppManifest.routes.containsKey(settings.name)) {
      return MaterialPageRoute<dynamic>(
        builder: AppManifest.routes[settings.name],
        settings: settings,
      );
    }
    return null;
  }

  Route<dynamic> _onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute<dynamic>(
      builder: AppManifest.routes[NotFoundPageProvider.routeName],
      settings: settings,
    );
  }
}
