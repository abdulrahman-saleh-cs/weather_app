import 'package:flutter/material.dart';
import 'package:weather_app/features/weather/presentation/pages/weather/widgets/weather_data_card.dart';
import 'package:weather_app/features/weather/presentation/pages/weather/widgets/weather_metric_item.dart';
import '../../../../../../core/constants/constants.dart';

class WeatherMetricsBar extends StatelessWidget {
  const WeatherMetricsBar({
    super.key,
    required this.precipitationChance,
    required this.humidity,
    required this.windSpeed,
  });

  final int precipitationChance; // 6
  final int humidity; // 90
  final double windSpeed; // 19

  @override
  Widget build(BuildContext context) {
    return WeatherDataCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WeatherMetricItem(
            iconPath: AppIcons.rain,
            label: '$precipitationChance%',
          ),
          WeatherMetricItem(
            iconPath: AppIcons.humidity,
            label: '$humidity%',
          ),
          WeatherMetricItem(
            iconPath: AppIcons.wind,
            label: '${windSpeed.round()} km/h',
          ),
        ],
      ),
    );
  }
}