/// Value Object — immutable GPS coordinates with helpers.
class GpsCoordinates {
  final double latitude;
  final double longitude;

  const GpsCoordinates({required this.latitude, required this.longitude});

  String get latFormatted => '${latitude.toStringAsFixed(6)}°';
  String get lngFormatted => '${longitude.toStringAsFixed(6)}°';

  Uri get googleMapsUri => Uri.parse(
      'https://www.google.com/maps/search/?api=1'
      '&query=${latitude.toStringAsFixed(6)},${longitude.toStringAsFixed(6)}');

  @override
  String toString() => 'GpsCoordinates($latFormatted, $lngFormatted)';

  @override
  bool operator ==(Object other) =>
      other is GpsCoordinates &&
      other.latitude == latitude &&
      other.longitude == longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);
}
