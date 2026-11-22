import 'package:dartz/dartz.dart';
import 'package:weather_app/core/core.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetCitiesWeather {
  final CityRepository repository;

  GetCitiesWeather({required this.repository});

  Future<Either<Failure, List<CityWeatherEntity>>> call(List<CityEntity> cities) =>
      repository.getCitiesWeather(cities);
}
