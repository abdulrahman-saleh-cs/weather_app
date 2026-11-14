import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weather_app/core/core.dart';
import '../../../manager/manager.dart';
import 'current_weather_section.dart';
import 'hourly_forecast_card.dart';
import 'next_forecast_card.dart';
import 'weather_header.dart';
import 'weather_metrics_bar.dart';

class WeatherBody extends StatelessWidget {
  const WeatherBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state is WeatherSuccess) {
          final weather = state.weather;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: WeatherBackground.gradient(
                weather.weatherCode,
                isDay: weather.isDay,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppDimensions.p20),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    spacing: AppDimensions.p20,
                    children: [
                      WeatherHeader(cityName: weather.cityName,),
                      CurrentWeatherSection(
                        image: weather.image,
                        condition: weather.condition,
                        currentDegree: weather.temperature.round(),
                        maxDegree: weather.tempMax.round(),
                        minDegree: weather.tempMin.round(),
                      ),
                      WeatherMetricsBar(
                        precipitationChance: weather.rainChance,
                        humidity: weather.humidity,
                        windSpeed: weather.windSpeed,
                      ),
                      HourlyForecastCard(
                        hours: weather.hourlyForecast,
                      ),
                      NextForecastCard(days: weather.dailyForecast),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
