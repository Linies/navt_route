import 'package:flutter/widgets.dart';

import 'tran_slide_route.dart';

///Toast的关闭函数,调用将会提前关闭对应的Toast
typedef DismissFunc = void Function();

/// Navigator2.0 Page.
/// Created by linzhihan on 4/19/21.
class NavtPage extends Page {
  final RouteTransitionsBuilder? transitionsBuilder;
  final DefaultTransition? defaultTransition;

  const NavtPage(
      this.child, {
        LocalKey? key,
        String? name,
        Object? arguments,
        this.transitionsBuilder,
        this.defaultTransition = DefaultTransition.SlideTransition,
      }) : super(
    key: key,
    name: name,
    arguments: arguments,
  );

  final Widget child;

  @override
  Route createRoute(BuildContext context) {
    if (child.toStringShort() == 'GenerateDialogDelegate') {
      final delegate = child as GenerateDialogDelegate;
      return null != transitionsBuilder
          ? DialogSlideRoute(
              settings: this,
              pageBuilder: (context, animation1, animation2) => child,
              transitionBuilder: transitionsBuilder!,
              barrierColor:
                  delegate.builder?.backgroundColor ?? const Color(0x80000000),
            )
          : DialogSlideRoute.transition(
              settings: this,
              pageBuilder: (context, animation1, animation2) => child,
              transition: defaultTransition,
              barrierColor:
                  delegate.builder?.backgroundColor ?? const Color(0x80000000),
            );
    } else {
      return null != transitionsBuilder
          ? TransitionSlideRoute(
        child,
        transitionsBuilder!,
        settings: this,
      )
          : TransitionSlideRoute.transition(
        child,
        settings: this,
        transition: defaultTransition,
      );
    }
  }
}

class DialogBuilder {
  ///[crossPage] 跨越多个页面显示,
  bool crossPage;

  ///[clickClose] 是否在点击屏幕触发事件时自动关闭该Dialog
  bool clickClose;

  ///[allowClick] 是否在该Dialog显示时,能否正常点击触发事件
  bool allowClick;

  Color backgroundColor;

  ///[ignoreContentClick] 是否忽视ToastContext区域
  bool ignoreContentClick;

  DismissFunc? dismissFunc;

  DialogBuilder({
    Key? key,
    this.crossPage = false,
    this.clickClose = false,
    this.allowClick = true,
    this.backgroundColor = const Color(0x80000000),
    this.ignoreContentClick = false,
    this.dismissFunc,
  });
}

class GenerateDialogDelegate extends StatelessWidget {
  final Widget child;

  final DialogBuilder? builder;

  GenerateDialogDelegate(
    this.child, {
    Key? key,
    this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Listener(
          onPointerDown: (builder?.clickClose ?? false)
              ? (_) => builder?.dismissFunc?.call()
              : null,
          behavior: (builder?.allowClick ?? false)
              ? HitTestBehavior.translucent
              : HitTestBehavior.opaque,
          child: const SizedBox.expand(),
        ),
        IgnorePointer(
          ignoring: builder?.ignoreContentClick ?? false,
          child: child,
        )
      ],
    );
  }
}
