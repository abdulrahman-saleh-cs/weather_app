import 'package:flutter/material.dart';
import 'package:weather_app/features/weather/presentation/pages/weather/widgets/weather_data_card.dart';
import 'package:weather_app/features/weather/presentation/pages/weather/widgets/weather_metric_item.dart';

class WeatherMetricsBar extends StatelessWidget {
  const WeatherMetricsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const WeatherDataCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WeatherMetricItem(
            iconPath: 'assets/icons/noun-rain.svg',
            label: '6%',
          ),
          WeatherMetricItem(
            iconPath: 'assets/icons/noun-humidity.svg',
            label: '90%',
          ),
          WeatherMetricItem(
            iconPath: 'assets/icons/noun-wind.svg',
            label: '19 km/h',
          ),
        ],
      ),
    );
  }
}
