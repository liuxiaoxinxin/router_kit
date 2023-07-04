import 'package:analyzer/dart/element/element.dart';
import 'package:router_compiler/src/info/info.dart';
import 'package:router_compiler/src/util/utils.dart';

class PageWriter {
  PageWriter(this.info);

  final PageInfo info;

  final StringBuffer _buffer = StringBuffer();

  void generate() {
    _generateController();
    _generateProvider();
  }

  void _generateController() {
    // begin

    _buffer.writeln();

    _buffer.writeln('class ${info.controllerDisplayName} {');

    // blank
    _buffer.writeln();

    _buffer.writeln('String get name => ${info.providerDisplayName}.name;');

    // blank
    _buffer.writeln();

    _buffer.writeln(
        'String get routeName => ${info.providerDisplayName}.routeName;');

    // blank
    _buffer.writeln();

    _buffer.writeln(
        'WidgetBuilder get routeBuilder => ${info.providerDisplayName}.routeBuilder;');

    _buffer.writeln();

    _buffer
        .writeln('String? get flavor => ${info.providerDisplayName}.flavor;');

    // blank
    _buffer.writeln();
    _buffer
      ..writeln('@override')
      ..writeln('dynamic noSuchMethod(Invocation invocation) {')
      ..writeln('if (invocation.isGetter) {')
      ..writeln('switch (invocation.memberName) {')
      ..writeln('case #name:')
      ..writeln('return name;')
      ..writeln('case #routeName:')
      ..writeln('return routeName;')
      ..writeln('case #routeBuilder:')
      ..writeln('return routeBuilder;')
      ..writeln('case #flavor:')
      ..writeln('return flavor;')
      ..writeln('}')
      ..writeln('}')
      ..writeln('return super.noSuchMethod(invocation);')
      ..writeln('}');

    // end
    _buffer.writeln('}');
  }

  void _generateProvider() {
    // begin
    _buffer.writeln('class ${info.providerDisplayName} {');

    // constructor
    _buffer.writeln('const ${info.providerDisplayName}._();');

    _buffer.writeln();

    _buffer.writeln(
        'static const String? flavor = ${info.flavor != null ? "'${info.flavor}'" : null};');

    // blank
    _buffer.writeln();

    _buffer.writeln("static const String name = '${info.name}';");

    // blank
    _buffer.writeln();

    _buffer.writeln("static const String routeName = '${info.routeName}';");

    // blank
    _buffer.writeln();

    _buffer.writeln(
        'static final WidgetBuilder routeBuilder = (BuildContext context) {');
    if (info.constructor.parameters.isNotEmpty) {
      _buffer.writeln(
          'final Map<String, dynamic>? arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;');
      final StringBuffer arguments = StringBuffer()
        ..writeln(<String>[
          if (info.constructor.parameters
              .any((ParameterElement element) => !element.isNamed))
            info.constructor.parameters
                .where((ParameterElement element) => !element.isNamed)
                .map((ParameterElement element) =>
                    "arguments?['${info.convertField(element.name)}'] as ${element.type.getDisplayString(withNullability: true)},")
                .join('\n'),
          if (info.constructor.parameters
              .any((ParameterElement element) => element.isNamed))
            info.constructor.parameters
                .where((ParameterElement element) => element.isNamed)
                .map((ParameterElement element) =>
                    "${element.name}: arguments?['${info.convertField(element.name)}'] as ${element.type.getDisplayString(withNullability: true)},")
                .join('\n'),
        ].join('\n'));
      _buffer.writeln('return ${info.displayName}($arguments);');
    } else {
      _buffer.writeln('return ${info.displayName}();');
    }
    _buffer.writeln('};');

    if (info.constructor.parameters.isNotEmpty) {
      // blank
      _buffer.writeln();

      _buffer
        ..writeln('static Map<String, dynamic> routeArgument(${<String>[
          if (info.constructor.parameters.any((ParameterElement element) =>
              !element.isNamed && !element.isOptional))
            info.constructor.parameters
                .where((ParameterElement element) =>
                    !element.isNamed && !element.isOptional)
                .map((ParameterElement element) =>
                    '${formatPrettyDisplay(element.type)} ${element.name}')
                .join(', '),
          if (info.constructor.parameters.any((ParameterElement element) =>
              !element.isNamed && element.isOptional))
            '[${info.constructor.parameters.where((ParameterElement element) => !element.isNamed && element.isOptional).map((ParameterElement element) => '${formatPrettyDisplay(element.type)} ${element.name}${element.hasDefaultValue ? ' = ${element.defaultValueCode}' : ''}').join(', ')},]',
          if (info.constructor.parameters
              .any((ParameterElement element) => element.isNamed))
            '{${info.constructor.parameters.where((ParameterElement element) => element.isNamed).map((ParameterElement element) => '${element.isRequiredNamed ? 'required ' : ''}${formatPrettyDisplay(element.type)} ${element.name}${element.hasDefaultValue ? ' = ${element.defaultValueCode}' : ''}').join(', ')},}',
        ].join(', ')}) {')
        ..writeln(
            'return <String, dynamic>{${info.constructor.parameters.map((ParameterElement element) => "'${info.convertField(element.name)}': ${element.name},").join('\n')}};')
        ..writeln('}');
    }

