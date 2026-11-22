import 'package:flutter/material.dart';
import 'weather_dashboard.dart';
import 'weather_layout_metrics.dart';
import 'weather_scroll_view.dart';

/// Fixed sidebar + scrollable two-column dashboard, centred on very wide windows.
class WeatherDesktopLayout extends StatelessWidget {
  const WeatherDesktopLayout({
    super.key,
    required this.onRefresh,
    required this.sidebar,
    required this.header,
    required this.hero,
    required this.metrics,
    required this.hourly,
    required this.daily,
  });

  final Future<void> Function() onRefresh;
  final Widget sidebar, header, hero, metrics, hourly, daily;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: context.layoutMetrics.maxContentWidth),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            sidebar,
            Expanded(
              child: WeatherScrollView(
                onRefresh: onRefresh,
                child: WeatherDashboard(header: header, hero: hero, metrics: metrics, hourly: hourly, daily: daily),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
