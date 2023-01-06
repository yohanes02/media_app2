import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_app/component/toggle_line.dart';
import 'package:photo_manager/photo_manager.dart';

final selectedImages = StateProvider((ref) => <AssetEntity>[]);

class GalleryPage extends StatefulHookConsumerWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  ConsumerState<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends ConsumerState<GalleryPage> {
  CameraController? _controller;
  int? _selectedCameraIdx;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isRunning = false;

  List<AssetEntity>? _images;

  @override
  void initState() {
    super.initState();
    _fetchImages();
    initializeCamera();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  void initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _selectedCameraIdx = 0;
      _controller = CameraController(
          _cameras![_selectedCameraIdx!], ResolutionPreset.high);
      await _controller!.initialize();
      setState(() {});
    }
  }

  Future _fetchImages() async {
    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    if (albums != null) {
      final recentAlbum = albums.first;

      final recentAssets =
          await recentAlbum.getAssetListRange(start: 0, end: 300);
      // print("${recentAssets.length} Images");
      setState(() {
        _images = recentAssets;
      });
    }
  }

  Widget _buildCameraPreview() {
    if (_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_controller == null) {
      return Center(child: Text("Live Camera"));
    }
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: CameraPreview(_controller!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleLine(),
        _images == null || _images!.isEmpty
            ? const Text("Please wait, fetching images...")
            : Expanded(
                child: ListView(
                  children: [
                    GridView.count(
                      crossAxisCount: 3,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: _buildCameraPreview(),
                        ),
                        for (AssetEntity img in _images!)
                          InkWell(
                            onTap: () {
                              final images = ref.read(selectedImages);
                              // print("Images length: ${images.length}");
                              images.add(img);
                              ref
                                  .read(selectedImages.notifier)
                                  .update((state) => images.toList());
                            },
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  child: Center(
                                    child: AssetEntityImage(
                                      img,
                                      isOriginal: false, // Defaults to `true`.
                                      thumbnailSize: const ThumbnailSize.square(
                                          200), // Preferred value.
                                      fit: BoxFit.fitWidth,
                                      thumbnailFormat: ThumbnailFormat.jpeg,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    // alignment: Alignment.topRight,
                                    margin: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(50.0)),
                                      border: Border.all(color: Colors.black),
                                      color: Colors.transparent,
                                    ),
                                    width: 20,
                                    height: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
      ],
    );
  }
}

class GalleryPageBack extends HookConsumerWidget {
  const GalleryPageBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print("Images Rebuild");
    final selectedImg = ref.watch(selectedImages);
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: selectedImg.isEmpty
          ? Container()
          : GridView.count(
              crossAxisCount: 3,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                for (int i = 0; i < selectedImg.length; i++)
                  Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Center(
                      child: AssetEntityImage(
                        selectedImg[i],
                        isOriginal: false, // Defaults to `true`.
                        thumbnailSize:
                            const ThumbnailSize.square(200), // Preferred value.
                        fit: BoxFit.fitWidth,
                        thumbnailFormat: ThumbnailFormat.jpeg,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
