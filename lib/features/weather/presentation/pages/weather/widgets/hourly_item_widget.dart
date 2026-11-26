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
    this.width = 66,
  });

  final String temperature, time;
  final WeatherCondition condition;
  final bool isNight, isNow;

  /// Fixed width for scrolling lists; `null` lets the tile fill its parent.
  final double? width;

  // The gradient and the shadow always exist; only their opacity changes.
  // That makes the highlight fade in and out smoothly instead of popping.
  static const _gradientOn = [Color(0xFFFFB86B), Accent.coral];
  static const _gradientOff = [Color(0x00FFB86B), Color(0x00FF7A59)];

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOutCubic,
        width: width,
        transform: Matrix4.translationValues(0, isNow ? -3 : 0, 0),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isNow ? _gradientOn : _gradientOff,
          ),
          boxShadow: [
            BoxShadow(
              color: Accent.coral.withValues(alpha: isNow ? .4 : 0),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
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