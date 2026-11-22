import 'package:flutter/widgets.dart';
import 'package:weather_app/core/core.dart';

/// Every size / count that changes between mobile, tablet and desktop.
/// Widgets read these instead of hardcoding per-screen numbers.
@immutable
class WeatherLayoutMetrics {
  const WeatherLayoutMetrics._({
    required this.pagePadding,
    required this.sectionSpacing,
    required this.columnSpacing,
    required this.heroIconSize,
    required this.tempFontSize,
    required this.forecastDays,
    this.hourlyCount,
    this.sidebarWidth = 0,
    this.maxContentWidth = double.infinity,
  });

  final EdgeInsets pagePadding;
  final double sectionSpacing;
  final double columnSpacing;
  final double heroIconSize;
  final double tempFontSize;

  /// Number of upcoming days shown in "Next Forecast".
  final int forecastDays;

  /// Hour slots shown side by side. `null` = horizontally scrollable list.
  final int? hourlyCount;

  final double sidebarWidth;
  final double maxContentWidth;

  double get degreeFontSize => tempFontSize * .5;
  double get degreeTopPadding => tempFontSize * .15;
  double get tempLetterSpacing => -tempFontSize * .045;

  static const _mobile = WeatherLayoutMetrics._(
    pagePadding: EdgeInsets.fromLTRB(AppDimensions.p20, 10, AppDimensions.p20, 28),
    sectionSpacing: AppDimensions.p16,
    columnSpacing: 0,
    heroIconSize: 180,
    tempFontSize: 92,
    forecastDays: 3,
  );

  static const _tablet = WeatherLayoutMetrics._(
    pagePadding: EdgeInsets.fromLTRB(30, 16, 30, 28),
    sectionSpacing: AppDimensions.p16,
    columnSpacing: 24,
    heroIconSize: 150,
    tempFontSize: 100,
    forecastDays: 4,
    hourlyCount: 6,
  );

  static const _desktop = WeatherLayoutMetrics._(
    pagePadding: EdgeInsets.fromLTRB(24, 12, 26, 24),
    sectionSpacing: 18,
    columnSpacing: 26,
    heroIconSize: 210,
    tempFontSize: 128,
    forecastDays: 5,
    hourlyCount: 8,
    sidebarWidth: 230,
    maxContentWidth: 1440,
  );

  static WeatherLayoutMetrics forScreen(ScreenType type) => switch (type) {
        ScreenType.mobile => _mobile,
        ScreenType.tablet => _tablet,
        ScreenType.desktop => _desktop,
      };
}

extension WeatherLayoutContext on BuildContext {
  WeatherLayoutMetrics get layoutMetrics => WeatherLayoutMetrics.forScreen(screenType);
}
