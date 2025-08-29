import 'dart:async';
import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _textAnimation;
  late Animation<double> _imageAnimation;
  // late Animation<Offset> _slideAnimation;
  late Timer _autoSlideTimer;
  final PageController _pageController = PageController();
  int index = 0;
  final List<OnboardingSlideDataModel> slides = [
    OnboardingSlideDataModel(
      title: "Pre-owned vacation must-haves nearby – save now!",
      image1: Assets.slideImg1a,
      image2: Assets.slideImg1b,
    ),
    OnboardingSlideDataModel(
      title: "Why pay full price for beach gear, weekend escape essentials,",
      image1: Assets.slideImg2a,
      image2: Assets.slideImg2b,
    ),
    OnboardingSlideDataModel(
      title: "Get Notified When Your Desired Product is Close to You!",
      image1: Assets.slideImg3a,
      image2: Assets.slideImg3b,
    )
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _textAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );

    _imageAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller, curve: Curves.fastEaseInToSlowEaseOut),
    );

    // _slideAnimation = Tween<Offset>(
    //   begin: const Offset(1, 0), // Start from the right
    //   end: const Offset(0, 0), // End at the center
    // ).animate(
    //   CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    // );

    // Start the auto-slide timer
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      nextSlide();
    });
    _pageController.addListener(() {
      setState(() {
        index = _pageController.page?.round() ?? 0;
      });
    });
    // Initial animation for the first slide
    _controller.forward();
  }

  void nextSlide() {
    setState(() {
      if (index < slides.length - 1) {
        index++;
      } else {
        index = 0; // Loop back to the first slide
      }
    });
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    _controller.reset();
    _controller.forward();
  }

  void onTapChange(i) {
    _controller.reset();
    _controller.forward();
    _autoSlideTimer.cancel();
    index = i;
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      nextSlide();
    });
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _autoSlideTimer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return ParallaxSlider();
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: context.colors.onPrimary,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(100.r)),
              child: Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _imageAnimation.value,
                        child: Image.asset(
                          slides[index].image2,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 130.r,
                      right: 90.r,
                      left: AppStyles.screenHorizontalPadding + 20,
                    ),
                    child: Column(
                      children: [
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _textAnimation.value,
                              child: GenericTranslateWidget(
                                slides[index].title,
                                style: context.textStyle.displayLarge!.copyWith(
                                    color: Colors.white, fontSize: 28.sp),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 70.r),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PagerDot(
                                length: slides.length, currentIndex: index),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: PageView.builder(
                      clipBehavior: Clip.none,

                      controller: _pageController,
                      // onPageChanged: (int pageIndex) {
                      //   setState(() {
                      //     index = pageIndex;
                      //   });
                      // },
                      itemCount: slides.length,
                      itemBuilder: (context, i) {
                        return Stack(
                          children: [
                            Positioned(
                                bottom: index == 0
                                    ? -10
                                    : index == 2
                                        ? -80
                                        : -90,
                                left: -120,
                                child: Image.asset(
                                  slides[index].image1,
                                  fit: BoxFit.cover,
                                  height: 580.h,
                                ))
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          10.ph,
          Padding(
            padding: EdgeInsets.all(AppStyles.screenHorizontalPadding),
            child: CustomButtonWidget(
              title: "Continue",
              onPressed: () {
                AppRouter.push(const LoginView());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingSlideDataModel {
  final String title;
  final String image1;
  final String image2;

  OnboardingSlideDataModel({
    required this.title,
    required this.image1,
    required this.image2,
  });
}

// class ParallaxSlider extends StatefulWidget {
//   @override
//   _ParallaxSliderState createState() => _ParallaxSliderState();
// }

// class _ParallaxSliderState extends State<ParallaxSlider> {
//   final PageController _pageController = PageController();
//   final List<String> contentList = [
//     "Content for Page 1",
//     "Content for Page 2",
//     "Content for Page 3",
//   ];

//   final String imageUrl =
//       'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080';

//   double _currentPage = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _pageController.addListener(() {
//       setState(() {
//         _currentPage = _pageController.page ?? 0.0;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Parallax Background Image
//           Positioned.fill(
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 double width = constraints.maxWidth;
//                 return Transform.translate(
//                   offset: Offset(
//                       -_currentPage * width * 0.3, 0), // Adjust parallax factor
//                   child: Image.network(
//                     imageUrl,
//                     fit: BoxFit.cover,
//                     loadingBuilder: (context, child, progress) {
//                       if (progress == null) return child;
//                       return Center(child: CircularProgressIndicator());
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       return Center(
//                         child: GenericTranslateWidget(
//                           "Failed to load image",
//                           style: TextStyle(color: Colors.red),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//           // Foreground Content with Slider
//           Column(
//             children: [
//               Expanded(
//                 child: PageView.builder(
//                   controller: _pageController,
//                   itemCount: contentList.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Card(
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Center(
//                           child: GenericTranslateWidget(
//                             contentList[index],
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ParallaxPageView extends StatefulWidget {
//   @override
//   _ParallaxPageViewState createState() => _ParallaxPageViewState();
// }

// class _ParallaxPageViewState extends State<ParallaxPageView> {
//   final PageController _pageController = PageController(viewportFraction: 0.8);

//   @override
//   Widget build(BuildContext context) {
//     final List<String> imagePaths = [
//       Assets.slideImg1a,
//       Assets.slideImg2a,
//       Assets.slideImg3a,
//     ];

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: PageView.builder(
//           controller: _pageController,
//           itemCount: imagePaths.length,
//           itemBuilder: (context, index) {
//             return AnimatedBuilder(
//               animation: _pageController,
//               builder: (context, child) {
//                 double value = 1.0;
//                 if (_pageController.position.haveDimensions) {
//                   value = _pageController.page! - index;
//                   value = (1 - (value.abs() * 0.25)).clamp(0.8, 1.0);
//                 }
//                 return Center(
//                   child: SizedBox(
//                     height: Curves.easeOut.transform(value) * 600,
//                     child: child,
//                   ),
//                 );
//               },
//               child: Container(
//                 margin:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage(imagePaths[index]),
//                     fit: BoxFit.cover,
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withValues(alpha:0.5),
//                       blurRadius: 10,
//                       offset: Offset(0, 5),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
