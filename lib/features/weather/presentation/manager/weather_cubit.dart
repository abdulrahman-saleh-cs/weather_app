import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/params/params.dart';
import 'package:weather_app/features/weather/domain/domain.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final GetWeather _getWeatherUseCase;
  WeatherParams? _lastParams;

  WeatherCubit({required GetWeather getWeatherUseCase})
      : _getWeatherUseCase = getWeatherUseCase,
        super(WeatherInitial());

  /// First load (shows the loading screen).
  Future<void> getWeather({required double lat, required double lon}) async {
    _lastParams = WeatherParams(lat: lat, lon: lon);
    emit(WeatherLoading());
    await _load(showError: true);
  }

  /// Pull-to-refresh: keeps the current screen visible while loading.
  Future<void> refresh() async {
    if (_lastParams == null) return;
    await _load(showError: state is! WeatherSuccess);
  }

  /// "Retry" button on the error screen.
  Future<void> retry() async {
    final p = _lastParams;
    if (p == null) return;
    await getWeather(lat: p.lat, lon: p.lon);
  }

  Future<void> _load({required bool showError}) async {
    final result = await _getWeatherUseCase(_lastParams!);
    result.fold(
      (failure) {
        if (showError) emit(WeatherFailure(failure.errMessage));
      },
      (weather) => emit(WeatherSuccess(weather, selectedHour: _nowIndex(weather))),
    );
  }

  void selectHour(int index) {
    final s = state;
    if (s is WeatherSuccess) emit(s.copyWith(selectedHour: index));
  }

  int _nowIndex(WeatherEntity weather) {
    final nowHour = DateTime.now().hour;
    final index = weather.hourlyForecast.indexWhere(
      (h) => int.parse(h.time.split(':').first) == nowHour,
    );
    return index < 0 ? 0 : index;
  }
}
