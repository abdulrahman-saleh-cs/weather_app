import 'package:dartz/dartz.dart';
import 'package:weather_app/core/core.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetSavedCities {
  final CityRepository repository;

  GetSavedCities({required this.repository});

  Future<Either<Failure, List<CityEntity>>> call() => repository.getSavedCities();
}
