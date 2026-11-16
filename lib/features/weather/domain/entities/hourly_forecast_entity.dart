import 'package:equatable/equatable.dart';

class HourlyForecastEntity extends Equatable {
  const HourlyForecastEntity({
    required this.time,
    required this.temperature,
    required this.image,
    required this.weatherCode,
    required this.isDay,
  });

  final String time;
  final double temperature;
  final String image;
  final int weatherCode;
  final bool isDay;

  @override
  List<Object?> get props => [time, temperature, image,weatherCode,isDay];
}
