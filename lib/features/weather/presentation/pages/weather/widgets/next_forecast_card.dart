import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/core/core.dart';
import 'package:weather_app/features/weather/domain/domain.dart';
import '../../../mappers/weather_ui_mapper.dart';
import 'forecast_day_row.dart';
import 'weather_data_card.dart';

class NextForecastCard extends StatelessWidget {
  const NextForecastCard({super.key, required this.days});
  final List<DailyForecastEntity> days;

  @override
  Widget build(BuildContext context) {
    final next = days.skip(1).take(3).toList();
    final lo = next.map((d) => d.minTemp).reduce(math.min);
    final hi = next.map((d) => d.maxTemp).reduce(math.max);
    return WeatherDataCard(
      child: Column(
        spacing: AppDimensions.p10,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Next Forecast', style: AppTextStyles.titleLarge),
              Icon(Icons.calendar_month_rounded, color: Colors.white70, size: AppDimensions.iconS),
            ],
          ),
          for (final day in next)
            ForecastDayRow(
              day: DateFormat('EEEE').format(DateTime.parse(day.day)),
              condition: day.condition,
              maxTemperature: day.maxTemp,
              minTemperature: day.minTemp,
              rangeMin: lo,
              rangeMax: hi,
            ),
        ],
      ),
    );
  }
}
