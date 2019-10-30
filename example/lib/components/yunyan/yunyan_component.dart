import 'package:example/components/yunyan/yunyan_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:router_annotation/router_annotation.dart';

part 'yunyan_component.component.dart';

@Component(
  routeName: '/yunyan',
)
class YunyanComponent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _YunyanComponentState();
  }
}

class _YunyanComponentState extends State<YunyanComponent> {
  static const List<String> _tabs = <String>[
    '推荐',
    '女生',
    '男生',
    '限免',
  ];

  GlobalKey _tabBarViewKey;
  List<ValueNotifier<double>> _notifiers;

  @override
  void initState() {
    super.initState();
    _tabBarViewKey = GlobalKey();
    _notifiers = _tabs.map((_) => ValueNotifier<double>(0.0)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        body: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            TabBarView(
              key: _tabBarViewKey,
              children: _tabs.map((String tab) {
                int index = _tabs.indexOf(tab);
                Widget child = YunyanView(title: tab);
                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    if (notification.metrics.axis == Axis.vertical) {
                      _notifiers[index].value = notification.metrics.pixels;
                    }
                    return false;
                  },
                  child: child,
                );
              }).toList(),
            ),
            SafeArea(
              top: false,
              left: false,
              right: false,
              child: Builder(
                builder: (BuildContext context) {
                  return ValueListenableBuilder<double>(
                    valueListenable:
                        _notifiers[DefaultTabController.of(context).index],
                    builder:
                        (BuildContext context, double value, Widget child) {
                      final double appbarHeight =
                          MediaQuery.of(context).padding.top + kToolbarHeight;
                      return AnnotatedRegion<SystemUiOverlayStyle>(
                        child: Container(
                          constraints: BoxConstraints.tightFor(
                            height: appbarHeight,
                          ),
                          color: value >= appbarHeight
                              ? Colors.white
                              : Colors.transparent,
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top,
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TabBar(
                                  tabs: _tabs.map((String tab) {
                                    TextPainter textPainter = TextPainter(
                                      text: TextSpan(
                                        text: tab,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      textDirection: Directionality.of(context),
                                      locale: Localizations.localeOf(context),
                                    )..layout();
                                    return Tab(
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: textPainter.width,
                                        child: Text(tab),
                                      ),
                                    );
                                  }).toList(),
                                  isScrollable: true,
                                  indicatorPadding: EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                    bottom: 7.0,
                                  ),
                                  indicatorColor: value >= appbarHeight
                                      ? Colors.green
                                      : Colors.white,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  labelStyle: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                  labelColor: value >= appbarHeight
                                      ? Colors.green
                                      : Colors.white,
                                  unselectedLabelStyle: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                  unselectedLabelColor: value >= appbarHeight
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              ConstrainedBox(
                                constraints: const BoxConstraints.tightFor(
                                  width: kToolbarHeight,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.search),
                                  color: value >= appbarHeight
                                      ? Colors.black
                                      : Colors.white,
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                        value: value >= appbarHeight
                            ? SystemUiOverlayStyle.dark
                            : SystemUiOverlayStyle.light,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}