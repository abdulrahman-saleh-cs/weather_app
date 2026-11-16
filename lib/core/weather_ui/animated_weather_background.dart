import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'weather_theme.dart';

/// Smoothly cross-fading gradient + glow + ambient weather effects.
class AnimatedWeatherBackground extends StatefulWidget {
  const AnimatedWeatherBackground({super.key, required this.theme});
  final WeatherTheme theme;

  @override
  State<AnimatedWeatherBackground> createState() => _AnimatedWeatherBackgroundState();
}

class _AnimatedWeatherBackgroundState extends State<AnimatedWeatherBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _t =
      AnimationController(vsync: this, duration: const Duration(seconds: 600))..repeat();

  @override
  void dispose() {
    _t.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final th = widget.theme;
    final fxKey = (th.fx.map((e) => e.index).toList()..sort()).join(',');
    return Stack(fit: StackFit.expand, children: [
      // Gradients with equal colour counts interpolate smoothly.
      AnimatedContainer(
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: th.gradient),
        ),
      ),
      Align(
        alignment: const Alignment(0, -.85),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 1200),
          width: 360,
          height: 360,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [th.glow.withValues(alpha: .55), th.glow.withValues(alpha: 0)]),
          ),
        ),
      ),
      IgnorePointer(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 900),
          child: RepaintBoundary(
            key: ValueKey(fxKey),
            child: CustomPaint(size: Size.infinite, painter: FxPainter(th.fx, _t)),
          ),
        ),
      ),
    ]);
  }
}

class FxPainter extends CustomPainter {
  FxPainter(this.fx, this.anim) : super(repaint: anim);
  final Set<Fx> fx;
  final AnimationController anim;

  double get t => anim.value * 600; // seconds

  // Deterministic pseudo-random in [0,1).
  static double _r(int i, int salt) {
    final x = math.sin(i * 127.1 + salt * 311.7) * 43758.5453;
    return x - x.floorToDouble();
  }

  @override
  void paint(Canvas c, Size s) {
    if (fx.contains(Fx.clouds)) _clouds(c, s);
    if (fx.contains(Fx.fog)) _fog(c, s);
    if (fx.contains(Fx.stars)) _stars(c, s);
    if (fx.contains(Fx.wind)) _wind(c, s);
    if (fx.contains(Fx.drizzle)) _rain(c, s, n: 45, speed: .55, len: 10, w: 1, a: .45);
    if (fx.contains(Fx.rain)) _rain(c, s, n: 80, speed: 1.0, len: 18, w: 1.3, a: .55);
    if (fx.contains(Fx.heavyRain)) _rain(c, s, n: 150, speed: 1.6, len: 26, w: 1.7, a: .6, slant: .22);
    if (fx.contains(Fx.sleet)) {
      _rain(c, s, n: 45, speed: 1.0, len: 12, w: 1.2, a: .5);
      _snow(c, s, n: 30);
    }
    if (fx.contains(Fx.snow)) _snow(c, s, n: 70);
    if (fx.contains(Fx.hail)) _hail(c, s);
    if (fx.contains(Fx.lightning)) _lightning(c, s);
  }

