import 'package:flutter/material.dart';
import 'weather_dashboard.dart';
import 'weather_scroll_view.dart';

/// Two columns inside a scroll view.
class WeatherTabletLayout extends StatelessWidget {
  const WeatherTabletLayout({
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
      child: WeatherDashboard(header: header, hero: hero, metrics: metrics, hourly: hourly, daily: daily),
    );
  }
}
