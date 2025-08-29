

import '../export_all.dart';

class MultiCaptureCameraScreen extends StatefulWidget {
  final int limit;
  const MultiCaptureCameraScreen({super.key, required this.limit});

  @override
  State<MultiCaptureCameraScreen> createState() =>
      _MultiCaptureCameraScreenState();
}

class _MultiCaptureCameraScreenState extends State<MultiCaptureCameraScreen> {
  CameraController? _controller;
  Future<void>? _initCameraFuture;
  List<File> capturedImages = [];
  ValueNotifier<bool> isLoad = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _initCameraFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras.first, ResolutionPreset.medium);
    return _controller!.initialize();
  }

  Future<void> _captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    
    try {
      if ( capturedImages.length < widget.limit) {
        isLoad.value = true;
        final file = await _controller!.takePicture();
        final dir = await getTemporaryDirectory();
        final newFile = await File(file.path)
            .copy('${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
        isLoad.value = false;
        setState(() => capturedImages.add(newFile));
      } else {
        Helper.showMessage("Maximum limit reached out!");
      }
    } catch (e) {
      isLoad.value = false;
      Helper.showMessage("$e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          if (capturedImages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: () {
                AppRouter.backWithData(capturedImages);
              },
            )
        ],
      ),
      body: FutureBuilder(
        future: _initCameraFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              _controller != null) {
            return Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(_controller!),
                Positioned(
                  bottom: kToolbarHeight + 40,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: capturedImages.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                                  AppRouter.push(FullImageView(imagePath: capturedImages[index].path));
                                },
                          child: Stack(
                            alignment: Alignment.topRight,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                width: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    capturedImages[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -10,
                                right: -2,
                                child: IconButton(
                                  icon: const Icon(Icons.cancel,
                                      size: 25, color: Colors.red),
                                  onPressed: () {
                                    setState(
                                        () => capturedImages.removeAt(index));
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: ValueListenableBuilder<bool>(
                      valueListenable: isLoad,
                      builder: (context, check, child) {
                        return Center(
                          child: FloatingActionButton(
                            backgroundColor: AppColors.primaryColor,
                            onPressed:!check? _captureImage : null,
                            child: check
                                ? const CustomLoadingWidget(
                                  color: Colors.white,

                                )
                                : const Icon(Icons.camera),
                          ),
                        );
                      }),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
