// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'not_found_page.dart';

// **************************************************************************
// PageCompilerGenerator
// **************************************************************************

class NotFoundPageProvider {
  const NotFoundPageProvider._();

  static const String name = '404';

  static const String routeName = '/not_found';

  static WidgetBuilder routeBuilder = (BuildContext context) {
    Map<String, dynamic> arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return NotFoundPage(
      key: arguments['key'] as Key,
    );
  };
}

class NotFoundPageNavigator {
  const NotFoundPageNavigator._();

  static Map<String, dynamic> routeArgument({
    Key key,
  }) {
    return <String, dynamic>{
      'key': key,
    };
  }
}
