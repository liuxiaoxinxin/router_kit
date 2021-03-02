import 'package:analyzer/dart/element/element.dart';
import 'package:router_compiler/src/info/info.dart';

class PageWriter {
  PageWriter(this.info);

  final PageInfo info;

  final StringBuffer _buffer = StringBuffer();

  void generate() {
    // begin
    _buffer.writeln('class ${info.providerDisplayName} {');

    // constructor
    _buffer.writeln('const ${info.providerDisplayName}._();');

    // blank
    _buffer.writeln();

    _buffer.writeln('static const String name = \'${info.name}\';');

    // blank
    _buffer.writeln();

    _buffer.writeln('static const String routeName = \'${info.routeName}\';');

    // blank
    _buffer.writeln();

    if (info.interceptors?.isNotEmpty ?? false) {
      String routeInterceptorType = info.interceptors.first.type.getDisplayString(withNullability: false);
      _buffer.writeln('static const List<$routeInterceptorType> interceptors = <$routeInterceptorType>[${info.interceptors.map((ExecutableElement element) {
        return <String>[
          element.enclosingElement.displayName,
          element.displayName,
        ].where((String element) => element?.isNotEmpty ?? false).join('.');
      }).join(',')}];');
    }

    // blank
    _buffer.writeln();

    // route
    _buffer.writeln(
        'static WidgetBuilder routeBuilder = (BuildContext context) {');
    StringBuffer ctor1 = StringBuffer();
    // for (ParameterElement ctorParameter in info.ctorParameters) {
    //   FieldInfo fieldInfo = info.fieldInfos[ctorParameter.displayName];
    //   ctor1.writeln(
    //       '${!fieldInfo.ignore ? 'arguments[\'${info.nameFormatter(fieldInfo.alias)}\'] as ${ctorParameter.type.getDisplayString(withNullability: false)}' : 'null'},');
    // }
    // for (ParameterElement ctorNamedParameter in info.ctorNamedParameters) {
    //   FieldInfo fieldInfo = info.fieldInfos[ctorNamedParameter.displayName];
    //   // ignore: deprecated_member_use
    //   if (ctorNamedParameter.hasRequired || !fieldInfo.ignore) {
    //     ctor1.writeln(
    //         '${ctorNamedParameter.displayName}: ${!fieldInfo.ignore ? 'arguments[\'${info.nameFormatter(fieldInfo.alias)}\'] as ${ctorNamedParameter.type.getDisplayString(withNullability: false)}' : 'null'},');
    //   }
    // }
    if (ctor1.isNotEmpty) {
      _buffer.writeln(
          'Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;');
    }
    _buffer.writeln('return ${info.displayName}(\n$ctor1);');
    _buffer.writeln('};');

    // blank
    _buffer.writeln();

    // if (info.ctorParameters.isNotEmpty || info.ctorNamedParameters.isNotEmpty) {
    //   // arguments
    //   StringBuffer ctor2 = StringBuffer();
    //   for (ParameterElement ctorParameter in info.ctorParameters) {
    //     FieldInfo fieldInfo = info.fieldInfos[ctorParameter.displayName];
    //     if (!fieldInfo.ignore) {
    //       ctor2.writeln(
    //           '${ctorParameter.type.getDisplayString(withNullability: false)} ${ctorParameter.displayName},');
    //     }
    //   }
    //   bool hasOptionalParameters = false;
    //   for (ParameterElement ctorNamedParameter in info.ctorNamedParameters) {
    //     FieldInfo fieldInfo = info.fieldInfos[ctorNamedParameter.displayName];
    //     if (!fieldInfo.ignore) {
    //       if (!hasOptionalParameters) {
    //         hasOptionalParameters = true;
    //         ctor2.writeln('{');
    //       }
    //       ctor2.writeln(
    //           // ignore: deprecated_member_use
    //           '${ctorNamedParameter.hasRequired ? '@required ' : ''}${ctorNamedParameter.type.displayName} ${ctorNamedParameter.displayName},');
    //     }
    //   }
    //   if (hasOptionalParameters) {
    //     ctor2.writeln('}');
    //   }
    //   _buffer.writeln(
    //       'static Map<String, dynamic> routeArgument(\n$ctor2){');
    //   _buffer.writeln('Map<String, dynamic> arguments = <String, dynamic>{};');
    //   for (ParameterElement ctorParameter in info.ctorParameters) {
    //     FieldInfo fieldInfo = info.fieldInfos[ctorParameter.displayName];
    //     if (!fieldInfo.ignore) {
    //       _buffer.write(
    //           'arguments[\'${info.nameFormatter(fieldInfo.alias)}\'] = ${ctorParameter.displayName};');
    //     }
    //   }
    //   for (ParameterElement ctorNamedParameter in info.ctorNamedParameters) {
    //     FieldInfo fieldInfo = info.fieldInfos[ctorNamedParameter.displayName];
    //     if (!fieldInfo.ignore) {
    //       _buffer.write(
    //           'arguments[\'${info.nameFormatter(fieldInfo.alias)}\'] = ${ctorNamedParameter.displayName};');
    //     }
    //   }
    //   _buffer.writeln('return arguments;');
    //   _buffer.writeln('}');
    //
    //   // // blank
    //   // _buffer.writeln();
    //   //
    //   // _buffer.writeln(
    //   //     'static Future<T> pushByNamed<T extends Object>(\nBuildContext context,\n$ctor2){');
    //   // _buffer.writeln('Map<String, dynamic> arguments = <String, dynamic>{};');
    //   // for (ParameterElement ctorParameter in info.ctorParameters) {
    //   //   FieldInfo fieldInfo = info.fieldInfos[ctorParameter.displayName];
    //   //   if (!fieldInfo.ignore) {
    //   //     _buffer.write(
    //   //         'arguments[\'${info.nameFormatter(fieldInfo.alias)}\'] = ${ctorParameter.displayName};');
    //   //   }
    //   // }
    //   // for (ParameterElement ctorNamedParameter in info.ctorNamedParameters) {
    //   //   FieldInfo fieldInfo = info.fieldInfos[ctorNamedParameter.displayName];
    //   //   if (!fieldInfo.ignore) {
    //   //     _buffer.write(
    //   //         'arguments[\'${info.nameFormatter(fieldInfo.alias)}\'] = ${ctorNamedParameter.displayName};');
    //   //   }
    //   // }
    //   // _buffer.writeln(
    //   //     'return Navigator.of(context).pushNamed(routeName, arguments: arguments,);');
    //   // _buffer.writeln('}');
    // } else {
    //   // _buffer
    //   //     .writeln('static Future<T> pushByNamed<T extends Object>(BuildContext context){');
    //   // _buffer.writeln('return Navigator.of(context).pushNamed(routeName);');
    //   // _buffer.writeln('}');
    // }

    // end
    _buffer.writeln('}');
  }

  @override
  String toString() => _buffer.toString();
}
