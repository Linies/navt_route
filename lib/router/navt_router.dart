import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'navt_page.dart';

class NavtRouterDelegate extends RouterDelegate<String>
    with PopNavigatorRouterDelegateMixin<String>, ChangeNotifier {
  final _stack = <Widget>[];

  static NavtRouterDelegate of(BuildContext context) {
    final delegate = Router.of(context).routerDelegate;
    assert(delegate is NavtRouterDelegate, 'Delegate type must match');
    return delegate as NavtRouterDelegate;
  }

  NavtRouterDelegate({
    required this.onGeneratePage,
  });

  final Widget onGeneratePage;

  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  String? get currentConfiguration =>
      _stack.isNotEmpty ? _stack.last.key.toString() : null;

  List<Widget> get stack => List.unmodifiable(_stack);

  void push(Widget newPage) {
    _stack.add(newPage);
    notifyListeners();
  }

  void pop() {
    assert(stack.isNotEmpty, "Routes list is empty");
    _stack.removeLast();
    notifyListeners();
  }

  /// [pageKey]: key or class type
  void popUtil<K extends Key>(String pageType, [K? pageKey]) {
    var index = _stack.lastIndexWhere((widget) =>
    null != pageKey && null != widget.key
        ? widget.key == pageKey
        : widget.runtimeType.toString() == pageType);
    if (index != -1) {
      for (var i = _stack.length - 1; i > index; i--) {
        _stack.removeAt(i);
      }
      notifyListeners();
    }
  }

  void showDialog(
    Widget child, {
    bool crossPage = false,
    bool clickClose = false,
    bool allowClick = true,
    Color backgroundColor = const Color(0x80000000),
    bool ignoreContentClick = false,
  }) {
    var key = null != child.key ? child.key : ValueKey(child.runtimeType);
    _stack.add(GenerateDialogDelegate(
      child,
      key: key,
      builder: DialogBuilder(
        clickClose: clickClose,
        crossPage: crossPage,
        allowClick: allowClick,
        backgroundColor: backgroundColor,
        ignoreContentClick: ignoreContentClick,
        dismissFunc: () => dismissDialog(key),
      ),
    ));
    notifyListeners();
  }

  void dismissDialog([Key? key]) {
    assert(stack.isNotEmpty, "Routes list is empty");
    var index = stack.lastIndexWhere((route) => null != key
        ? route.key == key
        : route.toStringShort() == 'GenerateDialogDelegate');
    if (index != -1) {
      _stack.removeAt(index);
      notifyListeners();
    }
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (_stack.isNotEmpty) {
      var typeName = null != _stack.last.key
          ? _stack.last.key.toString()
          : _stack.last.runtimeType.toString();
      if (typeName == route.settings.name) {
        _stack.remove(route.settings.name);
        notifyListeners();
      }
    }
    return route.didPop(result);
  }

  @override
  Future<void> setInitialRoutePath(String configuration) {
    return setNewRoutePath(configuration);
  }

  @override
  Future<void> setNewRoutePath(String configuration) {
    _stack
      ..clear()
      ..add(onGeneratePage);
    return SynchronousFuture<void>(null);
  }

  @override
  Widget build(BuildContext context) {
    print('${describeIdentity(this)}.stack: $_stack');
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      pages: _stack
          .map((widget) => NavtPage(
                widget,
                name: null != widget.key
                    ? widget.key.toString()
                    : widget.runtimeType.toString(),
                // key:  ValueKey(widget.key),
              ))
          .toList(),
    );
  }
}