    // blank
    _buffer.writeln();
    _buffer
      ..writeln('static Future<T?> pushByNamed<T extends Object?>(${<String>[
        'BuildContext context',
        if (info.constructor.parameters.any((ParameterElement element) =>
            !element.isNamed && !element.isOptional))
          info.constructor.parameters
              .where((ParameterElement element) =>
                  !element.isNamed && !element.isOptional)
              .map((ParameterElement element) =>
                  '${formatPrettyDisplay(element.type)} ${element.name}')
              .join(', '),
        if (info.constructor.parameters.any((ParameterElement element) =>
            !element.isNamed && element.isOptional))
          '[${info.constructor.parameters.where((ParameterElement element) => !element.isNamed && element.isOptional).map((ParameterElement element) => '${formatPrettyDisplay(element.type)} ${element.name}${element.hasDefaultValue ? ' = ${element.defaultValueCode}' : ''}').join(', ')},]',
        if (info.constructor.parameters
            .any((ParameterElement element) => element.isNamed))
          '''
          { 
            ${info.interceptor != null ? 'bool? ignoreInterceptor, ' : ''}
            ${info.constructor.parameters.where((ParameterElement element) => element.isNamed).map((ParameterElement element) => '${element.isRequiredNamed ? 'required ' : ''}${formatPrettyDisplay(element.type)} ${element.name}${element.hasDefaultValue ? ' = ${element.defaultValueCode}' : ''}').join(', ')},
            }
          ''',
      ].join(', ')}) {')
      ..writeAll(<String>[
        if (info.interceptor != null)
          '''
    Future<T?> next() => Navigator.of(context).pushNamed(routeName, ${_navigatorArgumentsCode()},);
    if (ignoreInterceptor != null && ignoreInterceptor) return next();
    return ${info.interceptor!.name}(context, routeName, ${_navigatorArgumentsCode()}, next: next) as Future<T?>;
            '''
        else
          'return Navigator.of(context).pushNamed(routeName, ${_navigatorArgumentsCode()},);',
      ], '\n')
      ..writeln('}');

    // end
    _buffer.writeln('}');
  }

  String _navigatorArgumentsCode() {
    List<String> parameters;
    if (info.constructor.parameters.isNotEmpty) {
      parameters = info.constructor.parameters.map((ParameterElement element) {
        return "'${info.convertField(element.name)}': ${element.name},";
      }).toList();
    } else {
      parameters = <String>[];
    }
    parameters.add(
        "'route_fullscreenDialog': ${info.fullscreenDialog ? 'true' : 'false'},");
    parameters
        .add("'route_maintainState': ${info.maintainState ? 'true' : 'false'},");
    return 'arguments: <String, dynamic>{${parameters.join('\n')}}';
  }

  @override
  String toString() => _buffer.toString();
}
