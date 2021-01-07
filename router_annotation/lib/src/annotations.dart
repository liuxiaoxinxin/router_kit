import 'dart:async';

import 'package:meta/meta.dart';

typedef NameFormatter = String Function(String fieldName);
typedef RouteInterceptor = FutureOr<dynamic> Function(dynamic /* BuildContext */ context, String routeName);

class Global {
  const Global({
    this.interceptor,
  });

  final RouteInterceptor interceptor;
}

class Field {
  const Field({
    this.alias,
    this.nullable,
    this.ignore,
  });

  final String alias;
  final bool nullable;
  final bool ignore;
}

class Page {
  const Page({
    @required this.name,
    @required this.routeName,
    this.interceptor,
    this.ignoreKey = true,
    this.autowired = true,
    this.nullableFields = true,
    this.nameFormatter,
  })  : assert(name != null),
        assert(routeName != null);

  final String name;
  final String routeName;
  final RouteInterceptor interceptor;
  final bool ignoreKey;
  final bool autowired;
  final bool nullableFields;
  final NameFormatter nameFormatter;
}

class Manifest {
  const Manifest();
}
