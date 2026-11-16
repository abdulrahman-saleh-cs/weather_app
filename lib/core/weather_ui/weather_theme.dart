import 'package:flutter/material.dart';
import 'weather_condition.dart';

/// Ambient effect layers drawn over the gradient.
enum Fx { clouds, stars, drizzle, rain, heavyRain, snow, sleet, hail, fog, wind, lightning }

class WeatherTheme {
  const WeatherTheme(this.gradient, this.glow, this.fx);
  final List<Color> gradient; // always 3 colours so it can animate smoothly
  final Color glow;
  final Set<Fx> fx;
}

/// Accent colours shared across the UI.
class Accent {
  static const coral = Color(0xFFFF7A59);
  static const amber = Color(0xFFFFD37A);
  static const ice = Color(0xFF9FE8FF);
  static const teal = Color(0xFFA6F5E8);
  static const sky = Color(0xFFB6E4FF);
}

Color _c(int rgb) => Color(0xFF000000 | rgb);
List<Color> _g(int a, int b, int c) => [_c(a), _c(b), _c(c)];

List<Color> _darken(List<Color> l, double amt) =>
    l.map((c) => Color.lerp(c, Colors.black, amt)!).toList();

WeatherTheme themeFor(WeatherCondition cond, DayPhase p) {
  final i = p.index; // morning, noon, sunset, night

  const clear = [
    [0xFF9A8B, 0xFFC58A, 0x8FD3F4],
    [0x1E88E5, 0x35B6F5, 0x7FE0FF],
    [0x3A1C71, 0xD76D77, 0xFFAF7B],
    [0x070B1F, 0x17235E, 0x3B2F7D],
  ];
  const clearGlow = [0xFFF2A8, 0xFFF7B0, 0xFFB26B, 0x6C7BFF];
  const grey = [
    [0xB7A5B5, 0xD6C3B8, 0xA9BCD0],
    [0x5F7C9E, 0x8FA9C6, 0xB9CCDF],
    [0x4B3A5C, 0x9A6B7C, 0xD9A388],
    [0x0C1226, 0x1E2A4A, 0x3A4468],
  ];
  const wet = [
    [0x4A5568, 0x7B8FA8, 0xA9B9CC],
    [0x3A4A6B, 0x5F7AA3, 0x8FA9C9],
    [0x2E2A4A, 0x6B5B7E, 0xB08A8A],
    [0x080C1C, 0x16213F, 0x2C3A5E],
  ];
  const storm = [
    [0x241B3F, 0x4A3A6B, 0x8A6A8F],
    [0x1B1633, 0x3A2F63, 0x5A4A8C],
    [0x1F1738, 0x44345F, 0x7C5A82],
    [0x05040F, 0x15102E, 0x2B2150],
  ];
  const snow = [
    [0x8FA8C8, 0xBCCFE3, 0xEAF1F9],
    [0x5C7A9F, 0x9FB9D6, 0xE3EEFA],
    [0x6B6A9A, 0xB9A3C0, 0xF2D0C8],
    [0x1A2342, 0x3A4F7A, 0x7C94BE],
  ];
  List<Color> pick(List<List<int>> t) => _g(t[i][0], t[i][1], t[i][2]);
  final night = p == DayPhase.night;
  final stars = night ? {Fx.stars} : <Fx>{};

  switch (cond) {
    case WeatherCondition.clear:
      return WeatherTheme(pick(clear), _c(clearGlow[i]), stars);
    case WeatherCondition.partlyCloudy:
      return WeatherTheme(pick(clear), _c(clearGlow[i]), {...stars, Fx.clouds});
    case WeatherCondition.windy:
      return WeatherTheme(pick(clear), _c(clearGlow[i]), {...stars, Fx.wind, Fx.clouds});
    case WeatherCondition.cloudy:
      return WeatherTheme(pick(grey), _c(0xFFFFFF), {Fx.clouds});
    case WeatherCondition.fog:
      return WeatherTheme(pick(grey), _c(0xFFFFFF), {Fx.fog});
    case WeatherCondition.drizzle:
      return WeatherTheme(pick(wet), _c(0x8FB4FF), {Fx.clouds, Fx.drizzle});
    case WeatherCondition.rain:
      return WeatherTheme(pick(wet), _c(0x8FB4FF), {Fx.clouds, Fx.rain});
    case WeatherCondition.heavyRain:
      return WeatherTheme(_darken(pick(wet), .22), _c(0x6F95E8), {Fx.clouds, Fx.heavyRain, Fx.wind});
    case WeatherCondition.thunderstorm:
      return WeatherTheme(pick(storm), _c(0xB28CFF), {Fx.clouds, Fx.heavyRain, Fx.lightning});
    case WeatherCondition.snow:
      return WeatherTheme(pick(snow), _c(0xFFFFFF), {...stars, Fx.snow});
    case WeatherCondition.sleet:
      return WeatherTheme(pick(wet), _c(0xCFE3FF), {Fx.clouds, Fx.sleet});
    case WeatherCondition.hail:
      return WeatherTheme(_darken(pick(wet), .15), _c(0xCFE3FF), {Fx.clouds, Fx.hail, Fx.wind});
  }
}
