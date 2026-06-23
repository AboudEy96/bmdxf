import 'dart:typed_data';
import 'exif_data.dart';
import 'gps_coordinates.dart';

class SavedImage {
  final int? id;
  final Uint8List imageBytes;
  final ExifData? exifData;
  final DateTime savedAt;
  final String? label;

  const SavedImage({
    this.id,
    required this.imageBytes,
    this.exifData,
    required this.savedAt,
    this.label,
  });

  SavedImage copyWith({int? id}) => SavedImage(
        id: id ?? this.id,
        imageBytes: imageBytes,
        exifData: exifData,
        savedAt: savedAt,
        label: label,
      );

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'image_bytes': imageBytes,
      'label': label,
      'saved_at': savedAt.toIso8601String(),
      'gps_lat': exifData?.gps?.latitude,
      'gps_lng': exifData?.gps?.longitude,
      'make': exifData?.make,
      'model': exifData?.model,
      'date_time': exifData?.dateTime,
      'width': exifData?.width,
      'height': exifData?.height,
      'orientation': exifData?.orientation,
      'flash': exifData?.flash,
      'focal_length': exifData?.focalLength,
      'exposure_time': exifData?.exposureTime,
      'f_number': exifData?.fNumber,
      'iso': exifData?.iso,
    };
  }

  factory SavedImage.fromMap(Map<String, Object?> map) {
    final lat = map['gps_lat'] as double?;
    final lng = map['gps_lng'] as double?;

    final hasAnyExif = map['make'] != null ||
        map['model'] != null ||
        map['date_time'] != null ||
        map['width'] != null ||
        map['height'] != null ||
        map['orientation'] != null ||
        map['flash'] != null ||
        map['focal_length'] != null ||
        map['exposure_time'] != null ||
        map['f_number'] != null ||
        map['iso'] != null ||
        (lat != null && lng != null);

    return SavedImage(
      id: map['id'] as int?,
      imageBytes: map['image_bytes'] as Uint8List,
      label: map['label'] as String?,
      savedAt: DateTime.parse(map['saved_at'] as String),
      exifData: hasAnyExif
          ? ExifData(
              gps: (lat != null && lng != null)
                  ? GpsCoordinates(latitude: lat, longitude: lng)
                  : null,
              make: map['make'] as String?,
              model: map['model'] as String?,
              dateTime: map['date_time'] as String?,
              width: map['width'] as String?,
              height: map['height'] as String?,
              orientation: map['orientation'] as String?,
              flash: map['flash'] as String?,
              focalLength: map['focal_length'] as String?,
              exposureTime: map['exposure_time'] as String?,
              fNumber: map['f_number'] as String?,
              iso: map['iso'] as String?,
            )
          : null,
    );
  }
}
