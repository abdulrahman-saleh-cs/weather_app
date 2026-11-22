import 'package:flutter/material.dart';
import 'weather_layout_metrics.dart';

/// Header on top, then two columns:
/// left = current weather + metrics, right = hourly + next days.
/// Shared by the tablet and desktop layouts.
class WeatherDashboard extends StatelessWidget {
  const WeatherDashboard({
    super.key,
    required this.header,
    required this.hero,
    required this.metrics,
    required this.hourly,
    required this.daily,
  });

  final Widget header, hero, metrics, hourly, daily;

  @override
  Widget build(BuildContext context) {
    final m = context.layoutMetrics;
    return Column(
      spacing: m.sectionSpacing,
      children: [
        header,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: m.columnSpacing,
          children: [
            Expanded(flex: 20, child: Column(spacing: m.sectionSpacing, children: [hero, metrics])),
            Expanded(flex: 23, child: Column(spacing: m.sectionSpacing, children: [hourly, daily])),
          ],
        ),
      ],
    );
  }
}
