import 'package:flutter/material.dart';
import 'package:router_annotation/router_annotation.dart' as rca;

part 'login_page.g.dart';

@rca.Page(
  name: '登录',
  routeName: '/login',
  fullscreenDialog: true, // 模态弹出
)
class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Login'),
            onTap: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
  }
}
