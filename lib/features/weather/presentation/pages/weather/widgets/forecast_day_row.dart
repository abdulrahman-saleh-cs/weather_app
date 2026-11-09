import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/app_dimensions.dart';
import 'package:weather_app/core/theme/app_text_styles.dart';
import 'package:weather_app/features/weather/presentation/pages/weather/widgets/degree_text.dart';

class ForecastDayRow extends StatelessWidget {
  final int maxTemperature;
  final int minTemperature;
  final String image;
  final String day;

  const ForecastDayRow({
    super.key,
    required this.maxTemperature,
    required this.minTemperature,
    required this.image,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            day,
            style: AppTextStyles.bodyMedium,
          ),
        ),
        Image.asset(
          image,
          width: 34,
          fit: BoxFit.contain,
        ),
        Row(
          spacing: AppDimensions.p10,
          children: [
            DegreeText(temperature: maxTemperature),
            DegreeText(temperature: minTemperature, isMuted: true),
          ],
        ),
      ],
    );
  }
}
