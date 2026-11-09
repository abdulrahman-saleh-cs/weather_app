import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/app_colors.dart';
import 'package:weather_app/core/theme/app_dimensions.dart';
import 'package:weather_app/core/theme/app_text_styles.dart';

class HourlyItemWidget extends StatelessWidget {
  final String temperature;
  final String image;
  final String time;
  final bool isNow;

  const HourlyItemWidget({
    super.key,
    required this.temperature,
    required this.image,
    required this.time,
    required this.isNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isNow ? const Color.fromRGBO(37, 102, 163, 0.2) : null,
        borderRadius: BorderRadius.circular(AppDimensions.r20),
        border: isNow
            ? Border.all(
                color: const Color(0xFF5096FF),
              )
            : null,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.p10,
        vertical: AppDimensions.p14,
      ),
      child: Column(
        spacing: AppDimensions.p20,
        children: [
          Text(
            temperature,
            style: AppTextStyles.bodyMedium,
          ),
          Image.asset(
            image,
            width: 34,
            fit: BoxFit.contain,
          ),
          Text(
            time,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}
