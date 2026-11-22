import 'package:equatable/equatable.dart';

class WeatherParams extends Equatable {
  final double lat;
  final double lon;
  final String cityName;

  const WeatherParams({required this.lat, required this.lon, required this.cityName});

  @override
  List<Object?> get props => [lat, lon, cityName];
}
