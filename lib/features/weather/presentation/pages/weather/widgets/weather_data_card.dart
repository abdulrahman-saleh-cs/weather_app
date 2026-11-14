import 'package:flutter/material.dart';

import 'package:weather_app/core/theme/theme.dart';

class WeatherDataCard extends StatelessWidget {
  const WeatherDataCard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.p20,
        vertical: AppDimensions.p14,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppDimensions.r20),
      ),
      child: child,
    );
  }
}
