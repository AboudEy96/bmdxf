import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:bmdxf/models/exif_data.dart';
import 'package:bmdxf/repositories/exif_repository.dart';
import 'package:bmdxf/services/image_picker_service.dart';
import 'package:bmdxf/services/maps_service.dart';

class ExifViewModel extends ChangeNotifier {
  ExifViewModel({
    ExifRepository? repository,
    ImagePickerService? pickerService,
    MapsService? mapsService,
  })  : _repository = repository ?? ExifRepository.instance,
        _pickerService = pickerService ?? ImagePickerServiceImpl.instance,
        _mapsService = mapsService ?? GoogleMapsService.instance;

  final ExifRepository _repository;
  final ImagePickerService _pickerService;
  final MapsService _mapsService;

  Uint8List? _imageBytes;
  ExifData? _exifData;
  bool _isLoading = false;
  String? _errorMessage;

  Uint8List? get imageBytes => _imageBytes;
  ExifData?  get exifData   => _exifData;
  bool       get isLoading  => _isLoading;
  String?    get errorMessage => _errorMessage;

  bool get hasImage => _imageBytes != null;
  bool get hasExif  => _exifData != null;
  bool get hasGps   => _exifData?.gps != null;
  bool get showNoGpsBanner =>
      hasImage && !_isLoading && _errorMessage == null && !hasGps;

  // Commands
  Future<void> pickFromGallery() async {
    final bytes = await _pickerService.pickFromGallery();
    if (bytes != null) await _process(bytes);
  }

  Future<void> pickFromCamera() async {
    final bytes = await _pickerService.pickFromCamera();
    if (bytes != null) await _process(bytes);
  }

  Future<void> openInMaps() async {
    final gps = _exifData?.gps;
    if (gps != null) await _mapsService.openLocation(gps);
  }

  Future<void> _process(Uint8List bytes) async {
    _setState(loading: true, error: null, image: bytes, exif: null);

    try {
      final result = await _repository.parse(bytes);

      if (result == null) {
        _setState(loading: false, error: 'No EXIF data found in this image.');
      } else {
        _setState(loading: false, exif: result);
      }
    } catch (e) {
      _setState(loading: false, error: 'Error reading EXIF: $e');
    }
  }

  void _setState({
    bool? loading,
    String? error,
    Uint8List? image,
    ExifData? exif,
  }) {
    if (loading != null) _isLoading = loading;
    if (error != null || loading == false) _errorMessage = error;
    if (image != null) _imageBytes = image;
    if (exif != null || loading == true) _exifData = exif;
    notifyListeners();
  }
}
