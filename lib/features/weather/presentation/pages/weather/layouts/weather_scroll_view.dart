import 'package:flutter/material.dart';
import 'package:weather_app/core/core.dart';
import 'weather_layout_metrics.dart';

/// Pull-to-refresh + scrolling + responsive page padding.
class WeatherScrollView extends StatelessWidget {
  const WeatherScrollView({super.key, required this.onRefresh, required this.child});

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Accent.coral,
      backgroundColor: Colors.white,
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: context.layoutMetrics.pagePadding,
        child: child,
      ),
    );
  }
}
