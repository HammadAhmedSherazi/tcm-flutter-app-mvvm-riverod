

import 'dart:ui';

import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  List<BottomItemDataModel> tabs = BottomItemDataModel.bottomTabsList;
  // bool _isLocationEnabled = false;

  /// Check if location services are enabled
  Future<void> _checkLocationServices() async {
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      // _isLocationEnabled = isEnabled;
    });

    if (!isEnabled) {
      _showEnableLocationDialog();
    }
  }

  /// Open Location Settings
  Future<void> _openLocationSettings() async {
    await Geolocator.openLocationSettings();
    _checkLocationServices(); // Re-check after user action
  }

  /// Show a dialog asking the user to enable location services
  void _showEnableLocationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const GenericTranslateWidget( "Enable Location"),
        content: const GenericTranslateWidget( "This app requires location services to be enabled."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close dialog
            child: const GenericTranslateWidget( "Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _openLocationSettings();
            },
            child: const GenericTranslateWidget( "Enable"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // appLog("app close");
          showExitDialog(context);
        }
      },
      child: 
    // !_isLocationEnabled
    //       ? Scaffold(
    //           body: Center(
    //             child: Padding(
    //               padding: EdgeInsets.symmetric(
    //                   horizontal: AppStyles.screenHorizontalPadding),
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                 Lottie.network(
    //    'https://assets5.lottiefiles.com/packages/lf30_editor_88iv.json',
    //   width: 150,
    //   height: 150,
    //   repeat: true,
    //   frameBuilder: (context, child, composition) {
    //     return composition == null
    //         ? const CustomLoadingWidget() // Show loading while fetching
    //         : child; // Show animation when ready
    //   },
    //   errorBuilder: (context, error, stackTrace) {
    //     return const Icon(Icons.error); // Show error indicator
    //   },
    // ),
    //                   10.ph,
    //                   GenericTranslateWidget( 
    //                       "This app requires location services to work properly.",
    //                       textAlign: TextAlign.center,
    //                       style: context.textStyle.displayMedium!
    //                           .copyWith(fontSize: 20.sp)),
    //                   10.ph,
    //                   CustomButtonWidget(
    //                     title: "Enable a Location",
    //                     onPressed: () {
    //                       _openLocationSettings();
    //                     },
    //                   )
    //                 ],
    //               ),
    //             ),
    //           ),
    //         )
    //       : 
          Consumer(builder: (context, ref, child) {
              final selectIndex = ref.watch(bottomIndexProvider);
              return Scaffold(
                backgroundColor: context.colors.primaryContainer,
                bottomNavigationBar: CustomBottomAppBarWidget(
                  bottomItems: tabs,
                  selectIndex: selectIndex,
                ),
                  // body: IndexedStack(
                  //   index: selectIndex, // The index of the child to display
                  //   children: List.generate(
                  //     tabs.length,
                  //     (index) => index == 2
                  //         ? Stack(
                  //             children: [
                  //               tabs[1]
                  //                   .widget, // Display the second tab's widget in the background
                  //               Positioned.fill(
                  //                 child: BackdropFilter(
                  //                   filter: ImageFilter.blur(
                  //                       sigmaX: 22.5,
                  //                       sigmaY: 22.5), // Blur effect
                  //                   child: Container(
                  //                     color: Colors
                  //                         .transparent, // Transparent background
                  //                   ),
                  //                 ),
                  //               ),
                  //               Positioned(
                  //                 top: 50.0,
                  //                 child: IconButton(
                  //                   onPressed: () {
                  //                     ref
                  //                         .read(bottomIndexProvider.notifier)
                  //                         .setIndex(
                  //                             0); // Go back to the first tab
                  //                   },
                  //                   icon: Container(
                  //                     width: 30.r,
                  //                     height: 30.r,
                  //                     decoration: const BoxDecoration(
                  //                       color: Colors.white,
                  //                       shape: BoxShape.circle,
                  //                     ),
                  //                     child: Icon(
                  //                       Icons.close,
                  //                       size: 23.r,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //               Positioned(
                  //                 bottom: 50.0,
                  //                 left: 0,
                  //                 right: 0,
                  //                 child: Padding(
                  //                   padding: EdgeInsets.symmetric(
                  //                     horizontal:
                  //                         AppStyles.screenHorizontalPadding,
                  //                   ),
                  //                   child: Column(
                  //                     children: [
                  //                       PurchasingOptionButtonWidget(
                  //                         icon: Assets.dollarCircleIcon,
                  //                         title: "Sell Your Pre-owned Product",
                  //                         onTap: () {
                  //                           AppRouter.push(
                  //                               const SellProductView());
                  //                         },
                  //                       ),
                  //                       10.ph,
                  //                       PurchasingOptionButtonWidget(
                  //                         icon: Assets.bagIcon,
                  //                         title: "Buy Your Desired Product",
                  //                         onTap: () {
                  //                           AppRouter.push(
                  //                               const BuyProductView());
                  //                         },
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           )
                  //         : tabs[index].widget,
                  //   ),
                  // ),
                body:selectIndex == 2?

  Stack(
      children: [
        tabs[1].widget, // Background blur from tab 1
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22.5, sigmaY: 22.5),
            child: Container(color: Colors.transparent),
          ),
        ),
        Positioned(
          top: 50.0,
          child: IconButton(
            onPressed: () {
              ref.read(bottomIndexProvider.notifier).setIndex(0);
            },
            icon: Container(
              width: 30.r,
              height: 30.r,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 23.r),
            ),
          ),
        ),
        Positioned(
          bottom: 50.0,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppStyles.screenHorizontalPadding,
            ),
            child: Column(
              children: [
                PurchasingOptionButtonWidget(
                  icon: Assets.dollarCircleIcon,
                  title: "Sell Your Pre-owned Product",
                  onTap: () {
                    AppRouter.push(const SellProductView());
                  },
                ),
                10.ph,
                PurchasingOptionButtonWidget(
                  icon: Assets.bagIcon,
                  title: "Buy Your Desired Product",
                  onTap: () {
                    AppRouter.push(const BuyProductView());
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    ):
 
    tabs[selectIndex].widget
  
              );
            }),
    );
  }
}

