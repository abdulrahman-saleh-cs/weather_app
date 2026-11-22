import 'package:equatable/equatable.dart';

class CityEntity extends Equatable {
  final String name;
  final String country;
  final String region;
  final double latitude;
  final double longitude;

  const CityEntity({
    required this.name,
    required this.country,
    required this.region,
    required this.latitude,
    required this.longitude,
  });

  /// City shown on first launch, before the user picks one.
  static const defaultCity = CityEntity(
    name: 'Benghazi',
    country: 'Libya',
    region: 'Banghazi',
    latitude: 32.11486,
    longitude: 20.06859,
  );

  /// "Region, Country" without empty parts.
  String get subtitle => [region, country].where((e) => e.isNotEmpty).join(', ');

  @override
  List<Object?> get props => [latitude, longitude];
}
