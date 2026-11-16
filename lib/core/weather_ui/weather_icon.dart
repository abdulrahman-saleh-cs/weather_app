import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'weather_condition.dart';

/// Glossy, animated, 100% vector weather icon. No image assets needed.
/// Use `animate: false` for small icons (hourly / daily lists).
class WeatherIcon extends StatefulWidget {
  const WeatherIcon({
    super.key,
    required this.condition,
    this.isNight = false,
    this.size = 120,
    this.animate = true,
  });

  final WeatherCondition condition;
  final bool isNight;
  final double size;
  final bool animate;

  @override
  State<WeatherIcon> createState() => _WeatherIconState();
}

class _WeatherIconState extends State<WeatherIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 60));

  @override
  void initState() {
    super.initState();
    if (widget.animate) _c.repeat();
  }

  @override
  void didUpdateWidget(WeatherIcon old) {
    super.didUpdateWidget(old);
    if (widget.animate && !_c.isAnimating) _c.repeat();
    if (!widget.animate) _c.stop();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _IconPainter(widget.condition, widget.isNight, _c, widget.animate),
          ),
        ),
      );
}

const _light = [Color(0xFFFFFFFF), Color(0xFFCDD8EE)];
const _grey = [Color(0xFFE3E8F2), Color(0xFF9AA8C2)];
const _dark = [Color(0xFF8D96AE), Color(0xFF4A5470)];

class _IconPainter extends CustomPainter {
  _IconPainter(this.cond, this.night, this.anim, this.animate) : super(repaint: anim);
  final WeatherCondition cond;
  final bool night, animate;
  final AnimationController anim;

  double get t => animate ? anim.value * 60 : 0.3;

  @override
  void paint(Canvas c, Size size) {
    c.save();
    c.scale(size.width / 64);
    switch (cond) {
      case WeatherCondition.clear:
        night ? _moon(c, s: 1.15) : _sun(c, s: 1.1);
      case WeatherCondition.partlyCloudy:
        night ? _moon(c, at: const Offset(25, 24), s: .8) : _sun(c, at: const Offset(24, 24), s: .75);
        _cloud(c, dy: 3);
      case WeatherCondition.cloudy:
        _cloud(c, dx: -9, dy: -8, s: .8, col: _grey);
        _cloud(c, dx: 1, dy: 4);
      case WeatherCondition.fog:
        _cloud(c, dy: -7, col: _grey);
        for (var i = 0; i < 3; i++) {
          final x = math.sin(t * 1.2 + i * 1.7) * 4;
          c.drawLine(Offset(16 + x + i * 3, 46.0 + i * 6), Offset(48 + x - i * 3, 46.0 + i * 6),
              Paint()..color = Colors.white.withValues(alpha: .85 - i * .15)..strokeWidth = 3..strokeCap = StrokeCap.round);
        }
      case WeatherCondition.drizzle:
        _cloud(c, dy: -4, col: _grey);
        _drops(c, n: 4, speed: .5, w: 1.8, len: 4);
      case WeatherCondition.rain:
        _cloud(c, dy: -4, col: _grey);
        _drops(c, n: 3, speed: 1, w: 3, len: 6);
      case WeatherCondition.heavyRain:
        _cloud(c, dy: -5, col: _dark);
        _drops(c, n: 5, speed: 1.8, w: 3.2, len: 8);
      case WeatherCondition.thunderstorm:
        _cloud(c, dy: -6, col: _dark);
        _bolt(c);
      case WeatherCondition.snow:
        _cloud(c, dy: -4);
        _flakes(c, n: 3);
      case WeatherCondition.sleet:
        _cloud(c, dy: -4, col: _grey);
        _drops(c, n: 2, speed: 1, w: 2.6, len: 5, xs: const [24, 42]);
        _flakes(c, n: 2, xs: const [33, 49]);
      case WeatherCondition.hail:
        _cloud(c, dy: -4, col: _dark);
        for (var i = 0; i < 4; i++) {
          final p = (t * 1.6 + i * .27) % 1;
          c.drawCircle(Offset(22.0 + i * 7, 46 + p * 15), 2.3,
              Paint()..color = const Color(0xFFE8F4FF).withValues(alpha: 1 - p * .6));
        }
      case WeatherCondition.windy:
        _cloud(c, dx: 5, dy: -12, s: .62, col: _grey);
        _wind(c);
    }
    c.restore();
  }

  // ---------- building blocks (64x64 space) ----------

