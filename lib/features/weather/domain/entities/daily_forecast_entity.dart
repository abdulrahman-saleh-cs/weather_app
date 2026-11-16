import 'package:equatable/equatable.dart';

class DailyForecastEntity extends Equatable {
  final String day;
  final int maxTemp;
  final int minTemp;
  final String image;
  final int weatherCode;

  const DailyForecastEntity({
    required this.day,
    required this.maxTemp,
    required this.minTemp,
    required this.image,
    required this.weatherCode,
  });

  @override
  List<Object?> get props => [day, maxTemp, minTemp, image, weatherCode];
}
