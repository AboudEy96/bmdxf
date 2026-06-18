import 'dart:typed_data';
import 'package:exif/exif.dart' hide ExifData;
import 'package:bmdxf/models/exif_data.dart';
import 'package:bmdxf/models/gps_coordinates.dart';

class ExifRepository {
  // Singleton
  ExifRepository._();
  static final ExifRepository instance = ExifRepository._();

  Future<ExifData?> parse(Uint8List bytes) async {
    final tags = await readExifFromBytes(bytes);
    if (tags.isEmpty) return null;
    return _mapTags(tags);
  }

  ExifData _mapTags(Map<String, IfdTag> tags) {
    return ExifData(
      gps: _parseGps(tags),
      make: _tag(tags, 'Image Make'),
      model: _tag(tags, 'Image Model'),
      dateTime: _tag(tags, 'Image DateTime') ??
          _tag(tags, 'EXIF DateTimeOriginal'),
      width: _tag(tags, 'EXIF ExifImageWidth') ??
          _tag(tags, 'Image ImageWidth'),
      height: _tag(tags, 'EXIF ExifImageLength') ??
          _tag(tags, 'Image ImageLength'),
      orientation: _parseOrientation(_tag(tags, 'Image Orientation')),
      flash: _tag(tags, 'EXIF Flash'),
      focalLength: _tag(tags, 'EXIF FocalLength'),
      exposureTime: _tag(tags, 'EXIF ExposureTime'),
      fNumber: _tag(tags, 'EXIF FNumber'),
      iso: _tag(tags, 'EXIF ISOSpeedRatings'),
    );
  }

  String? _tag(Map<String, IfdTag> tags, String key) =>
      tags[key]?.printable;

  GpsCoordinates? _parseGps(Map<String, IfdTag> tags) {
    final lat = _dmsToDecimal(
        tags['GPS GPSLatitude'], tags['GPS GPSLatitudeRef']);
    final lng = _dmsToDecimal(
        tags['GPS GPSLongitude'], tags['GPS GPSLongitudeRef']);
    if (lat == null || lng == null) return null;
    return GpsCoordinates(latitude: lat, longitude: lng);
  }

  double? _dmsToDecimal(IfdTag? coord, IfdTag? ref) {
    if (coord == null) return null;
    try {
      final parts = coord.printable
          .replaceAll('[', '')
          .replaceAll(']', '')
          .split(', ');
      if (parts.length < 3) return null;

      final deg = _ratio(parts[0]);
      final min = _ratio(parts[1]);
      final sec = _ratio(parts[2]);
      double decimal = deg + (min / 60) + (sec / 3600);

      final hemisphere = ref?.printable ?? '';
      if (hemisphere == 'S' || hemisphere == 'W') decimal = -decimal;
      return decimal;
    } catch (_) {
      return null;
    }
  }

  double _ratio(String raw) {
    if (raw.contains('/')) {
      final parts = raw.split('/');
      return double.parse(parts[0]) / double.parse(parts[1]);
    }
    return double.parse(raw);
  }

  String? _parseOrientation(String? val) {
    const labels = {
      '1': 'Normal',       '2': 'Mirrored',
      '3': 'Rotated 180°', '4': 'Mirrored + 180°',
      '5': 'Mirrored + 90° CCW', '6': 'Rotated 90° CW',
      '7': 'Mirrored + 90° CW',  '8': 'Rotated 90° CCW',
    };
    return val != null ? (labels[val] ?? val) : null;
  }
}
