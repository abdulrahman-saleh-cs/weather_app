import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:weather_app/core/core.dart';
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

  //! Core
  getIt.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: getIt()));
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  //! External
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => InternetConnection());
}
