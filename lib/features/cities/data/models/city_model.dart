import 'package:weather_app/features/cities/domain/entities/entities.dart';

class CityModel extends CityEntity {
  const CityModel({
    required super.name,
    required super.country,
    required super.region,
    required super.latitude,
    required super.longitude,
  });

  /// Works for both the geocoding API result and our own saved JSON.
  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        name: json['name'] as String,
        country: (json['country'] as String?) ?? '',
        region: (json['admin1'] as String?) ?? '',
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
      );

  factory CityModel.fromEntity(CityEntity city) => CityModel(
        name: city.name,
        country: city.country,
        region: city.region,
        latitude: city.latitude,
        longitude: city.longitude,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'country': country,
        'admin1': region,
        'latitude': latitude,
        'longitude': longitude,
      };
}
