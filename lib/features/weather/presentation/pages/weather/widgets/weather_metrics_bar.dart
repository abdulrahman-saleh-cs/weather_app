import 'package:flutter/material.dart';
import 'package:weather_app/core/weather_ui/weather_ui.dart';
import 'weather_metric_item.dart';

class WeatherMetricsBar extends StatelessWidget {
  const WeatherMetricsBar({
    super.key,
    required this.precipitationChance,
    required this.humidity,
    required this.windSpeed,
  });

  final int precipitationChance;
  final int humidity;
  final double windSpeed;

  @override
  Widget build(BuildContext context) => Row(spacing: 10, children: [
        WeatherMetricItem(icon: Icons.umbrella_rounded, value: '$precipitationChance%', label: 'Rain', color: Accent.sky),
        WeatherMetricItem(icon: Icons.water_drop_rounded, value: '$humidity%', label: 'Humidity', color: Accent.teal),
        WeatherMetricItem(icon: Icons.air_rounded, value: '${windSpeed.round()} km/h', label: 'Wind', color: Accent.amber),
      ]);
}
