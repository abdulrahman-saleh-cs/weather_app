import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/weather/weather.dart';
import 'package:weather_app/core/services/services.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Wrap Scaffold with AnnotatedRegion
    return BlocProvider(
      create: (context) => getIt<WeatherCubit>()..getWeather(lat: 32.11486, lon: 20.06859), // Benghazi// Benghazi


      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Make status bar transparent
          statusBarIconBrightness: Brightness.light, // White icons for Android
          statusBarBrightness: Brightness.dark, // White icons for iOS
        ),
        child:Scaffold(
            body: WeatherBody(),
          ),
        ),

    );
  }
}