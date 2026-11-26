import 'package:weather_app/features/cities/domain/entities/entities.dart';

class CityModel extends CityEntity {
  const CityModel({
    required super.name,
    required super.country,
    required super.region,
    required super.latitude,
    required super.longitude,
    super.countryCode,
    super.population,
  });

  /// Works for both the geocoding API result and our own saved JSON.
  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        name: json['name'] as String,
        country: (json['country'] as String?) ?? '',
        countryCode: (json['country_code'] as String?) ?? '',
        region: (json['admin1'] as String?) ?? '',
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        population: (json['population'] as num?)?.toInt(),
      );

  factory CityModel.fromEntity(CityEntity city) => CityModel(
        name: city.name,
        country: city.country,
        countryCode: city.countryCode,
        region: city.region,
        latitude: city.latitude,
        longitude: city.longitude,
        population: city.population,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'country': country,
        'country_code': countryCode,
        'admin1': region,
        'latitude': latitude,
        'longitude': longitude,
        'population': population,
      };
}