  void _sun(Canvas c, {Offset at = const Offset(32, 32), double s = 1}) {
    c.save();
    c.translate(at.dx, at.dy);
    c.scale(s);
    final glow = Paint()
      ..shader = RadialGradient(colors: [const Color(0x66FFD23F), const Color(0x00FFD23F)])
          .createShader(Rect.fromCircle(center: Offset.zero, radius: 30));
    c.drawCircle(Offset.zero, 30, glow);
    final ray = Paint()
      ..color = const Color(0xFFFFC233)
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4 + t * .15;
      c.drawLine(Offset(math.cos(a) * 19, math.sin(a) * 19), Offset(math.cos(a) * 25, math.sin(a) * 25), ray);
    }
    final r = Rect.fromCircle(center: Offset.zero, radius: 14);
    c.drawCircle(
      Offset.zero,
      14,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-.3, -.4),
          colors: [Color(0xFFFFF4A3), Color(0xFFFFD23F), Color(0xFFFF9F1C)],
          stops: [0, .6, 1],
        ).createShader(r),
    );
    c.restore();
  }

  void _moon(Canvas c, {Offset at = const Offset(32, 32), double s = 1}) {
    c.save();
    c.translate(at.dx, at.dy);
    c.scale(s);
    final a = Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: 18));
    final b = Path()..addOval(Rect.fromCircle(center: const Offset(9, -7), radius: 15));
    final m = Path.combine(PathOperation.difference, a, b);
    c.drawPath(
      m,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFF9AA8FF)],
        ).createShader(const Rect.fromLTRB(-18, -18, 18, 18)),
    );
    final tw = .6 + .4 * math.sin(t * 2.2);
    c.drawCircle(const Offset(14, -15), 1.5, Paint()..color = Colors.white.withValues(alpha: tw));
    c.drawCircle(const Offset(20, 0), 1.1, Paint()..color = Colors.white.withValues(alpha: 1.1 - tw));
    c.restore();
  }

  void _cloud(Canvas c, {double dx = 0, double dy = 0, double s = 1, List<Color> col = _light}) {
    c.save();
    c.translate(dx, dy);
    c.translate(32 * (1 - s), 32 * (1 - s));
    c.scale(s);
    final blobs = Path()
      ..addOval(Rect.fromCircle(center: const Offset(24, 36), radius: 11))
      ..addOval(Rect.fromCircle(center: const Offset(36, 28), radius: 14))
      ..addOval(Rect.fromCircle(center: const Offset(48, 36), radius: 10));
    final base = Path()
      ..addRRect(RRect.fromRectAndRadius(const Rect.fromLTRB(14, 33, 58, 47), const Radius.circular(7)));
    final cloud = Path.combine(PathOperation.union, blobs, base);
    c.drawShadow(cloud, Colors.black.withValues(alpha: .35), 3, true);
    c.drawPath(
      cloud,
      Paint()
        ..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: col)
            .createShader(const Rect.fromLTRB(13, 14, 58, 47)),
    );
    c.restore();
  }

  void _drops(Canvas c,
      {required int n, required double speed, required double w, required double len, List<double>? xs}) {
    final p = Paint()
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < n; i++) {
      final x = xs?[i] ?? 22 + i * (28 / (n - 1));
      final f = (t * speed + i * .37) % 1;
      final y = 44 + f * 16;
      p.color = const Color(0xFF6CC4FF).withValues(alpha: 1 - f);
      c.drawLine(Offset(x, y), Offset(x - 1.5, y + len), p);
    }
  }

  void _flakes(Canvas c, {required int n, List<double>? xs}) {
    for (var i = 0; i < n; i++) {
      final x = (xs?[i] ?? 22 + i * (28 / (n - 1))) + math.sin(t * 2 + i) * 2;
      final f = (t * .5 + i * .33) % 1;
      c.drawCircle(Offset(x, 45 + f * 16), 2.1, Paint()..color = Colors.white.withValues(alpha: 1 - f * .8));
    }
  }

  void _bolt(Canvas c) {
    final flick = .65 + .35 * math.sin(t * 9).abs();
    final p = Path()
      ..moveTo(35, 40)
      ..lineTo(26, 54)
      ..lineTo(32, 54)
      ..lineTo(28, 63)
      ..lineTo(42, 47)
      ..lineTo(35, 47)
      ..lineTo(39, 40)
      ..close();
    c.drawPath(p, Paint()..color = const Color(0xFFFFD23F).withValues(alpha: .4 * flick)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    c.drawPath(
      p,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFFF4A3).withValues(alpha: flick),
            const Color(0xFFFF9F1C).withValues(alpha: flick),
          ],
        ).createShader(const Rect.fromLTRB(26, 40, 42, 63)),
    );
  }

  void _wind(Canvas c) {
    c.save();
    c.translate(math.sin(t * 2) * 2.5, 0);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.6
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;
    final a = Path()
      ..moveTo(8, 34)
      ..lineTo(38, 34)
      ..arcTo(Rect.fromCircle(center: const Offset(38, 28), radius: 6), math.pi / 2, -math.pi * 1.4, false);
    final b = Path()
      ..moveTo(14, 45)
      ..lineTo(40, 45)
      ..arcTo(Rect.fromCircle(center: const Offset(40, 50), radius: 5), -math.pi / 2, math.pi * 1.4, false);
    final d = Path()
      ..moveTo(6, 55)
      ..lineTo(26, 55);
    c.drawPath(a, p);
    c.drawPath(b, p..color = Colors.white.withValues(alpha: .85));
    c.drawPath(d, p..color = Colors.white.withValues(alpha: .6));
    c.restore();
  }

  @override
  bool shouldRepaint(_IconPainter o) => o.cond != cond || o.night != night || o.animate != animate;
}
