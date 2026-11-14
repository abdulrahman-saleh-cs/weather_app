import 'package:flutter/material.dart';

class WeatherBackground {
  static LinearGradient gradient(int code, {bool isDay = true}) {
    if (!isDay) {
      return _g(const Color(0xFF0B1026), const Color(0xFF1B2A5C));
    }
    if (code == 0 || code <= 2) {
      return _g(const Color(0xFF29B2DD), const Color(0xFF33D0F5)); // sunny
    }
    if (code == 3 || code == 45 || code == 48) {
      return _g(const Color(0xFF5B7A9D), const Color(0xFF8FA9C4)); // cloudy / fog
    }
    if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
      return _g(const Color(0xFF08235E), const Color(0xFF1747B8)); // rain
    }
    if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
      return _g(const Color(0xFF7FA6CC), const Color(0xFFD6E6F5)); // snow
    }
    if (code >= 95) {
      return _g(const Color(0xFF1F1B3D), const Color(0xFF3C3A6E)); // thunder
    }
    return _g(const Color(0xFF5B7A9D), const Color(0xFF8FA9C4));
  }

  static LinearGradient _g(Color top, Color bottom) => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [top, bottom],
  );
}