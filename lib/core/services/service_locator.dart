import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:weather_app/core/core.dart';
import 'package:weather_app/features/cities/cities.dart';
import 'package:weather_app/features/weather/data/data.dart';
import 'package:weather_app/features/weather/domain/domain.dart';
import 'package:weather_app/features/weather/presentation/manager/manager.dart';

final getIt = GetIt.instance;

void setUp() {
  //! Features - Weather

  // Bloc
  getIt.registerFactory<WeatherCubit>(
    () => WeatherCubit(getWeatherUseCase: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton<GetWeather>(
    () => GetWeather(repository: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Data sources
  getIt.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(api: getIt()),
  );

  //! Features - Cities

  // Bloc
  getIt.registerFactory<CitiesCubit>(
    () => CitiesCubit(
      searchCities: getIt(),
      getCitiesWeather: getIt(),
      getSavedCities: getIt(),
      saveCity: getIt(),
      removeCity: getIt(),
      getSelectedCity: getIt(),
      selectCity: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<SearchCities>(() => SearchCities(repository: getIt()));
  getIt.registerLazySingleton<GetCitiesWeather>(() => GetCitiesWeather(repository: getIt()));
  getIt.registerLazySingleton<GetSavedCities>(() => GetSavedCities(repository: getIt()));
  getIt.registerLazySingleton<SaveCity>(() => SaveCity(repository: getIt()));
  getIt.registerLazySingleton<RemoveCity>(() => RemoveCity(repository: getIt()));
  getIt.registerLazySingleton<GetSelectedCity>(() => GetSelectedCity(repository: getIt()));
  getIt.registerLazySingleton<SelectCity>(() => SelectCity(repository: getIt()));

  // Repository
  getIt.registerLazySingleton<CityRepository>(
    () => CityRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Data sources
  getIt.registerLazySingleton<CitiesRemoteDataSource>(
    () => CitiesRemoteDataSourceImpl(api: getIt()),
  );
  getIt.registerLazySingleton<CitiesLocalDataSource>(
    () => CitiesLocalDataSourceImpl(cache: getIt()),
  );

  //! Core
  getIt.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: getIt()));
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));
  getIt.registerLazySingleton<CacheHelper>(() => CacheHelper());

  //! External
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => InternetConnection());
}
