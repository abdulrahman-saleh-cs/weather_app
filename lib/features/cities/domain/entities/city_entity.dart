class CityEntity {
  final String name;
  final String country;
  final String countryCode;
  final String region;
  final double latitude;
  final double longitude;

  /// `null` when the API does not know it (or for cities saved before this field existed).
  final int? population;

  const CityEntity({
    required this.name,
    required this.country,
    required this.region,
    required this.latitude,
    required this.longitude,
    this.countryCode = '',
    this.population,
  });

  /// City shown on first launch, before the user picks one.
  static const defaultCity = CityEntity(
    name: 'Benghazi',
    country: 'Libya',
    countryCode: 'LY',
    region: 'Banghazi',
    latitude: 32.11486,
    longitude: 20.06859,
  );

  /// "Region, Country" without empty parts.
  String get subtitle => [region, country].where((e) => e.isNotEmpty).join(', ');

  /// Two cities are the same place when their coordinates match, whatever the
  /// concrete class is (CityEntity or CityModel).
  @override
  bool operator ==(Object other) =>
      other is CityEntity && other.latitude == latitude && other.longitude == longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);
}