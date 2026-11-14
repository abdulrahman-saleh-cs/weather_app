import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather_app/core/theme/theme.dart';

class WeatherMetricItem extends StatelessWidget {
  final String iconPath;
  final String label;

  const WeatherMetricItem({
    super.key,
    required this.iconPath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppDimensions.p5,
      children: [
        SvgPicture.asset(
          iconPath,
          width: AppDimensions.iconS,
          height: AppDimensions.iconS,
          colorFilter: const ColorFilter.mode(
            AppColors.white,
            BlendMode.srcIn,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.labelMedium,
        ),
      ],
    );
  }
}
