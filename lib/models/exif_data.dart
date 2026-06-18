import 'gps_coordinates.dart';

class ExifData {

  final GpsCoordinates? gps;

  final String? make;
  final String? model;
  final String? dateTime;
  final String? width;
  final String? height;
  final String? orientation;

  // Shot settings
  final String? flash;
  final String? focalLength;
  final String? exposureTime;
  final String? fNumber;
  final String? iso;

  const ExifData({
    this.gps,
    this.make,
    this.model,
    this.dateTime,
    this.width,
    this.height,
    this.orientation,
    this.flash,
    this.focalLength,
    this.exposureTime,
    this.fNumber,
    this.iso,
  });

  bool get hasCameraInfo =>
      make != null || model != null || dateTime != null || width != null;

  bool get hasShotSettings =>
      exposureTime != null ||
      fNumber != null ||
      iso != null ||
      focalLength != null ||
      flash != null;

  bool get hasResolution => width != null && height != null;

  String get resolution => '${width!} × ${height!}';
}
