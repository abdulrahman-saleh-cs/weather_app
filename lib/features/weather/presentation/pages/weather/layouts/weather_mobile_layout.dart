import 'package:flutter/material.dart';
import 'weather_layout_metrics.dart';
import 'weather_scroll_view.dart';

/// Single column, the original phone layout.
class WeatherMobileLayout extends StatelessWidget {
  const WeatherMobileLayout({
    super.key,
    required this.onRefresh,
    required this.header,
    required this.hero,
    required this.metrics,
    required this.hourly,
    required this.daily,
  });

  final Future<void> Function() onRefresh;
  final Widget header, hero, metrics, hourly, daily;

  @override
  Widget build(BuildContext context) {
    return WeatherScrollView(
      onRefresh: onRefresh,
      child: Column(
        spacing: context.layoutMetrics.sectionSpacing,
        children: [header, hero, metrics, hourly, daily],
      ),
    );
  }
}