class PurchasingOptionButtonWidget extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;
  const PurchasingOptionButtonWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.screenwidth,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 18.r),
        height: 48.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(500.r),
            border: Border.all(
                width: 1, color: const Color.fromRGBO(0, 0, 0, 0.10)),
            color: Colors.white),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 23.r,
            ),
            10.pw,
            Expanded(
                child: GenericTranslateWidget( 
              title,
              style: context.textStyle.displayMedium,
            )),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 17.r,
            )
          ],
        ),
      ),
    );
  }
}

class BottomItemDataModel {
  late final String label;
  late final String selectIcon;
  late final String icon;
  late final Widget widget;

  BottomItemDataModel(
      {required this.label,
      required this.icon,
      required this.selectIcon,
      required this.widget});

  static final List<BottomItemDataModel> bottomTabsList = [
    BottomItemDataModel(
        label: "Home",
        icon: Assets.homeIcon,
        selectIcon: Assets.homeSelectIcon,
        widget: const HomeView()),
    BottomItemDataModel(
        label: "Marketplace",
        icon: Assets.marketIcon,
        selectIcon: Assets.marketSelectIcon,
        widget: const MarketView()),
    BottomItemDataModel(
        label: "Buy/Sell",
        icon: Assets.handShakeIcon,
        selectIcon: Assets.handShakeIcon,
        widget: const Center(
          child: GenericTranslateWidget( "Buy/Sell View"),
        )),
    BottomItemDataModel(
        label: "Vendor",
        icon: Assets.venderIcon,
        selectIcon: Assets.venderSelectIcon,
        widget: const VenderView()),
    BottomItemDataModel(
        label: "Community",
        icon: Assets.communityIcon,
        selectIcon: Assets.communitySelectIcon,
        widget: const CommunityView()),
  ];
}

Future<bool> showExitDialog(BuildContext context) async {
  return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const GenericTranslateWidget( "Are you sure you want to exit the app?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: GenericTranslateWidget( 
                "Cancel",
                style: context.textStyle.titleMedium!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: GenericTranslateWidget( "Exit",
                  style: context.textStyle.titleMedium!
                      .copyWith(fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      )) ??
      false; // Return false if dialog is dismissed without an option
}
