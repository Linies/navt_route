import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// [TransitionSlideRoute]页面路由以及过渡动画实现.
/// [DialogSlideRoute]弹窗路由以及过渡动画实现.
/// Created by linzhihan on 4/19/21.
enum DefaultTransition {
  FadeTransition,
  ScaleTransition,
  RotationTransition,
  SlideTransition,
}

class TransitionSlideRoute extends PageRouteBuilder {
  final Widget widget;

  TransitionSlideRoute(this.widget, RouteTransitionsBuilder transitionsBuilder,
      {RouteSettings? settings})
      : super(
      settings: settings,
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2,
          ) {
        return widget;
      },
      transitionsBuilder: transitionsBuilder);

  TransitionSlideRoute.transition(this.widget,
      {DefaultTransition? transition = DefaultTransition.SlideTransition,
        RouteSettings? settings})
      : super(
      settings: settings,
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2,
          ) {
        return widget;
      },
      transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
          ) {
        switch (transition) {
          case DefaultTransition.FadeTransition:
            return AnimatedTransition.fade(
                child: child, parent: animation);
          case DefaultTransition.RotationTransition:
            return AnimatedTransition.rotation(
                child: child, parent: animation);
          case DefaultTransition.ScaleTransition:
            return AnimatedTransition.scale(
                child: child, parent: animation);
          case DefaultTransition.SlideTransition:
          default:
            return AnimatedTransition.slide(
                child: child, parent: animation);
        }
      });
}

class DialogSlideRoute extends PopupRoute {
  DialogSlideRoute({
    required RoutePageBuilder pageBuilder,
    required RouteTransitionsBuilder transitionBuilder,
    bool barrierDismissible = true,
    String? barrierLabel,
    Color barrierColor = const Color(0x80000000),
    Duration transitionDuration = const Duration(milliseconds: 500),
    RouteSettings? settings,
  })  : widget = pageBuilder,
        name = "DIALOG: ${pageBuilder.hashCode}",
        _barrierDismissible = barrierDismissible,
        _barrierLabel = barrierLabel,
        _barrierColor = barrierColor,
        _transitionDuration = transitionDuration,
        _transitionBuilder = transitionBuilder,
        _transition = null,
        super(settings: settings);

  DialogSlideRoute.transition({
    required RoutePageBuilder pageBuilder,
    bool barrierDismissible = true,
    String? barrierLabel,
    Color barrierColor = const Color(0x80000000),
    Duration transitionDuration = const Duration(milliseconds: 500),
    RouteSettings? settings,
    DefaultTransition? transition = DefaultTransition.SlideTransition,
  })  : widget = pageBuilder,
        name = "DIALOG: ${pageBuilder.hashCode}",
        _barrierDismissible = barrierDismissible,
        _barrierLabel = barrierLabel,
        _barrierColor = barrierColor,
        _transitionDuration = transitionDuration,
        _transitionBuilder = null,
        _transition = transition,
        super(settings: settings);

  final RoutePageBuilder widget;

  @override
  bool get barrierDismissible => _barrierDismissible;
  final bool _barrierDismissible;

  final String name;

  @override
  String? get barrierLabel => _barrierLabel;
  final String? _barrierLabel;

  @override
  Color get barrierColor => _barrierColor;
  final Color _barrierColor;

  @override
  Duration get transitionDuration => _transitionDuration;
  final Duration _transitionDuration;

  final RouteTransitionsBuilder? _transitionBuilder;

  final DefaultTransition? _transition;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Semantics(
      child: widget(context, animation, secondaryAnimation),
      scopesRoute: true,
      explicitChildNodes: true,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    assert(null != _transitionBuilder || null != _transition);
    return null != _transitionBuilder
        ? _transitionBuilder
        : () {
      switch (_transition) {
        case DefaultTransition.FadeTransition:
          return AnimatedTransition.fade(child: child, parent: animation);
        case DefaultTransition.RotationTransition:
          return AnimatedTransition.rotation(
              child: child, parent: animation);
        case DefaultTransition.ScaleTransition:
          return AnimatedTransition.scale(
              child: child, parent: animation);
        case DefaultTransition.SlideTransition:
        default:
          return AnimatedTransition.slide(
              child: child, parent: animation);
      }
    }();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class NavtRouteParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) {
    return SynchronousFuture(routeInformation.location!);
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    return RouteInformation(location: configuration);
  }
}

/// 转场动画
extension AnimatedTransition on AnimatedWidget {
  static fade({required Widget child, required Animation<double> parent}) {
    return FadeTransition(
      opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: parent,
        curve: Curves.fastOutSlowIn,
      )),
      child: child,
    );
  }

  static scale({required Widget child, required Animation<double> parent}) {
    return ScaleTransition(
      scale: Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: parent, curve: Curves.fastOutSlowIn)),
      child: child,
    );
  }

  static rotation({required Widget child, required Animation<double> parent}) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: parent,
        curve: Curves.fastOutSlowIn,
      )),
      child: ScaleTransition(
        scale: Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: parent, curve: Curves.fastOutSlowIn)),
        child: child,
      ),
    );
  }

  static slide({required Widget child, required Animation<double> parent}) {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
          .animate(
          CurvedAnimation(parent: parent, curve: Curves.fastOutSlowIn)),
      child: child,
    );
  }
}
