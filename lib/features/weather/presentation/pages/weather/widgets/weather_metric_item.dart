import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather_app/core/theme/app_colors.dart';
import 'package:weather_app/core/theme/app_dimensions.dart';
import 'package:weather_app/core/theme/app_text_styles.dart';

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
