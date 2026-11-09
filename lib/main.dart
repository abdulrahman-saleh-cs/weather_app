import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/app_theme.dart';
import 'package:weather_app/features/weather/presentation/pages/weather/weather_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const WeatherView(),
    );
  }
}
