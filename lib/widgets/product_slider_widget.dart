import 'dart:async';
import '../export_all.dart';

class ProductSliderWidget extends StatefulWidget {
  final List<String> slideImages;
  const ProductSliderWidget({super.key, required this.slideImages});

  @override
  State<ProductSliderWidget> createState() => _ProductSliderWidgetState();
}

class _ProductSliderWidgetState extends State<ProductSliderWidget> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    startSlider();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void startSlider() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % widget.slideImages.length;
          _pageController.animateToPage(
            _currentIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      fit: StackFit.expand,
      children: [
        ScrollConfiguration(
          behavior: MyBehavior(),
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.slideImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              _timer?.cancel();
              startSlider();
            },
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: widget.slideImages[index],
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Image.asset(
                  Assets.placeholderImage,
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  Assets.placeholderImage,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
        imageSlideDotWidget(),
      ],
    );
  }

  Widget imageSlideDotWidget() {
    return Positioned(
      bottom: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.slideImages.length, (index) {
          return InkWell(
            onTap: () {
              setState(() {
                _currentIndex = index;
                _pageController.jumpToPage(index);
                _timer?.cancel();
              });
              startSlider();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              height: 10,
              width: _currentIndex == index ? 24 : 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                // shape: currentIndex == index ? BoxShape.rectangle : BoxShape.circle,
                color: _currentIndex == index
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.4),
                // borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }),
      ),
    );
  }
}
