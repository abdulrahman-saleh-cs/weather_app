import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 1. Import services
import 'package:weather_app/features/weather/presentation/pages/weather/widgets/weather_body.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Wrap Scaffold with AnnotatedRegion
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Make status bar transparent
        statusBarIconBrightness: Brightness.light, // White icons for Android
        statusBarBrightness: Brightness.dark, // White icons for iOS
      ),
      child: Scaffold(
        body: WeatherBody(),
      ),
    );
  }
}