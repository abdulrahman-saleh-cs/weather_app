import 'package:flutter/material.dart';
import 'package:weather_app/core/weather_ui/weather_ui.dart';

/// One glass tile: coloured icon chip, bold value, small label.
class WeatherMetricItem extends StatelessWidget {
  const WeatherMetricItem({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value, label;
  final Color color;

  @override
  Widget build(BuildContext context) => Expanded(
        child: GlassCard(
          radius: 20,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          child: Column(children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .28),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 19, color: color),
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
            Text(label.toUpperCase(),
                style: const TextStyle(fontSize: 10.5, letterSpacing: .6, color: Colors.white70)),
          ]),
        ),
      );
}
