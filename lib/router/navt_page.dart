import 'package:flutter/widgets.dart';

import 'tran_slide_route.dart';

/// Navigator2.0 Page.
/// Created by linzhihan on 4/19/21.
class NavtPage extends Page {
  final RouteTransitionsBuilder? transitionsBuilder;
  final DefaultTransition? defaultTransition;

  const NavtPage(
      this.child, {
        LocalKey? key,
        String? name,
        this.transitionsBuilder,
        this.defaultTransition = DefaultTransition.SlideTransition,
      }) : super(
    key: key,
    name: name,
  );

  final Widget child;

  @override
  Route createRoute(BuildContext context) {
    if (child.toStringShort() == 'GenerateDialogDelegate') {
      return null != transitionsBuilder
          ? DialogSlideRoute(
        settings: this,
        pageBuilder: (context, animation1, animation2) => child,
        transitionBuilder: transitionsBuilder!,
      )
          : DialogSlideRoute.transition(
        settings: this,
        pageBuilder: (context, animation1, animation2) => child,
        transition: defaultTransition,
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

class GenerateDialogDelegate extends StatelessWidget {
  final Widget child;

  GenerateDialogDelegate(this.child);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
