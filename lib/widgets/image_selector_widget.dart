



import '../export_all.dart';

typedef ImageSelectorCallback = Future<List<File>> Function();

class ImageSelector {
  static const int maxFileSize = 3 * 1024 * 1024; // 3MB
  static Future<List<File>> selectImages({
    required BuildContext context,
    int maxImages = 5,
    required Future<File?> Function(File originalFile) compressImageFn,
  }) async {
    final List<File>? selected = await showModalBottomSheet<List<File>>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const GenericTranslateWidget( 'Gallery'),
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                if (maxImages > 1) {
                  final List<XFile> files = await picker.pickMultiImage();
                  //   final FilePickerResult? result = await FilePicker.platform.pickFiles(
                  //   type: FileType.custom,
                  //   allowMultiple: maxImages > 1,
                  //   allowedExtensions: ['jpg', 'jpeg', 'png'],
                  // );
                  if (files.isEmpty) {
                    AppRouter.back();
                    return;
                  }

                  List<File> pickedFiles =
                      files.map((p) => File(p.path)).toList();
                  final images = await _processImages(
                    files: pickedFiles,
                    maxAllowed: maxImages,
                    compressImageFn: compressImageFn,
                  );
                  AppRouter.backWithData(images);
                } else {
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image == null) {
                    AppRouter.back();
                    return;
                  }
                  final compressedFile = await Helper.compressImage(File(image.path));
                   AppRouter.backWithData([compressedFile!]);
                }

                // ✅ return images
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const GenericTranslateWidget( 'Camera'),
              onTap: () async {
                final result = await Navigator.push<List<File>>(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MultiCaptureCameraScreen(
                            limit: maxImages,
                          )),
                );
                if (result == null || result.isEmpty) {
                  AppRouter.back();
                  return;
                }

                final images = await _processImages(
                  files: result,
                  maxAllowed: maxImages,
                  compressImageFn: compressImageFn,
                );
                AppRouter.backWithData(images); // ✅ return images
              },
            ),
          ],
        ),
      ),
    );

    return selected ?? []; // return result or empty list
  }

  static Future<List<File>> _processImages({
    required List<File> files,
    required int maxAllowed,
    required Future<File?> Function(File) compressImageFn,
  }) async {
    List<File> valid = [];
    int slots = maxAllowed;

    for (final file in files) {
      if (slots <= 0) break;

      final size = await file.length();
      if (size > maxFileSize) {
        debugPrint("'${file.path.split('/').last}' exceeds 3MB");
        continue;
      }

      final compressed = await compressImageFn(file);
      if (compressed != null) {
        valid.add(compressed);
        slots--;
      }
    }

    return valid;
  }
}
