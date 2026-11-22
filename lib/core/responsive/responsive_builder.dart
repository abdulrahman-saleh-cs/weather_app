import 'package:flutter/widgets.dart';
import 'breakpoints.dart';

/// Picks a builder from the width this widget is given (no MediaQuery),
/// and exposes the resulting [ScreenType] to its subtree via [ResponsiveScope].
///
/// [tablet] falls back to [mobile]; [desktop] falls back to [tablet].
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final type = Breakpoints.fromWidth(constraints.maxWidth);
        final WidgetBuilder builder = switch (type) {
          ScreenType.mobile => mobile,
          ScreenType.tablet => tablet ?? mobile,
          ScreenType.desktop => desktop ?? tablet ?? mobile,
        };
        return ResponsiveScope(screenType: type, child: Builder(builder: builder));
      },
    );
  }
}

/// Provides the current [ScreenType] to descendants of a [ResponsiveBuilder].
class ResponsiveScope extends InheritedWidget {
  const ResponsiveScope({super.key, required this.screenType, required super.child});

  final ScreenType screenType;

  static ScreenType of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ResponsiveScope>();
    assert(scope != null, 'No ResponsiveScope found. Wrap the screen in a ResponsiveBuilder.');
    return scope!.screenType;
  }

  @override
  bool updateShouldNotify(ResponsiveScope oldWidget) => oldWidget.screenType != screenType;
}

extension ResponsiveContext on BuildContext {
  /// The current [ScreenType]. Requires an ancestor [ResponsiveBuilder].
  ScreenType get screenType => ResponsiveScope.of(this);
}
