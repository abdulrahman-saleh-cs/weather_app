import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/theme.dart';

class DegreeText extends StatelessWidget {
  final int temperature;
  final bool isMuted;

  const DegreeText({
    super.key,
    required this.temperature,
    this.isMuted = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 35,
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 20,
            color: isMuted ? AppColors.white.withValues(alpha:0.5) : AppColors.white,
          ),
          children: [
            TextSpan(
              text: '$temperature',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.top,
              child: Text(
                '°',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isMuted ? AppColors.white.withValues(alpha:0.5) : AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
