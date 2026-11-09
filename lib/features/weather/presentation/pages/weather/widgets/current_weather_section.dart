import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/app_colors.dart';
import 'package:weather_app/core/theme/app_dimensions.dart';
import 'package:weather_app/core/theme/app_text_styles.dart';

class CurrentWeatherSection extends StatelessWidget {
  const CurrentWeatherSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/sun_cloud_angled_rain.png',
          height: 170,
          fit: BoxFit.contain,
        ),
        const Text(
          '28°',
          style: AppTextStyles.displayLarge,
        ),
        AppDimensions.h8,
        const Text(
          'Precipitations',
          style: AppTextStyles.bodyMedium,
        ),
        const Text(
          'Max.: 31° Min.: 25°',
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}
