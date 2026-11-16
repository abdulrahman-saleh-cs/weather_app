/// Every weather condition the UI supports.
enum WeatherCondition {
  clear,
  partlyCloudy,
  cloudy,
  fog,
  drizzle,
  rain,
  heavyRain,
  thunderstorm,
  snow,
  sleet,
  hail,
  windy,
}

/// Time-of-day phase used to pick the background palette.
enum DayPhase { morning, noon, sunset, night }

extension WeatherConditionX on WeatherCondition {
  String get label => switch (this) {
        WeatherCondition.clear => 'Clear sky',
        WeatherCondition.partlyCloudy => 'Partly cloudy',
        WeatherCondition.cloudy => 'Cloudy',
        WeatherCondition.fog => 'Foggy',
        WeatherCondition.drizzle => 'Light drizzle',
        WeatherCondition.rain => 'Rain',
        WeatherCondition.heavyRain => 'Heavy rain',
        WeatherCondition.thunderstorm => 'Thunderstorm',
        WeatherCondition.snow => 'Snow',
        WeatherCondition.sleet => 'Sleet',
        WeatherCondition.hail => 'Hail',
        WeatherCondition.windy => 'Windy',
      };
}

/// Maps WMO weather codes (Open-Meteo) to a [WeatherCondition].
/// Wind >= 45 km/h turns a calm sky into [WeatherCondition.windy].
WeatherCondition conditionFromWmo(int code, {double windKmh = 0}) {
  final c = switch (code) {
    0 => WeatherCondition.clear,
    1 || 2 => WeatherCondition.partlyCloudy,
    3 => WeatherCondition.cloudy,
    45 || 48 => WeatherCondition.fog,
    51 || 53 || 55 => WeatherCondition.drizzle,
    56 || 57 || 66 || 67 => WeatherCondition.sleet,
    61 || 63 || 80 || 81 => WeatherCondition.rain,
    65 || 82 => WeatherCondition.heavyRain,
    71 || 73 || 75 || 77 || 85 || 86 => WeatherCondition.snow,
    95 => WeatherCondition.thunderstorm,
    96 || 99 => WeatherCondition.hail,
    _ => WeatherCondition.cloudy,
  };
  final calm = c == WeatherCondition.clear ||
      c == WeatherCondition.partlyCloudy ||
      c == WeatherCondition.cloudy;
  return (windKmh >= 45 && calm) ? WeatherCondition.windy : c;
}

/// Picks the background phase from the hour and Open-Meteo's `is_day` flag.
DayPhase phaseFromHour(int hour, bool isDay) {
  if (!isDay) return DayPhase.night;
  if (hour < 10) return DayPhase.morning;
  if (hour >= 16) return DayPhase.sunset;
  return DayPhase.noon;
}
