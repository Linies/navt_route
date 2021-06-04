import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// [TransitionSlideRoute]页面路由以及过渡动画实现.
/// [DialogSlideRoute]弹窗路由以及过渡动画实现.
/// Created by linzhihan on 4/19/21.
class TransitionSlideRoute extends PageRouteBuilder {
  final Widget widget;

  TransitionSlideRoute(this.widget, {RouteSettings? settings})
      : super(
      settings: settings,
      // 设置过度时间
      transitionDuration: Duration(seconds: 1),
      // 构造器
      pageBuilder: (
          // 上下文和动画
          BuildContext context,
          Animation<double> animaton1,
          Animation<double> animaton2,
          ) {
        return widget;
      },
      transitionsBuilder: (
          BuildContext context,
          Animation<double> animaton1,
          Animation<double> animaton2,
          Widget child,
          ) {
        // 需要什么效果把注释打开就行了
        // 渐变效果
        // return FadeTransition(
        //   // 从0开始到1
        //   opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        //     // 传入设置的动画
        //     parent: animaton1,
        //     // 设置效果，快进漫出   这里有很多内置的效果
        //     curve: Curves.fastOutSlowIn,
        //   )),
        //   child: child,
        // );

        // 缩放动画效果
        // return ScaleTransition(
        //   scale: Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(
        //     parent: animaton1,
        //     curve: Curves.fastOutSlowIn
        //   )),
        //   child: child,
        // );

        // 旋转加缩放动画效果
        // return RotationTransition(
        //   turns: Tween(begin: 0.0,end: 1.0)
        //   .animate(CurvedAnimation(
        //     parent: animaton1,
        //     curve: Curves.fastOutSlowIn,
        //   )),
        //   child: ScaleTransition(
        //     scale: Tween(begin: 0.0,end: 1.0)
        //     .animate(CurvedAnimation(
        //       parent: animaton1,
        //       curve: Curves.fastOutSlowIn
        //     )),
        //     child: child,
        //   ),
        // );

        // 左右滑动动画效果
        return SlideTransition(
          position: Tween<Offset>(
            // 设置滑动的 X , Y 轴
            begin: Offset(-1.0, 0.0),
            end: Offset(0.0,0.0)
          ).animate(CurvedAnimation(
            parent: animaton1,
            curve: Curves.fastOutSlowIn
          )),
          child: child,
        );
      });
}

class DialogSlideRoute extends PopupRoute {
  DialogSlideRoute({
    required RoutePageBuilder pageBuilder,
    bool barrierDismissible = true,
    String? barrierLabel,
    Color barrierColor = const Color(0x80000000),
    Duration transitionDuration = const Duration(milliseconds: 200),
    RouteTransitionsBuilder? transitionBuilder,
    RouteSettings? settings,
  })  : widget = pageBuilder,
        name = "DIALOG: ${pageBuilder.hashCode}",
        _barrierDismissible = barrierDismissible,
        _barrierLabel = barrierLabel!,
        _barrierColor = barrierColor,
        _transitionDuration = transitionDuration,
        super(settings: settings);

  final RoutePageBuilder widget;

  @override
  bool get barrierDismissible => _barrierDismissible;
  final bool _barrierDismissible;

  final String name;

  @override
  String get barrierLabel => _barrierLabel;
  final String _barrierLabel;

  @override
  Color get barrierColor => _barrierColor;
  final Color _barrierColor;

  @override
  Duration get transitionDuration => _transitionDuration;
  final Duration _transitionDuration;

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

    return FadeTransition(
      // 从0开始到1
      opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        // 传入设置的动画
        parent: animation,
        // 设置效果，快进漫出   这里有很多内置的效果
        curve: Curves.fastOutSlowIn,
      )),
      child: child,
    );
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