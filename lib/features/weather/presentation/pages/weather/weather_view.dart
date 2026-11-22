import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/cities/cities.dart';
import 'package:weather_app/features/weather/weather.dart';
import 'package:weather_app/core/services/services.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<WeatherCubit>()),
        BlocProvider(create: (_) => getIt<CitiesCubit>()..load()),
      ],
      // Whenever the selected city changes (first load, or picked by the user),
      // load the weather for it.
      child: BlocListener<CitiesCubit, CitiesState>(
        listenWhen: (previous, current) =>
            current.selected != null && previous.selected != current.selected,
        listener: (context, state) {
          final city = state.selected!;
          context.read<WeatherCubit>().getWeather(
                lat: city.latitude,
                lon: city.longitude,
                cityName: city.name,
              );
        },
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          child: const Scaffold(
            body: WeatherBody(),
          ),
        ),
      ),
    );
  }
}
