import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';

class FullScreenImageView extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImageView({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<FullScreenImageView> createState() => _FullScreenImageViewState();
}

class _FullScreenImageViewState extends State<FullScreenImageView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    index = widget.initialIndex;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int? index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.imageUrls.length,
              onPageChanged: (index) {
                setState(() {
                  this.index = index;
                });
              },
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  panEnabled: false, // Enable panning
                  scaleEnabled: true, // Enable zooming
                  boundaryMargin: const EdgeInsets.all(
                      20.0), // Allow some margin for panning
                  minScale:
                      0.5, // Minimum scale (similar to `PhotoViewComputedScale.contained`)
                  maxScale:
                      3.0, // Maximum scale (similar to `PhotoViewComputedScale.covered * 3.0`)
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.black), // Background color
                    child: Image.network(
                      widget.imageUrls[index],
                      fit: BoxFit.contain, // Ensure the image fits well
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: Icon(Icons.broken_image,
                            color: Colors.white, size: 50),
                      ),
                    ),
                  ),
                );

                //     PhotoView(
                //   imageProvider: NetworkImage(widget.imageUrls[index]),
                //   backgroundDecoration:
                //       const BoxDecoration(color: Colors.black),
                //   minScale: PhotoViewComputedScale.contained,
                //   maxScale: PhotoViewComputedScale.covered * 3.0,
                // );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GenericTranslateWidget( "${index! + 1}/${widget.imageUrls.length}",
                  style: context.textStyle.bodyMedium!
                      .copyWith(color: Colors.white)),
            ],
          ),
          10.ph,
          SizedBox(
            height: 70.h,
            width: double.infinity,
            child: ListView.separated(
                padding: EdgeInsets.symmetric(
                    horizontal: AppStyles.screenHorizontalPadding,
                    vertical: 5.r),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) => GestureDetector(
                      onTap: () {
                        index = i;
                        _pageController.jumpToPage(i);
                        setState(() {});
                      },
                      child: Container(
                        height: 62.r,
                        width: 65.r,
                        padding: index == i ? EdgeInsets.all(1.4.r) : null,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            gradient: AppColors.primaryGradinet),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r - 1.4.r),
                            child: DisplayNetworkImage(
                                imageUrl: widget.imageUrls[i])),
                      ),
                    ),
                separatorBuilder: (context, index) => 7.pw,
                itemCount: widget.imageUrls.length),
          ),
          40.ph
        ],
      ),
    );
  }
}
