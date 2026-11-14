import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/params/params.dart';
import 'package:weather_app/features/weather/domain/domain.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final GetWeather _getWeatherUseCase;

  WeatherCubit({required GetWeather getWeatherUseCase})
      : _getWeatherUseCase = getWeatherUseCase,
        super(WeatherInitial());

  Future<void> getWeather({required double lat, required double lon}) async {
    emit(WeatherLoading());

    final result = await _getWeatherUseCase(WeatherParams(lat: lat, lon: lon));

    result.fold(
      (failure) => emit(WeatherFailure(failure.errMessage)),
      (weather) => emit(WeatherSuccess(weather)),
    );
  }
}
