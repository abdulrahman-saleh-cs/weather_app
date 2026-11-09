import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/app_colors.dart';
import 'package:weather_app/core/theme/app_dimensions.dart';
import 'package:weather_app/features/weather/presentation/pages/weather/widgets/next_forecast_card.dart';
import 'package:weather_app/features/weather/presentation/pages/weather/widgets/weather_header.dart';
import 'package:weather_app/features/weather/presentation/pages/weather/widgets/weather_metrics_bar.dart';

import 'current_weather_section.dart';
import 'hourly_forecast_card.dart';

class WeatherBody extends StatelessWidget {
  const WeatherBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.primaryBlue,
            AppColors.primaryLightBlue,
          ],
        ),
      ),
      child: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.p20),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              spacing: AppDimensions.p20,
              children: [
                WeatherHeader(),
                CurrentWeatherSection(),
                WeatherMetricsBar(),
                HourlyForecastCard(),
                NextForecastCard()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
