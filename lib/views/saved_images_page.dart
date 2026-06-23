import 'package:flutter/material.dart' hide DataRow;
import 'package:bmdxf/models/saved_image.dart';
import 'package:bmdxf/theme/app_theme.dart';
import 'package:bmdxf/viewmodels/exif_viewmodel.dart';
import 'package:bmdxf/widgets/common_widgets.dart';

class SavedImagesPage extends StatefulWidget {
  const SavedImagesPage({super.key, required this.viewModel});

  final ExifViewModel viewModel;

  @override
  State<SavedImagesPage> createState() => _SavedImagesPageState();
}

class _SavedImagesPageState extends State<SavedImagesPage> {
  ExifViewModel get _vm => widget.viewModel;

  @override
  void initState() {
    super.initState();
    _vm.addListener(_onVmChanged);
    _vm.loadSavedImages();
  }

  @override
  void dispose() {
    _vm.removeListener(_onVmChanged);
    super.dispose();
  }

  void _onVmChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.appBar,
        foregroundColor: AppTheme.primary,
        title: const Text('Saved Images',
            style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1)),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_vm.isLoadingHistory) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primary),
      );
    }

    if (_vm.savedImages.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: InfoCard(
          icon: Icons.photo_library_outlined,
          iconColor: AppTheme.textMuted,
          title: 'No Saved Images',
          child: const Text(
            'Images you save from the reader page will show up here, '
                'stored locally in a SQLite database.',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: _vm.savedImages.length,
      itemBuilder: (context, index) => _buildTile(_vm.savedImages[index]),
    );
  }

  Widget _buildTile(SavedImage saved) {
    return GestureDetector(
      onTap: () {
        _vm.viewSavedImage(saved);
        Navigator.of(context).pop();
      },
      child: Container(
        decoration: AppTheme.cardDecoration(),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Expanded(
              child: Image.memory(
                saved.imageBytes,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _formatDate(saved.savedAt),
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        fontFamily: 'monospace',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _confirmDelete(saved),
                    child: const Icon(Icons.delete_outline,
                        size: 18, color: AppTheme.danger),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(SavedImage saved) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceAlt,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radius),
          side: BorderSide(color: AppTheme.primary.withOpacity(0.3)),
        ),
        title: const Text('Delete image?',
            style: TextStyle(color: AppTheme.primary)),
        content: const Text(
          'This will permanently remove the image and its EXIF data '
              'from the local database.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete',
                style: TextStyle(color: AppTheme.danger)),
          ),
        ],
      ),
    );

    if (confirmed == true && saved.id != null) {
      await _vm.deleteSavedImage(saved.id!);
    }
  }

  String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} '
        '${two(dt.hour)}:${two(dt.minute)}';
  }
}