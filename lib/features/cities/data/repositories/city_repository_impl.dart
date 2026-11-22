import 'package:dartz/dartz.dart';
import 'package:weather_app/core/core.dart';
import 'package:weather_app/features/cities/domain/domain.dart';
import '../data_sources/data_sources.dart';
import '../models/models.dart';

class CityRepositoryImpl implements CityRepository {
  final CitiesRemoteDataSource remoteDataSource;
  final CitiesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CityRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  static const _cacheFailure = Failure(errMessage: 'Could not access saved cities', code: 'cache');

  /// Runs a network call with the connectivity check and error mapping.
  Future<Either<Failure, T>> _remote<T>(Future<T> Function() call) async {
    if (!await networkInfo.isConnected) {
      return const Left(Failure(errMessage: 'No internet connection', code: '0'));
    }
    try {
      return Right(await call());
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage, code: e.errorModel.status.toString()));
    } catch (_) {
      return const Left(Failure(errMessage: 'An unexpected error occurred', code: '500'));
    }
  }

  @override
  Future<Either<Failure, List<CityEntity>>> searchCities(String query) =>
      _remote<List<CityEntity>>(() => remoteDataSource.searchCities(query));

  @override
  Future<Either<Failure, List<CityWeatherEntity>>> getCitiesWeather(List<CityEntity> cities) =>
      _remote<List<CityWeatherEntity>>(() => remoteDataSource.getCitiesWeather(cities));

  @override
  Future<Either<Failure, List<CityEntity>>> getSavedCities() async {
    try {
      return Right(localDataSource.getSavedCities());
    } catch (_) {
      return const Left(_cacheFailure);
    }
  }

  @override
  Future<Either<Failure, Unit>> saveCity(CityEntity city) async {
    try {
      final saved = localDataSource.getSavedCities();
      if (!saved.contains(city)) {
        await localDataSource.saveCities([CityModel.fromEntity(city), ...saved]);
      }
      return const Right(unit);
    } catch (_) {
      return const Left(_cacheFailure);
    }
  }

  @override
  Future<Either<Failure, Unit>> removeCity(CityEntity city) async {
    try {
      final saved = localDataSource.getSavedCities();
      await localDataSource.saveCities([
        for (final c in saved)
          if (c != city) c,
      ]);
      return const Right(unit);
    } catch (_) {
      return const Left(_cacheFailure);
    }
  }

  @override
  Future<Either<Failure, CityEntity>> getSelectedCity() async {
    try {
      return Right(localDataSource.getSelectedCity() ?? CityEntity.defaultCity);
    } catch (_) {
      return const Left(_cacheFailure);
    }
  }

  @override
  Future<Either<Failure, Unit>> selectCity(CityEntity city) async {
    try {
      await localDataSource.saveSelectedCity(CityModel.fromEntity(city));
      return const Right(unit);
    } catch (_) {
      return const Left(_cacheFailure);
    }
  }
}
