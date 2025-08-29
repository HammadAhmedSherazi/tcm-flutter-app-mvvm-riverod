import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';
import '../models/place_detail_model.dart';


class SetLocationRadiusView extends StatefulWidget {
  final bool? isEdit;
  const SetLocationRadiusView({super.key, this.isEdit});

  @override
  State<SetLocationRadiusView> createState() => _SetLocationRadiusViewState();
}

class _SetLocationRadiusViewState extends State<SetLocationRadiusView> {
  bool showSuggestion = false;
  PlaceDetailModel? location;
  setLocation(String id, WidgetRef ref) async {
    ref.read(googleMapApiProvider.notifier).getPlaceDetail(id).then((v) {
      location = v;

      setState(() {
        setLatLong(location?.result?.geometry?.location?.lat ?? 0.0,
            location?.result?.geometry?.location?.lng ?? 0.0);
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(
      () {
        googleMapController = controller;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            const CameraPosition(
                target: LatLng(40.71302519172581, -74.01013023107718),
                zoom: 15),
          ),
        );
      },
    );
  }

  setLatLong(double lat, double long) {
    final CameraUpdate cameraUpdate =
        CameraUpdate.newLatLng(LatLng(lat, long)); // Example position
    googleMapController?.moveCamera(cameraUpdate);
    googleMapController
        ?.animateCamera(cameraUpdate); // Animate to the camera update
  }

  GoogleMapController? googleMapController;
  final TextEditingController controller = TextEditingController();
  double _sliderValue = 0.5;
  @override
  Widget build(BuildContext context) {
    return CommonScreenTemplateWidget(
      title: "Set Location Radius",
      leadingWidget: const CustomBackButtonWidget(),
      appBarHeight: 150.h,
      bottomAppbarWidget: PreferredSize(
          preferredSize: Size.fromHeight(200.h),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppStyles.screenHorizontalPadding,
                vertical: AppStyles.screenHorizontalPadding),
            child: Consumer(
              builder: (_, WidgetRef ref, __) {
                 final languageCode = ref.watch(languageChangeNotifierProvider).currentLanguage.code;
   
                return CustomSearchBarWidget(
                  hintText: "Search Location",
                  isArabic: languageCode == "ar",
                  controller: controller,
                  onTap: () {
                    if (controller.text != "" && !showSuggestion) {
                      showSuggestion = true;
                      setState(() {});
                    }
                  },
                  onChanged: (c) {
                    if (c != "") {
                      showSuggestion = true;
                      Future.delayed(const Duration(milliseconds: 500), () {
                        ref.read(googleMapApiProvider).searchPlace(c);
                      });
                    } else {
                      showSuggestion = false;
                    }
                    setState(() {});
                  },
                );
              },
            ),
          )),
      child: Column(
        children: [
          Expanded(
              child: Stack(
            children: [
              CustomGoogleMapWidget(
                lat: 34.047016,
                long: -118.330215,
                location: location,
                onMapCreated: _onMapCreated,
                radiusCircle: {
                  Circle(
                    fillColor: Colors.blue.withAlpha(60),
                    strokeColor: Colors.transparent,
                    circleId: const CircleId("0"),
                    center: LatLng(
                        location?.result?.geometry?.location?.lat ?? 0.0,
                        location?.result?.geometry?.location?.lng ?? 0.0),
                    radius: _sliderValue * 7,
                  )
                },
              ),
              if (showSuggestion)
                Container(
                  height: context.screenheight * 0.3,
                  margin: EdgeInsets.only(left: 17.r, right: 17.r),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withAlpha(40),
                            offset: const Offset(0, 3),
                            blurRadius: 2,
                            spreadRadius: 1)
                      ]),
                  child: Consumer(
                    builder: (_, WidgetRef ref, __) {
                      final googleMapResponse = ref.watch(googleMapApiProvider);
                      return googleMapResponse.placeListApiResponse.status ==
                              Status.completed
                          ? googleMapResponse.placeListApiResponse.data !=
                                      null &&
                                  googleMapResponse.placeListApiResponse.data!
                                      .predictions!.isNotEmpty
                              ? ListView.builder(
                                  itemCount: googleMapResponse
                                      .placeListApiResponse
                                      .data!
                                      .predictions!
                                      .length,
                                  // shrinkWrap: true,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 17.r),
                                  itemBuilder: (context, index) => ListTile(
                                    onTap: () {
                                      controller.text = googleMapResponse
                                              .placeListApiResponse
                                              .data!
                                              .predictions![index]
                                              .description ??
                                          "";
                                      showSuggestion = false;
                                      setState(() {});
                                      setLocation(
                                          googleMapResponse
                                              .placeListApiResponse
                                              .data!
                                              .predictions![index]
                                              .placeId!,
                                          ref);
                                    },
                                    contentPadding: EdgeInsets.zero,
                                    horizontalTitleGap: -2.9,
                                    minLeadingWidth: 30.r,
                                    minTileHeight: 40.h,
                                    leading: SvgPicture.asset(
                                      Assets.locationIcon,
                                      width: 12.r,
                                      colorFilter: const ColorFilter.mode(
                                          Colors.red, BlendMode.srcIn),
                                    ),
                                    title: GenericTranslateWidget( 
                                      googleMapResponse
                                              .placeListApiResponse
                                              .data!
                                              .predictions![index]
                                              .description ??
                                          "",
                                      style: context.textStyle.bodyMedium!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: GenericTranslateWidget( "No Place Find"),
                                )
                          : googleMapResponse.placeListApiResponse.status ==
                                  Status.error
                              ? const Center(
                                  child: GenericTranslateWidget( "Something went wrong!"),
                                )
                              : const CustomLoadingWidget();
                    },
                  ),
                ),
            ],
          )),
          Container(
            padding: EdgeInsets.symmetric(
                // horizontal: AppStyles.screenHorizontalPadding,
                vertical: AppStyles.screenHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppStyles.screenHorizontalPadding),
                  child: Row(
                    children: [
                      Expanded(
                          child: GenericTranslateWidget( 
                        "Set a radius to get alerts for this product",
                        style: context.textStyle.bodyMedium!
                            .copyWith(fontSize: 16.sp),
                      ))
                    ],
                  ),
                ),
                10.ph,
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppStyles.screenHorizontalPadding),
                  child: GenericTranslateWidget( 
                    "${_sliderValue.toStringAsFixed(0)}miles",
                    style: context.textStyle.displayMedium!
                        .copyWith(fontSize: 18.sp),
                  ),
                ),
                Slider(
                  activeColor: context.colors.primary,

                  // padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10.r),
                  max: 50,
                  min: 0,
                  thumbColor: Colors.white,
                  inactiveColor: AppColors.borderColor,
                  value: _sliderValue,
                  onChanged: (value) {
                    _sliderValue = value;
                    setState(() {});
                  },
                ),
                10.ph,
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppStyles.screenHorizontalPadding),
                  child: Consumer(
                    builder: (_, WidgetRef ref, __) {
                      final isLoad = ref
                              .watch(productDataProvider)
                              .notifyApiResponse
                              .status ==
                          Status.loading;
                      return CustomButtonWidget(
                          title: widget.isEdit! ? "Update" : "Set Radius",
                          isLoad: isLoad,
                          onPressed: () async {
                            if (location == null) {
                              Helper.showMessage("Please select a location");
                            } else {
                                 final place = await ref
                                    .read(currentLocationProvider)
                                    .getLocationDetail(
                                        location!
                                            .result!.geometry!.location!.lat!,
                                        location!
                                            .result!.geometry!.location!.lng!);
                                if (place != null) {
                                  final LocationData loc = place;
                                  // appLog(
                                  //     "${loc} $radius ${ref.watch(productDataProvider).selectItemsId}");
                                  if(widget.isEdit!){
                                    ref
                                      .read(productDataProvider)
                                      .updateNotifyCategorySet(
                                          categoriesId: ref
                                              .watch(productDataProvider)
                                              .selectItemsId,
                                          radius: _sliderValue,
                                          location: loc);
                                  }
                                  else{
                                    if (context.mounted) {
                                    showFullScreenModal(
                                        context, location!, _sliderValue);
                                  }
                                  }
                                  
                                }
                               
                            }
                          });
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

void showFullScreenModal(
    BuildContext context, PlaceDetailModel location, double radius) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allows the modal to be full-screen
    backgroundColor: Colors.transparent, // Makes the background transparent
    builder: (BuildContext context) {
      return Stack(
        children: [
          Stack(alignment: Alignment.bottomCenter, children: [
            Positioned.fill(
              child: BackdropFilter(
                filter:
                    ImageFilter.blur(sigmaX: 21.5, sigmaY: 22.5), // Blur effect
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: PreferredSize(
                      preferredSize: Size.fromHeight(
                          AppBar().preferredSize.height + 200.h),
                      child: AppBar(
                        elevation: 0.0,
                        toolbarHeight: 150.h,
                        centerTitle: true,
                        title: GenericTranslateWidget( 
                          "Ready for Notifications",
                          style: context.textStyle.displayMedium!
                              .copyWith(fontSize: 18.sp),
                        ),
                        backgroundColor: Colors.transparent,
                        leading: const CustomBackButtonWidget(),
                        iconTheme: IconThemeData(size: 100.w),
                      )),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  Assets.mobileMockUpImage,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: context.screenwidth,
                height: 300.h,
                padding: EdgeInsets.all(25.r),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(200, 50),
                      topRight: Radius.elliptical(200, 50)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    GenericTranslateWidget( 
                      "Turn on notifications",
                      style: context.textStyle.displayMedium!
                          .copyWith(fontSize: 18.sp),
                    ),
                    10.ph,
                    Expanded(
                      child: GenericTranslateWidget( 
                        "Tap that button to turn on alerts and be the first to know when your desired product is back in stock. Your next favorite find is just a click away!",
                        textAlign: TextAlign.center,
                        style: context.textStyle.bodyMedium!.copyWith(
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    Consumer(
                      builder: (_, WidgetRef ref, __) {
                        final isLoad = ref
                                .watch(productDataProvider)
                                .notifyApiResponse
                                .status ==
                            Status.loading;
                        return CustomButtonWidget(
                            title: 'Turn on Notifications',
                            isLoad: isLoad,
                            onPressed: () async {
                              final place = await ref
                                  .read(currentLocationProvider)
                                  .getLocationDetail(
                                      location.result!.geometry!.location!.lat!,
                                      location
                                          .result!.geometry!.location!.lng!);
                              if (place != null) {
                                final LocationData loc = place;
                                // appLog(
                                //     "${loc} $radius ${ref.watch(productDataProvider).selectItemsId}");
                                ref.read(productDataProvider).notifyCategorySet(
                                    categoriesId: ref
                                        .watch(productDataProvider)
                                        .selectItemsId,
                                    radius: radius,
                                    location: loc);
                              }
                            });
                      },
                    )
                  ],
                ),
              ),
            )
          ])
        ],
      );
    },
  );
}