  void _rain(Canvas c, Size s,
      {required int n, required double speed, required double len, required double w, required double a, double slant = .12}) {
    final p = Paint()
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFBEE1FF).withValues(alpha: a);
    for (var i = 0; i < n; i++) {
      final x0 = _r(i, 1) * s.width * 1.2 - s.width * .1;
      final f = (t * speed * (.7 + _r(i, 2) * .6) + _r(i, 3)) % 1;
      final y = f * (s.height + len * 2) - len;
      c.drawLine(Offset(x0 - slant * y * .3, y), Offset(x0 - slant * y * .3 - slant * len, y + len), p);
    }
  }

  void _snow(Canvas c, Size s, {required int n}) {
    final p = Paint();
    for (var i = 0; i < n; i++) {
      final f = (t * (.05 + _r(i, 2) * .06) + _r(i, 3)) % 1;
      final x = _r(i, 1) * s.width + math.sin(t * .8 + i) * 14;
      p.color = Colors.white.withValues(alpha: .55 + _r(i, 4) * .4);
      c.drawCircle(Offset(x, f * (s.height + 20) - 10), 1.3 + _r(i, 5) * 2.6, p);
    }
  }

  void _hail(Canvas c, Size s) {
    final p = Paint();
    for (var i = 0; i < 40; i++) {
      final f = (t * 1.5 * (.8 + _r(i, 2) * .4) + _r(i, 3)) % 1;
      p.color = const Color(0xFFE8F4FF).withValues(alpha: .9);
      c.drawCircle(Offset(_r(i, 1) * s.width, f * (s.height + 20) - 10), 2 + _r(i, 5) * 1.8, p);
    }
  }

  void _stars(Canvas c, Size s) {
    final p = Paint();
    for (var i = 0; i < 55; i++) {
      final a = .25 + .75 * (.5 + .5 * math.sin(t * 2 + i * 1.7));
      p.color = Colors.white.withValues(alpha: a);
      c.drawCircle(Offset(_r(i, 1) * s.width, _r(i, 2) * s.height * .55), .7 + _r(i, 3) * 1.4, p);
    }
  }

  void _clouds(Canvas c, Size s) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: .12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28);
    for (var i = 0; i < 5; i++) {
      final w = 170 + _r(i, 1) * 120;
      final x = (((t * (.004 + _r(i, 2) * .004) + _r(i, 3)) % 1.4) - .2) * s.width;
      c.drawOval(Rect.fromCenter(center: Offset(x, s.height * (.06 + _r(i, 4) * .4)), width: w, height: w * .32), p);
    }
  }

  void _fog(Canvas c, Size s) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: .2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 38);
    for (var i = 0; i < 6; i++) {
      final x = s.width * (.3 + _r(i, 1) * .4) + math.sin(t * .15 + i * 2) * 60;
      c.drawOval(Rect.fromCenter(center: Offset(x, s.height * (.12 + i * .15)), width: s.width * .95, height: 90), p);
    }
  }

  void _wind(Canvas c, Size s) {
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.6;
    for (var i = 0; i < 9; i++) {
      final f = (t * (.28 + _r(i, 2) * .2) + _r(i, 3)) % 1;
      final x = f * (s.width + 220) - 110;
      final y = s.height * (.08 + _r(i, 1) * .6);
      final edge = math.sin(f * math.pi);
      p.color = Colors.white.withValues(alpha: .4 * edge);
      final path = Path()
        ..moveTo(x, y)
        ..quadraticBezierTo(x + 45, y - 9, x + 90, y)
        ..quadraticBezierTo(x + 110, y + 6, x + 100, y + 12);
      c.drawPath(path, p);
    }
  }

  void _lightning(Canvas c, Size s) {
    const cycle = 6.5;
    final k = t % cycle;
    final n = (t / cycle).floor();
    var flash = 0.0;
    if (k < .12) {
      flash = .55;
    } else if (k > .25 && k < .38) {
      flash = .35;
    }
    if (flash > 0) {
      c.drawRect(Offset.zero & s, Paint()..color = Colors.white.withValues(alpha: flash * .6));
    }
    if (k < .4) {
      var x = s.width * (.25 + _r(n, 9) * .5);
      var y = 0.0;
      final path = Path()..moveTo(x, y);
      var i = 0;
      while (y < s.height * .45) {
        x += (_r(n * 20 + i, 7) - .5) * 60;
        y += 28 + _r(n * 20 + i, 8) * 30;
        path.lineTo(x, y);
        i++;
      }
      c.drawPath(path, Paint()..style = PaintingStyle.stroke..strokeWidth = 7..color = const Color(0xFFB28CFF).withValues(alpha: .5)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
      c.drawPath(path, Paint()..style = PaintingStyle.stroke..strokeWidth = 2.4..color = Colors.white..strokeJoin = StrokeJoin.round);
    }
  }

  @override
  bool shouldRepaint(FxPainter o) => o.fx != fx;
}
