import 'package:weather_app/core/weather_ui/weather_ui.dart';
import 'package:weather_app/features/weather/domain/domain.dart';

// ---------------------------------------------------------------------------
// DEBUG ONLY. Set any of these, then hot restart, to preview a look without
// waiting for real weather. Leave them null in production.
//   kDebugWeatherCode: 0 clear, 2 partly cloudy, 3 cloudy, 45 fog, 51 drizzle,
//   63 rain, 65 heavy rain, 66 sleet, 75 snow, 95 thunderstorm, 96 hail
//   kDebugIsDay: false = night      kDebugWindKmh: 50 = windy
// ---------------------------------------------------------------------------
const int? kDebugWeatherCode = 63;
const bool? kDebugIsDay = false;
const double? kDebugWindKmh = 20;

int hourOf(String time) => int.tryParse(time.split(':').first) ?? 12;

extension HourlyUi on HourlyForecastEntity {
  bool get isNight => !(kDebugIsDay ?? isDay);
  DayPhase get phase => phaseFromHour(hourOf(time), !isNight);

  /// Pass [windKmh] only for the current hour (the API gives no hourly wind).
  WeatherCondition conditionAt({double windKmh = 0}) =>
      conditionFromWmo(kDebugWeatherCode ?? weatherCode, windKmh: kDebugWindKmh ?? windKmh);
}

extension DailyUi on DailyForecastEntity {
  WeatherCondition get condition => conditionFromWmo(kDebugWeatherCode ?? weatherCode);
}
