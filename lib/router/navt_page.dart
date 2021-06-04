import 'package:flutter/widgets.dart';

import 'tran_slide_route.dart';

/// Navigator2.0 Page.
/// Created by linzhihan on 4/19/21.
class NavtPage extends Page {
  const NavtPage(
    this.child, {
    LocalKey? key,
    String? name,
  }) : super(
          key: key,
          name: name,
        );

  final Widget child;

  @override
  Route createRoute(BuildContext context) {
    if (child.toStringShort() == 'GenerateDialogDelegate') {
      return DialogSlideRoute(
        settings: this,
        pageBuilder: (context, animation1, animation2) => child,
      );
    } else {
      return TransitionSlideRoute(
        child,
        settings: this,
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