import 'package:dartz/dartz.dart';
import 'package:weather_app/core/core.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetSelectedCity {
  final CityRepository repository;

  GetSelectedCity({required this.repository});

  Future<Either<Failure, CityEntity>> call() => repository.getSelectedCity();
}
