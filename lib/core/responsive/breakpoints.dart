/// Device class derived from the width the screen is given.
enum ScreenType { mobile, tablet, desktop }

/// Single source of truth for responsive breakpoints (logical pixels).
abstract final class Breakpoints {
  static const double tablet = 700;
  static const double desktop = 1100;

  static ScreenType fromWidth(double width) {
    if (width >= desktop) return ScreenType.desktop;
    if (width >= tablet) return ScreenType.tablet;
    return ScreenType.mobile;
  }
}
