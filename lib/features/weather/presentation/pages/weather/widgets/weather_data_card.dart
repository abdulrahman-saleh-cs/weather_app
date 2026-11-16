import 'package:flutter/material.dart';
import 'package:weather_app/core/weather_ui/weather_ui.dart';

/// Frosted-glass card used by every section of the screen.
class WeatherDataCard extends StatelessWidget {
  const WeatherDataCard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: GlassCard(child: child),
      );
}
