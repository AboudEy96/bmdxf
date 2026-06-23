import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:bmdxf/models/exif_data.dart';
import 'package:bmdxf/models/saved_image.dart';
import 'package:bmdxf/repositories/exif_repository.dart';
import 'package:bmdxf/services/image_database_service.dart';
import 'package:bmdxf/services/image_picker_service.dart';
import 'package:bmdxf/services/maps_service.dart';

class ExifViewModel extends ChangeNotifier {
  ExifViewModel({
    ExifRepository? repository,
    ImagePickerService? pickerService,
    MapsService? mapsService,
    ImageDatabaseService? databaseService,
  })  : _repository = repository ?? ExifRepository.instance,
        _pickerService = pickerService ?? ImagePickerServiceImpl.instance,
        _mapsService = mapsService ?? GoogleMapsService.instance,
        _databaseService =
            databaseService ?? SqliteImageDatabaseService.instance;

  final ExifRepository _repository;
  final ImagePickerService _pickerService;
  final MapsService _mapsService;
  final ImageDatabaseService _databaseService;

  Uint8List? _imageBytes;
  ExifData? _exifData;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSaving = false;
  String? _saveMessage;
  List<SavedImage> _savedImages = [];
  bool _isLoadingHistory = false;

  Uint8List? get imageBytes => _imageBytes;
  ExifData?  get exifData   => _exifData;
  bool       get isLoading  => _isLoading;
  String?    get errorMessage => _errorMessage;

  bool get isSaving => _isSaving;
  String? get saveMessage => _saveMessage;
  List<SavedImage> get savedImages => List.unmodifiable(_savedImages);
  bool get isLoadingHistory => _isLoadingHistory;

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

  Future<void> saveCurrentImage({String? label}) async {
    final bytes = _imageBytes;
    if (bytes == null) return;

    _isSaving = true;
    _saveMessage = null;
    notifyListeners();

    try {
      await _databaseService.saveImage(
        SavedImage(
          imageBytes: bytes,
          exifData: _exifData,
          savedAt: DateTime.now(),
          label: label,
        ),
      );
      _isSaving = false;
      _saveMessage = 'Image saved to local database.';
    } catch (e) {
      _isSaving = false;
      _saveMessage = 'Failed to save image: $e';
    }
    notifyListeners();
  }

  void clearSaveMessage() {
    _saveMessage = null;
    notifyListeners();
  }

  Future<void> loadSavedImages() async {
    _isLoadingHistory = true;
    notifyListeners();

    try {
      _savedImages = await _databaseService.getAllImages();
    } catch (e) {
      _saveMessage = 'Failed to load history: $e';
    }

    _isLoadingHistory = false;
    notifyListeners();
  }
  Future<void> deleteSavedImage(int id) async {
    await _databaseService.deleteImage(id);
    _savedImages = _savedImages.where((img) => img.id != id).toList();
    notifyListeners();
  }

  void viewSavedImage(SavedImage saved) {
    _isLoading = false;
    _errorMessage = saved.exifData == null
        ? 'No EXIF data found in this image.'
        : null;
    _imageBytes = saved.imageBytes;
    _exifData = saved.exifData;
    notifyListeners();
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
