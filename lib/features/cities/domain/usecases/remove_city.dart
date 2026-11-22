import 'package:dartz/dartz.dart';
import 'package:weather_app/core/core.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class RemoveCity {
  final CityRepository repository;

  RemoveCity({required this.repository});

  Future<Either<Failure, Unit>> call(CityEntity city) => repository.removeCity(city);
}
