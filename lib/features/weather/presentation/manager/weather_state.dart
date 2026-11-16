import 'package:equatable/equatable.dart';
import 'package:weather_app/features/weather/domain/entities/entities.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherSuccess extends WeatherState {
  const WeatherSuccess(this.weather, {this.selectedHour = 0});

  final WeatherEntity weather;
  final int selectedHour; // index into weather.hourlyForecast

  WeatherSuccess copyWith({int? selectedHour}) =>
      WeatherSuccess(weather, selectedHour: selectedHour ?? this.selectedHour);
  @override
  List<Object?> get props => [weather, selectedHour];
}
class WeatherFailure extends WeatherState {
  final String errMessage;
  const WeatherFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}
