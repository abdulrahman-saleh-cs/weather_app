import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather_app/core/theme/app_colors.dart';
import 'package:weather_app/core/theme/app_dimensions.dart';
import 'package:weather_app/core/theme/app_text_styles.dart';
import 'package:weather_app/features/weather/presentation/pages/weather/widgets/weather_data_card.dart';
import 'forecast_day_row.dart';

class NextForecastCard extends StatelessWidget {
  const NextForecastCard({super.key});

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
                'assets/icons/calendar.svg',
                width: AppDimensions.iconS,
                height: AppDimensions.iconS,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          const Column(
            spacing: AppDimensions.p10,
            children: [
              ForecastDayRow(
                maxTemperature: 13,
                minTemperature: 10,
                image: 'assets/images/big_rain_drops.png',
                day: 'Monday',
              ),
              ForecastDayRow(
                maxTemperature: 17,
                minTemperature: 12,
                image: 'assets/images/cloud_3_zap.png',
                day: 'Tuesday',
              ),
              ForecastDayRow(
                maxTemperature: 14,
                minTemperature: 11,
                image: 'assets/images/big_rain_drops.png',
                day: 'Wednesday',
              ),
            ],
          )
        ],
      ),
    );
  }
}
