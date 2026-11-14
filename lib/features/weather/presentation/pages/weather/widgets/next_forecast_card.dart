import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/core/core.dart';
import 'package:weather_app/features/weather/domain/domain.dart';
import 'forecast_day_row.dart';
import 'weather_data_card.dart';
class NextForecastCard extends StatelessWidget {
  final List<DailyForecastEntity> days;

  const NextForecastCard({super.key, required this.days});
  @override
  Widget build(BuildContext context) {
    return WeatherDataCard(
      child: Column(
        spacing: AppDimensions.p10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Next Forecast',
                style: AppTextStyles.titleLarge,
              ),
              SvgPicture.asset(
                AppIcons.calendar,
                width: AppDimensions.iconS,
                height: AppDimensions.iconS,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          Column(
            spacing: AppDimensions.p10,
            children: days.skip(1).take(3).map((day) {
              return ForecastDayRow(
                maxTemperature: day.maxTemp,
                minTemperature: day.minTemp,
                image: day.image,
                day: DateFormat('EEEE').format(DateTime.parse(day.day)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
