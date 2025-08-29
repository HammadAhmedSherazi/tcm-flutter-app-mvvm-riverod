import 'package:intl/intl.dart';
import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';

class TopWidget extends StatelessWidget {
  final int index;
  final String image;
  final double height;
 
  const TopWidget(
      {super.key,
      required this.index,
      required this.image,
      required this.height,
      });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
              image:
                  DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
        ),
        Container(
          height: height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x00F9F9F9),
                Color(0xFFF9F9F9), // #F9F9F9 (solid white)
                // rgba(249, 249, 249, 0) (fully transparent white)
              ],
              stops: [0.0, 0.9], // Gradient stops for each color
            ),
          ),
        ),
        Container(
          height: height,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: AppStyles.screenHorizontalPadding),
          child: Column(
            children: [
               50.ph,
                Row(
                  children: [
                    Expanded(child: Consumer(
                      builder: (_, WidgetRef ref, __) {
                        final location =
                            ref.watch(currentLocationProvider).currentLocation;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 10.w,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    AppRouter.push(const SelectLocationView(),
                                        fun: () {
                                      ref
                                          .read(productDataProvider)
                                          .getHomeProducts(
                                              limit: 10,
                                              lat: location.lat,
                                              long: location.lon);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6.r, vertical: 7.r),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(6.r),
                                        gradient: AppColors.primaryGradinet),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          Assets.locationIcon,
                                          width: 12.r,
                                          colorFilter: const ColorFilter.mode(
                                              Colors.white, BlendMode.srcIn),
                                        ),
                                        4.pw,
                                        GenericTranslateWidget(
                                          "Location",
                                          style: context.textStyle.displaySmall!
                                              .copyWith(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                
                               const LanguageChangeWidget(
                                  
                              )
                              ],
                            ),
                            5.ph,
                            Row(
                              children: [
                                Expanded(
                                  child: GenericTranslateWidget( 
                                    location.placeName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.textStyle.displayMedium,
                                  ),
                                ),
                              ],
                            ),
                            GenericTranslateWidget( 
                              location.cityName,
                              style: context.textStyle.bodyMedium,
                            )
                          ],
                        );
                      },
                    )),
                    // if (!showLocation!) ...[
                    //   CustomSearchBarWidget(hintText: "Search Product")
                    // ],
                    if (index == 0)
                      Row(
                        children: [
                          const CustomNotificationBadgetWidget(),
                          6.pw,
                          Consumer(
                            builder: (_, WidgetRef ref, __) {
                              return CustomMenuIconShape(
                                  icon: Assets.verticalMenuIcon,
                                  onTap: () {
                                    final location = ref
                                        .watch(currentLocationProvider)
                                        .currentLocation;
                                    AppRouter.push(const SettingView(),
                                        fun: () {
                                      ref
                                          .read(productDataProvider)
                                          .getHomeProducts(
                                              limit: 10,
                                              lat: location.lat,
                                              long: location.lon);
                                    });
                                  });
                            },
                          ),
                        ],
                      ),
                    if (index == 1) const CustomMessageBadgetWidget(),
                    if (index == 3) const CustomCartBadgeWidget()
                  ],
                ),
              
              
              const Spacer(),
             
              if (index == 0) ...[
                Consumer(
                  builder: (_, WidgetRef ref, __) {
                    final currentLocation = ref.watch(currentLocationProvider);
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Row(
                              children: [
                                GenericTranslateWidget( 
                                    currentLocation.apiResponse.data
                                            ?.weather?[0].main ??
                                        "",
                                    style:
                                        context.textStyle.bodySmall!.copyWith(
                                      height: 1,
                                    )),
                                // if (currentLocation.apiResponse.status ==
                                //     Status.completed)
                                //   Icon(
                                //     Icons.refresh,
                                //     size: 17.r,
                                //   )
                              ],
                            ),
                            RichText( 
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    // Temperature number with large font size
                                    TextSpan(
                                      text:
                                          currentLocation.apiResponse.status ==
                                                  Status.completed
                                              ? Helper.getCachedTranslation(ref: ref, text: Helper.celsiusToFahrenheit(
                                                      currentLocation
                                                          .apiResponse
                                                          .data!
                                                          .main!
                                                          .temp!)
                                                  .toStringAsFixed(2))
                                              : "----",
                                      style: context.textStyle.displayLarge!
                                          .copyWith(fontSize: 50.sp),
                                    ),
                                    if (currentLocation.apiResponse.status ==
                                        Status.completed)
                                      TextSpan(
                                        text: "\u00B0",
                                        style: context.textStyle.bodyLarge!
                                            .copyWith(fontSize: 50.sp),
                                      ),
                                    if (currentLocation.apiResponse.status ==
                                        Status.completed)
                                      TextSpan(
                                        text: "F",
                                        style: context.textStyle.bodySmall!
                                            .copyWith(fontSize: 18.sp),
                                      ),
                                  ],
                                )),
                          ],
                        ),
                        14.pw,
                        SizedBox(
                          height: 68.h,
                          child: VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: Colors.black.withValues(alpha: 0.08),
                          ),
                        ),
                        14.pw,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            10.ph,
                            GenericTranslateWidget( 
                              DateFormat('EEEE, d MMMM').format(DateTime.now()),
                              style: context.textStyle.bodyMedium,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(Assets.locationIcon),
                                5.pw,
                                GenericTranslateWidget( 
                                  currentLocation.currentLocation.cityName,
                                  style: context.textStyle.bodyMedium,
                                )
                              ],
                            )
                          ],
                        ),
                        const Spacer(),
                        Image.asset(
                          Assets.weatherIcon,
                          width: 77.r,
                          height: 77.r,
                        )

                        // Image.network(
                        //   "http://openweathermap.org/img/w/${currentLocation.apiResponse.data?.weather?[0].icon}.png",
                        //   errorBuilder: (context, error, stackTrace) =>
                        //       const SizedBox.shrink(),

                        //   // width: 77.r,
                        //   // height: 77.r,
                        // )
                      ],
                    );
                  },
                ),
              ],
              if (index == 0)
                Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        AppRouter.push(
                            CategoryProductView(category: null, index: index));
                      },
                      child: Container(
                        height: 44.h,
                        padding: EdgeInsets.symmetric(horizontal: 16.r),
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500.r),
                          border: Border.all(
                              width: 1,
                              color: const Color.fromRGBO(0, 0, 0, 0.10)),
                          color: const Color(0xffF6F6F6),
                        ),
                        child: Row(
                          children: [
                            GenericTranslateWidget( 
                              "Search any product",
                              style: context.textStyle.bodyMedium!.copyWith(
                                  color: Colors.black.withValues(alpha: 0.5)),
                            ),
                            10.pw,
                            Expanded(
                              child: Consumer(
                                builder: (_, WidgetRef ref, __) {
                                  final item = ref
                                      .watch(productDataProvider)
                                      .mainCategories
                                      .map((e) => e.title)
                                      .toList();
                                  return item.isNotEmpty
                                      ? AnimatedSearchText( texts: item)
                                      : const SizedBox.shrink();
                                },
                              ),
                            ),
                            // const Spacer(),
                            Image.asset(
                              Assets.searchIconGif,
                              width: 35.r,
                            )
                          ],
                        ),
                      ),
                    )),
                    8.pw,
                    const CustomCartBadgeWidget()
                  ],
                )
            
            ],
          ),
        )
      ],
    );
  }
}

