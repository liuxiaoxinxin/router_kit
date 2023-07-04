import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:router_annotation/router_annotation.dart' as rca;

part 'about_page.g.dart';

Future<Object?> globalAuth(
  Object context,
  String routeName, {
  Object? arguments,
  rca.Next? next,
}) async {
  // todo 去登录
  return next?.call();
}

@rca.Page(
  name: '关于',
  routeName: '/about',
  interceptor: globalAuth, // 拦截器
)
class AboutPage extends StatefulWidget {
  const AboutPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _AboutPageState();
  }
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
    );
  }
}
