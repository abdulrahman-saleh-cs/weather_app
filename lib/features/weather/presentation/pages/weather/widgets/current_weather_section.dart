import 'package:flutter/material.dart';
import 'package:weather_app/core/weather_ui/weather_ui.dart';

class CurrentWeatherSection extends StatelessWidget {
  const CurrentWeatherSection({
    super.key,
    required this.condition,
    required this.isNight,
    required this.currentDegree,
    required this.maxDegree,
    required this.minDegree,
  });

  final WeatherCondition condition;
  final bool isNight;
  final int currentDegree, maxDegree, minDegree;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _Floating(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 650),
          switchInCurve: Curves.elasticOut,
          transitionBuilder: (w, a) => FadeTransition(
            opacity: a,
            child: ScaleTransition(scale: a, child: w),
          ),
          child: WeatherIcon(
            key: ValueKey('$condition$isNight'),
            condition: condition,
            isNight: isNight,
            size: 180,
          ),
        ),
      ),
      TweenAnimationBuilder<double>(
        tween: Tween(end: currentDegree.toDouble()),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        builder: (_, v, __) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${v.round()}',
                style: const TextStyle(fontSize: 92, fontWeight: FontWeight.w700, height: 1.1, letterSpacing: -4, color: Colors.white)),
            const Padding(
              padding: EdgeInsets.only(top: 14),
              child: Text('°', style: TextStyle(fontSize: 46, fontWeight: FontWeight.w500, color: Colors.white70)),
            ),
          ],
        ),
      ),
      Text(condition.label, style: const TextStyle(fontSize: 19, color: Colors.white)),
      const SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _Pill(Icons.arrow_upward_rounded, '$maxDegree°', Accent.amber),
        const SizedBox(width: 8),
        _Pill(Icons.arrow_downward_rounded, '$minDegree°', Accent.ice),
      ]),
    ]);
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.icon, this.text, this.color);
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: .18),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: Colors.white.withValues(alpha: .2)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
        ]),
      );
}

class _Floating extends StatefulWidget {
  const _Floating({required this.child});
  final Widget child;
  @override
  State<_Floating> createState() => _FloatingState();
}

class _FloatingState extends State<_Floating> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2600))..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (_, child) =>
            Transform.translate(offset: Offset(0, -10 * Curves.easeInOut.transform(_c.value)), child: child),
        child: widget.child,
      );
}
