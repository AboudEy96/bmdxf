import 'package:flutter/material.dart' hide DataRow;
import 'package:bmdxf/models/exif_data.dart';
import 'package:bmdxf/models/gps_coordinates.dart';
import 'package:bmdxf/theme/app_theme.dart';
import 'package:bmdxf/viewmodels/exif_viewmodel.dart';
import 'package:bmdxf/widgets/common_widgets.dart';

class ExifReaderPage extends StatefulWidget {
  const ExifReaderPage({super.key});

  @override
  State<ExifReaderPage> createState() => _ExifReaderPageState();
}

class _ExifReaderPageState extends State<ExifReaderPage> {
  late final ExifViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = ExifViewModel();
    _vm.addListener(_onVmChanged);
  }

  @override
  void dispose() {
    _vm.removeListener(_onVmChanged);
    _vm.dispose();
    super.dispose();
  }

  void _onVmChanged() => setState(() {});

  // ── Build ─────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        title: const Text('EXIF Location Reader',
            style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPickerRow(),
            const SizedBox(height: 16),
            if (_vm.hasImage) _buildPreview(),
            const SizedBox(height: 16),
            if (_vm.isLoading)
              const Center(child: CircularProgressIndicator()),
            if (_vm.errorMessage != null)
              _buildNotice(_vm.errorMessage!),
            if (_vm.hasGps) ...[
              _buildGpsCard(_vm.exifData!.gps!),
              const SizedBox(height: 12),
            ],
            if (_vm.showNoGpsBanner) _buildNoGpsBanner(),
            if (_vm.hasExif && _vm.exifData!.hasCameraInfo) ...[
              const SizedBox(height: 12),
              _buildCameraCard(_vm.exifData!),
            ],
            if (_vm.hasExif && _vm.exifData!.hasShotSettings) ...[
              const SizedBox(height: 12),
              _buildShotCard(_vm.exifData!),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }


  Widget _buildPickerRow() {
    return Row(children: [
      Expanded(
        child: PrimaryButton(
          icon: Icons.photo_library,
          label: 'Gallery',
          onTap: _vm.pickFromGallery,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: PrimaryButton(
          icon: Icons.camera_alt,
          label: 'Camera',
          onTap: _vm.pickFromCamera,
        ),
      ),
    ]);
  }

  Widget _buildPreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.radius),
      child: Image.memory(
        _vm.imageBytes!,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildNotice(String message) {
    return InfoCard(
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.orange,
      title: 'Notice',
      child: Text(message, style: const TextStyle(color: Colors.black87)),
    );
  }

  Widget _buildGpsCard(GpsCoordinates gps) {
    return InfoCard(
      icon: Icons.location_on,
      iconColor: Colors.red,
      title: 'GPS Location',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DataRow('Latitude',  gps.latFormatted),
          DataRow('Longitude', gps.lngFormatted),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _vm.openInMaps,
              icon: const Icon(Icons.map, size: 18),
              label: const Text('Open in Google Maps'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoGpsBanner() {
    return const InfoCard(
      icon: Icons.location_off,
      iconColor: Colors.grey,
      title: 'No GPS Data',
      child: Text(
        'This image has no GPS coordinates embedded. '
        'Try a photo taken on a phone with location enabled.',
        style: TextStyle(color: Colors.black54),
      ),
    );
  }

  Widget _buildCameraCard(ExifData data) {
    return InfoCard(
      icon: Icons.camera,
      iconColor: AppTheme.primary,
      title: 'Camera Info',
      child: Column(children: [
        if (data.make != null)     DataRow('Make',        data.make!),
        if (data.model != null)    DataRow('Model',       data.model!),
        if (data.dateTime != null) DataRow('Date / Time', data.dateTime!),
        if (data.hasResolution)    DataRow('Resolution',  data.resolution),
        if (data.orientation != null) DataRow('Orientation', data.orientation!),
      ]),
    );
  }

  Widget _buildShotCard(ExifData data) {
    return InfoCard(
      icon: Icons.tune,
      iconColor: Colors.teal,
      title: 'Shot Settings',
      child: Column(children: [
        if (data.exposureTime != null) DataRow('Exposure',     data.exposureTime!),
        if (data.fNumber != null)      DataRow('Aperture',     'f/${data.fNumber!}'),
        if (data.iso != null)          DataRow('ISO',          data.iso!),
        if (data.focalLength != null)  DataRow('Focal Length', data.focalLength!),
        if (data.flash != null)        DataRow('Flash',        data.flash!),
      ]),
    );
  }
}
