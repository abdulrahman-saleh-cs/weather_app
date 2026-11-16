import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/theme.dart';
import 'package:weather_app/core/weather_ui/weather_ui.dart';

class ForecastDayRow extends StatelessWidget {
  const ForecastDayRow({
    super.key,
    required this.day,
    required this.condition,
    required this.maxTemperature,
    required this.minTemperature,
    required this.rangeMin,
    required this.rangeMax,
  });

  final String day;
  final WeatherCondition condition;
  final int maxTemperature, minTemperature;

  /// Lowest / highest temperature across all rows, so the bars share one scale.
  final int rangeMin, rangeMax;

  @override
  Widget build(BuildContext context) {
    final span = (rangeMax - rangeMin).clamp(1, 1000);
    final start = (minTemperature - rangeMin) / span;
    final end = (maxTemperature - rangeMin) / span;
    return Row(children: [
      SizedBox(width: 92, child: Text(day, style: AppTextStyles.bodyMedium.copyWith(fontSize: 16))),
      WeatherIcon(condition: condition, size: 32, animate: false),
      const SizedBox(width: 10),
      SizedBox(
        width: 34,
        child: Text('$minTemperature°', textAlign: TextAlign.right, style: const TextStyle(fontSize: 15, color: Colors.white60)),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: LayoutBuilder(
          builder: (_, box) => TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (_, g, __) => SizedBox(
              height: 7,
              child: Stack(children: [
                Container(decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(9))),
                Positioned(
                  left: box.maxWidth * start,
                  width: ((box.maxWidth * (end - start)).clamp(10.0, box.maxWidth)) * g,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      gradient: const LinearGradient(colors: [Color(0xFF7FE3FF), Accent.amber, Accent.coral]),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
      const SizedBox(width: 8),
      SizedBox(
        width: 34,
        child: Text('$maxTemperature°', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
      ),
    ]);
  }
}
