import 'package:dartz/dartz.dart';
import 'package:weather_app/core/core.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class SearchCities {
  final CityRepository repository;

  SearchCities({required this.repository});

  Future<Either<Failure, List<CityEntity>>> call(String query) => repository.searchCities(query);
}
