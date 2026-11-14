import 'package:dartz/dartz.dart';
import '../../../../core/errors/errors.dart';
import 'package:weather_app/features/weather/domain/entities/entities.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getWeather({
    required double lat,
    required double lon,
  });
}
