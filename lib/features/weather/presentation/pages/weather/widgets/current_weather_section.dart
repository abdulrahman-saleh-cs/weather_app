import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/theme.dart';

class CurrentWeatherSection extends StatelessWidget {
  const CurrentWeatherSection({super.key, required this.currentDegree, required this.maxDegree, required this.minDegree, required this.condition, required this.image});
  final String image;
  final String condition;
  final int currentDegree;
  final int maxDegree;
  final int minDegree;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          image,
         // 'assets/images/weather_icons/heavy_rain.png',
          height: 150,
          fit: BoxFit.cover,
        ),
        AppDimensions.h8,
        Text(
          '$currentDegree°',
          style: AppTextStyles.displayLarge,
        ),
        AppDimensions.h8,
         Text(
          condition,
          style: AppTextStyles.bodyMedium,
        ),
         Text(
          'Max.: $maxDegree° Min.: $minDegree°',
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}
