import '../../domain/entities/entities.dart';

class DailyForecastModel extends DailyForecastEntity {
  const DailyForecastModel({
    required super.day,
    required super.maxTemp,
    required super.minTemp,
    required super.image,
    required super.weatherCode,
  });
}
