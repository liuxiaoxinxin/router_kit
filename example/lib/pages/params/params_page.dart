import 'package:flutter/material.dart';
import 'package:router_annotation/router_annotation.dart' as rca;

part 'params_page.g.dart';

typedef Callback = String? Function(String? info);

Future<Object?> globalAuth(
  Object context,
  String routeName, {
  Object? arguments,
  rca.Next? next,
}) async {
  // todo 去登录
  print('进入拦截器');
  return next?.call();
}

@rca.Page(
  name: '参数',
  routeName: '/params',
  interceptor: globalAuth,
)
// ignore: must_be_immutable
class ParamsPage extends StatefulWidget {
  ParamsPage(
    this.paramA1, {
    super.key,
    required this.paramB,
    this.paramC,
    this.paramF = 'xyz',
    this.paramG = 'xxx',
    this.callback,
  });

  final String paramA1;

  final String paramB;

  final String? paramC;

  final String paramD = '';

  String paramE = '';
  final String? paramF;
  final String paramG;

  Callback? callback;

  @override
  State<StatefulWidget> createState() {
    return _ParamsPageState();
  }
}

class _ParamsPageState extends State<ParamsPage> {
  @override
  Widget build(BuildContext context) {
    print('带参数页面');
    return Scaffold(
      appBar: AppBar(
        title: Text('Params'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Image.network('https://www.baidu.com/img/bd_logo1.png'),
            Text('${widget.paramA1} - ${widget.paramB} - ${widget.paramC}'),
          ],
        ),
      ),
    );
  }
}
