import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'navt_page.dart';

/// Navigator2.0 Router
/// Created by linzhihan on 4/19/21.
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

  void popUtil(String pageName) {
    var index =
    stack.lastIndexWhere((route) => route.toStringShort() == pageName);
    if (index != -1) {
      stack.removeAt(index);
      notifyListeners();
    }
  }

  void showDialog(Widget child) {
    _stack.add(GenerateDialogDelegate(
      child,
      key: ValueKey(null != child.key ? child.key : child.runtimeType),
    ));
    notifyListeners();
  }

  void dismissDialog() {
    assert(stack.isNotEmpty, "Routes list is empty");
    var index = stack.lastIndexWhere(
            (route) => route.toStringShort() == 'GenerateDialogDelegate');
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
                key: ValueKey(widget.key ?? widget.runtimeType),
              ))
          .toList(),
    );
  }
}
