import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weather_app/core/core.dart';
import 'package:weather_app/features/cities/cities.dart';
import '../../../manager/manager.dart';
import '../../../mappers/weather_ui_mapper.dart';
import '../layouts/layouts.dart';
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
    final cubit = context.read<WeatherCubit>();

    // Wind is only known for "now", so only the current hour can become "windy".
    final nowHour = DateTime.now().hour;
    final isNowSelected = hourOf(hour.time) == nowHour;
    final condition = hour.conditionAt(windKmh: isNowSelected ? weather.windSpeed : 0);
    final theme = themeFor(condition, hour.phase);

    // Sections are built once; each layout only decides where they go.
    final hero = CurrentWeatherSection(
      condition: condition,
      isNight: hour.isNight,
      currentDegree: hour.temperature.round(),
      maxDegree: weather.tempMax.round(),
      minDegree: weather.tempMin.round(),
    );
    final metrics = WeatherMetricsBar(
      precipitationChance: weather.rainChance,
      humidity: weather.humidity,
      windSpeed: weather.windSpeed,
    );
    final hourly = HourlyForecastCard(
      hours: weather.hourlyForecast,
      onSelected: cubit.selectHour,
      selectedIndex: state.selectedHour,
    );
    final daily = NextForecastCard(days: weather.dailyForecast);
    // Mouse users cannot pull to refresh, so wide layouts get a refresh button.
    final openCities = () => CitiesView.open(context);
    final wideHeader = WeatherHeader(
      cityName: weather.cityName,
      onCityTap: openCities,
      onRefreshTap: cubit.refresh,
    );

    return Stack(fit: StackFit.expand, children: [
      AnimatedWeatherBackground(theme: theme),
      SafeArea(
        child: ResponsiveBuilder(
          mobile: (_) => WeatherMobileLayout(
            onRefresh: cubit.refresh,
            header: WeatherHeader(cityName: weather.cityName, onCityTap: openCities),
            hero: hero,
            metrics: metrics,
            hourly: hourly,
            daily: daily,
          ),
          tablet: (_) => WeatherTabletLayout(
            onRefresh: cubit.refresh,
            header: wideHeader,
            hero: hero,
            metrics: metrics,
            hourly: hourly,
            daily: daily,
          ),
          desktop: (_) => WeatherDesktopLayout(
            onRefresh: cubit.refresh,
            sidebar: WeatherSidebar(
              cityName: weather.cityName,
              temperature: hour.temperature.round(),
              condition: condition,
              isNight: hour.isNight,
            ),
            header: wideHeader,
            hero: hero,
            metrics: metrics,
            hourly: hourly,
            daily: daily,
          ),
        ),
      ),
    ]);
  }
}