class CustomBadgeWidget extends ConsumerWidget {
  final Widget child;
  final int? count;
  final bool? showBadge;
  const CustomBadgeWidget(
      {super.key, required this.child, this.count, this.showBadge = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Badge(
        isLabelVisible: showBadge!,
        backgroundColor: AppColors.bagdeColor,
        label: GenericTranslateWidget( "$count"),
        textStyle: context.textStyle.bodySmall!.copyWith(
          height: 0.9,
        ),
        child: child);
  }
}

// class WeatherIconWidget extends StatelessWidget {
//   final String weatherCode;

//   const WeatherIconWidget({super.key, required this.weatherCode});

//   @override
//   Widget build(BuildContext context) {
//     IconData icon;

//     // Map weather codes to icons
//     switch (weatherCode) {
//       // Clear sky
//       case '01d':
//         icon = WeatherIcons.day_sunny;
//         break;
//       case '01n':
//         icon = WeatherIcons.night_clear;
//         break;

//       // Few clouds
//       case '02d':
//         icon = WeatherIcons.day_cloudy;
//         break;
//       case '02n':
//         icon = WeatherIcons.night_alt_cloudy;
//         break;

//       // Scattered clouds
//       case '03d':
//         icon = WeatherIcons.cloudy;
//         break;
//       case '03n':
//         icon = WeatherIcons.cloudy;
//         break;

//       // Broken clouds
//       case '04d':
//         icon = WeatherIcons.cloud;
//         break;
//       case '04n':
//         icon = WeatherIcons.cloud;
//         break;

//       // Shower rain
//       case '09d':
//         icon = WeatherIcons.showers;
//         break;
//       case '09n':
//         icon = WeatherIcons.showers;
//         break;

//       // Rain
//       case '10d':
//         icon = WeatherIcons.rain;
//         break;
//       case '10n':
//         icon = WeatherIcons.rain;
//         break;

//       // Thunderstorm
//       case '11d':
//         icon = WeatherIcons.thunderstorm;
//         break;
//       case '11n':
//         icon = WeatherIcons.thunderstorm;
//         break;

//       // Snow
//       case '13d':
//         icon = WeatherIcons.snow;
//         break;
//       case '13n':
//         icon = WeatherIcons.snow;
//         break;

//       // Mist
//       case '50d':
//         icon = WeatherIcons.fog;
//         break;
//       case '50n':
//         icon = WeatherIcons.fog;
//         break;

//       // Default case for unknown weather codes
//       default:
//         icon = WeatherIcons.na; // Not Available icon
//     }

//     return Icon(
//       icon,
//       size: 38.r,
//       // Customize color if needed
//     );
//   }
// }
