// import 'package:flutter/widgets.dart';

typedef Next = Future<dynamic> Function();

typedef Interceptor = Future<dynamic> Function(
  Object context,
  String routeName, {
  Object? arguments,
  Next? next,
});

enum FieldRename {
  none,
  kebab,
  snake,
  pascal,
}

class Page {
  const Page({
    this.flavor,
    required this.name,
    required this.routeName,
    this.fieldRename = FieldRename.snake,
    this.fullscreenDialog = false,
    this.maintainState = true,
    this.interceptor,
  });

  final String? flavor;

  final String name;

  final String routeName;

  final FieldRename fieldRename;

  /// true: 新页面将会从屏幕底部滑入，false: 水平方向
  final bool fullscreenDialog;

  /// true：当入栈一个新路由时，原来的路由仍然会被保存在内存中，false：如果想在路由没用的时候释放其所占用的所有资源
  final bool maintainState;

  final Interceptor? interceptor;
}

class Manifest {
  const Manifest();
}
