import 'package:dartz/dartz.dart';
import 'package:weather_app/core/errors/errors.dart';
import '../entities/entities.dart';

abstract class CityRepository {
  Future<Either<Failure, List<CityEntity>>> searchCities(String query);

  /// Current weather for each city, in the same order as [cities].
  Future<Either<Failure, List<CityWeatherEntity>>> getCitiesWeather(List<CityEntity> cities);

  Future<Either<Failure, List<CityEntity>>> getSavedCities();
  Future<Either<Failure, Unit>> saveCity(CityEntity city);
  Future<Either<Failure, Unit>> removeCity(CityEntity city);
  Future<Either<Failure, CityEntity>> getSelectedCity();
  Future<Either<Failure, Unit>> selectCity(CityEntity city);
}
