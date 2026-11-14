import 'package:dartz/dartz.dart';
import 'package:weather_app/core/core.dart';
import 'package:weather_app/features/weather/domain/domain.dart';
import '../data_sources/data_sources.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, WeatherEntity>> getWeather({
    required double lat,
    required double lon,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteWeather = await remoteDataSource.getWeather(lat: lat, lon: lon);
        return Right(remoteWeather);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage, code: e.errorModel.status.toString()));
      } catch (e) {
        return const Left(Failure(errMessage: 'An unexpected error occurred', code: '500'));
      }
    } else {
      return const Left(Failure(errMessage: 'No internet connection', code: '0'));
    }
  }
}
