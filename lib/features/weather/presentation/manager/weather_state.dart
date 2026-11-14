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
  final WeatherEntity weather;
  const WeatherSuccess(this.weather);

  @override
  List<Object?> get props => [weather];
}

class WeatherFailure extends WeatherState {
  final String errMessage;
  const WeatherFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}
