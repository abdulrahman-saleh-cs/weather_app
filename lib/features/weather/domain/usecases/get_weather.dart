import 'package:dartz/dartz.dart';
import 'package:weather_app/core/core.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetWeather {
  final WeatherRepository repository;

  GetWeather({required this.repository});

  Future<Either<Failure, WeatherEntity>> call(WeatherParams params) async {
    return await repository.getWeather(
      lat: params.lat,
      lon: params.lon,
    );
  }
}

