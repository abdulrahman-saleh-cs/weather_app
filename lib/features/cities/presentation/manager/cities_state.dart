import 'package:equatable/equatable.dart';
import 'package:weather_app/features/cities/domain/domain.dart';

enum SearchStatus { idle, loading, success, failure }

class CitiesState extends Equatable {
  final List<CityEntity> saved;
  final CityEntity? selected;
  final List<CityEntity> results;
  final SearchStatus searchStatus;
  final String errorMessage;

  /// Latest known weather for saved cities (a city can be missing until loaded).
  final Map<CityEntity, CityWeatherEntity> weather;

  const CitiesState({
    this.saved = const [],
    this.selected,
    this.results = const [],
    this.searchStatus = SearchStatus.idle,
    this.errorMessage = '',
    this.weather = const {},
  });

  CitiesState copyWith({
    List<CityEntity>? saved,
    CityEntity? selected,
    List<CityEntity>? results,
    SearchStatus? searchStatus,
    String? errorMessage,
    Map<CityEntity, CityWeatherEntity>? weather,
  }) =>
      CitiesState(
        saved: saved ?? this.saved,
        selected: selected ?? this.selected,
        results: results ?? this.results,
        searchStatus: searchStatus ?? this.searchStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        weather: weather ?? this.weather,
      );

  @override
  List<Object?> get props => [saved, selected, results, searchStatus, errorMessage, weather];
}
