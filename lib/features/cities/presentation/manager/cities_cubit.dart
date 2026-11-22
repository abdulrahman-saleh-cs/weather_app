import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/cities/domain/domain.dart';
import 'cities_state.dart';

class CitiesCubit extends Cubit<CitiesState> {
  final SearchCities _searchCities;
  final GetCitiesWeather _getCitiesWeather;
  final GetSavedCities _getSavedCities;
  final SaveCity _saveCity;
  final RemoveCity _removeCity;
  final GetSelectedCity _getSelectedCity;
  final SelectCity _selectCity;

  CitiesCubit({
    required SearchCities searchCities,
    required GetCitiesWeather getCitiesWeather,
    required GetSavedCities getSavedCities,
    required SaveCity saveCity,
    required RemoveCity removeCity,
    required GetSelectedCity getSelectedCity,
    required SelectCity selectCity,
  })  : _searchCities = searchCities,
        _getCitiesWeather = getCitiesWeather,
        _getSavedCities = getSavedCities,
        _saveCity = saveCity,
        _removeCity = removeCity,
        _getSelectedCity = getSelectedCity,
        _selectCity = selectCity,
        super(const CitiesState());

  static const _minQueryLength = 2;
  static const _debounceDuration = Duration(milliseconds: 400);

  Timer? _debounce;
  String _lastQuery = '';

  /// Loads saved cities and the selected one. The first launch saves the default city.
  Future<void> load() async {
    final selected = (await _getSelectedCity()).getOrElse(() => CityEntity.defaultCity);
    var saved = (await _getSavedCities()).getOrElse(() => const []);

    if (!saved.contains(selected)) {
      await _saveCity(selected);
      saved = [selected, ...saved];
    }
    emit(state.copyWith(saved: saved, selected: selected));
  }

  /// Fetches current weather for every saved city (one request).
  /// Failures are ignored: cards simply keep their previous values.
  Future<void> loadWeather() async {
    final cities = state.saved;
    if (cities.isEmpty) return;

    final result = await _getCitiesWeather(cities);
    if (isClosed) return;
    result.fold((_) {}, (list) {
      emit(state.copyWith(
        weather: {
          ...state.weather,
          for (var i = 0; i < cities.length && i < list.length; i++) cities[i]: list[i],
        },
      ));
    });
  }

  /// Debounced search; ignores answers that arrive after a newer query.
  void search(String query) {
    _debounce?.cancel();
    final q = query.trim();
    _lastQuery = q;

    if (q.length < _minQueryLength) {
      emit(state.copyWith(results: const [], searchStatus: SearchStatus.idle));
      return;
    }

    emit(state.copyWith(searchStatus: SearchStatus.loading));
    _debounce = Timer(_debounceDuration, () async {
      final result = await _searchCities(q);
      if (isClosed || q != _lastQuery) return;
      result.fold(
        (failure) => emit(state.copyWith(
          results: const [],
          searchStatus: SearchStatus.failure,
          errorMessage: failure.errMessage,
        )),
        (cities) => emit(state.copyWith(results: cities, searchStatus: SearchStatus.success)),
      );
    });
  }

  /// Saves (if new) and selects a city. The weather screen reacts to [CitiesState.selected].
  Future<void> choose(CityEntity city) async {
    await _saveCity(city);
    await _selectCity(city);
    final saved = (await _getSavedCities()).getOrElse(() => [city]);
    emit(state.copyWith(
      saved: saved,
      selected: city,
      results: const [],
      searchStatus: SearchStatus.idle,
    ));
  }

  /// Removes a saved city. The last remaining city cannot be removed.
  /// The list updates immediately; saving happens afterwards (a swiped card
  /// must leave the widget tree in the same frame).
  Future<void> remove(CityEntity city) async {
    if (state.saved.length <= 1) return;

    final remaining = [
      for (final c in state.saved)
        if (c != city) c,
    ];
    final removedSelected = state.selected == city;
    final selected = removedSelected ? remaining.first : state.selected;
    emit(state.copyWith(saved: remaining, selected: selected));

    await _removeCity(city);
    if (removedSelected && selected != null) await _selectCity(selected);
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
