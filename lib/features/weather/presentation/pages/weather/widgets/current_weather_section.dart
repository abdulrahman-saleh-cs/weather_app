import 'package:flutter/material.dart';
import 'package:weather_app/core/weather_ui/weather_ui.dart';
import '../layouts/weather_layout_metrics.dart';

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
    final m = context.layoutMetrics;
    return Column(children: [
      _Floating(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          // Old icon fades out, new one fades in with a very small scale: no bounce.
          transitionBuilder: (w, a) => FadeTransition(
            opacity: a,
            child: ScaleTransition(
              scale: Tween<double>(begin: .92, end: 1).animate(a),
              child: w,
            ),
          ),
          child: WeatherIcon(
            key: ValueKey('$condition$isNight'),
            condition: condition,
            isNight: isNight,
            size: m.heroIconSize,
          ),
        ),
      ),
      TweenAnimationBuilder<double>(
        tween: Tween(end: currentDegree.toDouble()),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        builder: (_, v, __) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${v.round()}',
                style: TextStyle(
                  fontSize: m.tempFontSize,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  letterSpacing: m.tempLetterSpacing,
                  color: Colors.white,
                )),
            Padding(
              padding: EdgeInsets.only(top: m.degreeTopPadding),
              child: Text('°',
                  style: TextStyle(fontSize: m.degreeFontSize, fontWeight: FontWeight.w500, color: Colors.white70)),
            ),
          ],
        ),
      ),
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Text(
          condition.label,
          key: ValueKey(condition),
          style: const TextStyle(fontSize: 19, color: Colors.white),
        ),
      ),      const SizedBox(height: 10),
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
