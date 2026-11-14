import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:weather_app/core/core.dart';
import 'package:weather_app/features/weather/domain/domain.dart';

import 'hourly_item_widget.dart';
import 'weather_data_card.dart';

class HourlyForecastCard extends StatelessWidget {
  final List<HourlyForecastEntity> hours;

  const HourlyForecastCard({super.key, required this.hours});

  @override
  Widget build(BuildContext context) {
    final nowHour = DateTime.now().hour;

    // Find the current hour index (if not found, use 0)
    var currentIndex = hours.indexWhere(
      (h) => int.parse(h.time.split(':').first) == nowHour,
    );
    if (currentIndex == -1) currentIndex = 0;

    // Start from two hours before current, staying within list bounds
    final start = (currentIndex - 2).clamp(0, hours.length - 4);
    final visibleHours = hours.skip(start).take(4).toList();

    return WeatherDataCard(
      child: Column(
        spacing: AppDimensions.p10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Today',
                style: AppTextStyles.titleLarge,
              ),
              Text(
                DateFormat('MMM, d').format(DateTime.now()),
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: visibleHours.map((hour) {
              final hourNumber = int.parse(hour.time.split(':').first);

              return HourlyItemWidget(
                temperature: '${hour.temperature.round()}°',
                image: hour.image,
                time: hour.time.replaceAll(':', '.'),
                isNow: hourNumber == nowHour,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
