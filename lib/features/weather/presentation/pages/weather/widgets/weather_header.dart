import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/theme.dart';
import 'package:weather_app/core/weather_ui/weather_ui.dart';

class WeatherHeader extends StatelessWidget {
  const WeatherHeader({super.key, required this.cityName, this.onCityTap, this.onBellTap});
  final String cityName;
  final VoidCallback? onCityTap;
  final VoidCallback? onBellTap;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onCityTap,
            child: GlassCard(
              radius: 99,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.location_on_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 6),
                Text(cityName, style: AppTextStyles.bodyLarge),
                const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
              ]),
            ),
          ),
          GestureDetector(onTap: onBellTap, child: const _RingingBell()),
        ],
      );
}

class _RingingBell extends StatefulWidget {
  const _RingingBell();
  @override
  State<_RingingBell> createState() => _RingingBellState();
}

class _RingingBellState extends State<_RingingBell> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (_, __) {
          final v = _c.value;
          final k = ((v - .88) / .11).clamp(0.0, 1.0);
          final angle = (v > .88 && v < .99) ? math.sin(k * math.pi * 4) * .28 * (1 - k) : 0.0;
          final pulse = (math.sin(v * math.pi * 5) + 1) / 2;
          const red = Color(0xFFFF5A5F);
          return GlassCard(
            radius: 99,
            padding: const EdgeInsets.all(10),
            child: Stack(clipBehavior: Clip.none, children: [
              Transform.rotate(
                angle: angle,
                alignment: Alignment.topCenter,
                child: const Icon(Icons.notifications_rounded, color: Colors.white, size: 22),
              ),
              Positioned(
                right: 1,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white54, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: red.withValues(alpha: .6 * (1 - pulse)),
                        blurRadius: 8 * pulse,
                        spreadRadius: 5 * pulse,
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          );
        },
      );
}
