import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/theme.dart';
import 'package:weather_app/features/weather/presentation/pages/weather/weather.dart';
import 'core/services/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUp();
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
