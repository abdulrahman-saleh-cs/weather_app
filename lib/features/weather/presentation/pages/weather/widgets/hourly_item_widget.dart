import 'package:flutter/material.dart';
import 'package:weather_app/core/weather_ui/weather_ui.dart';

class HourlyItemWidget extends StatelessWidget {
  const HourlyItemWidget({
    super.key,
    required this.temperature,
    required this.condition,
    required this.isNight,
    required this.time,
    required this.isNow,
  });

  final String temperature, time;
  final WeatherCondition condition;
  final bool isNight, isNow;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: 66,
        transform: Matrix4.translationValues(0, isNow ? -4 : 0, 0),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isNow
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFB86B), Accent.coral],
                )
              : null,
          boxShadow: isNow
              ? [BoxShadow(color: Accent.coral.withValues(alpha: .45), blurRadius: 18, offset: const Offset(0, 8))]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(temperature, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
            WeatherIcon(condition: condition, isNight: isNight, size: 36, animate: false),
            Text(time, style: const TextStyle(fontSize: 12, color: Colors.white)),
          ],
        ),
      );
}
