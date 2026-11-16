import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weather_app/core/core.dart';
import '../../../manager/manager.dart';
import '../../../mappers/weather_ui_mapper.dart';
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
        if (state is WeatherSuccess) return _Content(state: state);

        // Loading / error / initial: night background + message.
        return Stack(fit: StackFit.expand, children: [
          AnimatedWeatherBackground(theme: themeFor(WeatherCondition.clear, DayPhase.night)),
          Center(
            child: state is WeatherFailure
                ? Column(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.cloud_off_rounded, size: 64, color: Colors.white70),
                    const SizedBox(height: 12),
                    Text(state.errMessage, textAlign: TextAlign.center, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: Accent.coral),
                      onPressed: context.read<WeatherCubit>().retry,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry'),
                    ),
                  ])
                : const CircularProgressIndicator(color: Colors.white),
          ),
        ]);
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.state});
  final WeatherSuccess state;

  @override
  Widget build(BuildContext context) {
    final weather = state.weather;
    final hour = weather.hourlyForecast[state.selectedHour];

    // Wind is only known for "now", so only the current hour can become "windy".
    final nowHour = DateTime.now().hour;
    final isNowSelected = hourOf(hour.time) == nowHour;
    final condition = hour.conditionAt(windKmh: isNowSelected ? weather.windSpeed : 0);
    final theme = themeFor(condition, hour.phase);

    return Stack(fit: StackFit.expand, children: [
      AnimatedWeatherBackground(theme: theme),
      SafeArea(
        child: RefreshIndicator(
          color: Accent.coral,
          backgroundColor: Colors.white,
          onRefresh: context.read<WeatherCubit>().refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.fromLTRB(AppDimensions.p20, 10, AppDimensions.p20, 28),
            child: Column(
              spacing: AppDimensions.p16,
              children: [
                WeatherHeader(cityName: weather.cityName),
                CurrentWeatherSection(
                  condition: condition,
                  isNight: hour.isNight,
                  currentDegree: hour.temperature.round(),
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
                  onSelected: context.read<WeatherCubit>().selectHour,
                  selectedIndex: state.selectedHour,
                ),
                NextForecastCard(days: weather.dailyForecast),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
