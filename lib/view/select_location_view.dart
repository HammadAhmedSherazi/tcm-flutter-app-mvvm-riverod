import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';
import '../models/place_detail_model.dart';



class SelectLocationView extends ConsumerStatefulWidget {
  // final ProductDataModel? product;
  final bool? isCheckoutProcess;
  const SelectLocationView({super.key, this.isCheckoutProcess = false});

  @override
  ConsumerState<SelectLocationView> createState() =>
      _SelectLocationViewConsumerState();
}

class _SelectLocationViewConsumerState
    extends ConsumerState<SelectLocationView> {
  TextEditingController controller = TextEditingController();
  bool showSuggestion = false;
  PlaceDetailModel? location;
  setLocation(
    String id,
  ) async {
    ref.read(googleMapApiProvider.notifier).getPlaceDetail(id).then((v) {
      location = v;

      setState(() {
        setLatLong(location?.result?.geometry?.location?.lat ?? 0.0,
            location?.result?.geometry?.location?.lng ?? 0.0);
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    final location = ref.read(currentLocationProvider).currentLocation;
    setState(
      () {
        googleMapController = controller;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(location.lat, location.lon), zoom: 15),
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

  @override
  void initState() {
    super.initState();
    final location = ref.read(currentLocationProvider).currentLocation;
    controller = TextEditingController(text: Helper.getCachedTranslation(ref: ref, text: location.placeName));

    setLatLong(location.lat, location.lon);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final googleMapResponse = ref.watch(googleMapApiProvider);
    final loc = ref.watch(currentLocationProvider).currentLocation;
     final languageCode = ref.watch(languageChangeNotifierProvider).currentLanguage.code;
   
    return CommonScreenTemplateWidget(
        leadingWidget: const CustomBackButtonWidget(),
        appBarHeight: 150.h,
        bottomAppbarWidget: PreferredSize(
            preferredSize: Size.fromHeight(200.h),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppStyles.screenHorizontalPadding,
                  vertical: AppStyles.screenHorizontalPadding),
              child: CustomSearchBarWidget(
                isArabic: languageCode == "ar",
                hintText: Helper.getCachedTranslation(ref: ref, text: "Search Location"),
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
              ),
            )),
        title: "Select Location",
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            if (showSuggestion) {
              showSuggestion = false;
              setState(() {});
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              CustomGoogleMapWidget(
                lat: location?.result?.geometry?.location?.lat ?? loc.lat,
                long: location?.result?.geometry?.location?.lng ?? loc.lon,
                location: location,
                onMapCreated: _onMapCreated,
                zoom: 13,
              ),
              Container(
                height: 165.h,
                width: double.infinity,
                padding: EdgeInsets.only(
                    top: 50.r,
                    left: AppStyles.screenHorizontalPadding,
                    right: AppStyles.screenHorizontalPadding),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withAlpha(2), // rgba(255, 255, 255, 0.00)
                    Colors.white, // #FFF
                  ],
                  stops: const [
                    0.0,
                    0.5
                  ], // First color at 0% and second color at 50%
                )),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButtonWidget(
                        title: "Select",
                        onPressed: () {
                          final loc = location?.result?.geometry?.location;
                          if (loc != null &&
                              loc.lat != null &&
                              loc.lng != null) {
                            if (!widget.isCheckoutProcess!) {
                              ref
                                  .read(currentLocationProvider)
                                  .changeLocation(loc.lat!, loc.lng!);
                            } else {
                              ref
                                  .read(productDataProvider)
                                  .selectDeliveryLocation(loc.lat!, loc.lng!);
                            }
                          } else {
                            if (widget.isCheckoutProcess!) {
                              final location = ref
                                  .watch(currentLocationProvider)
                                  .currentLocation;
                              ref
                                  .read(productDataProvider)
                                  .selectDeliveryLocation(
                                      location.lat, location.lon);
                            }
                          }
                          AppRouter.back();
                        }),
                  ],
                ),
              ),
              if (showSuggestion)
                Column(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          maxHeight: context.screenheight * 0.25,
                          minHeight: context.screenheight * 0.1),
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
                      child: googleMapResponse.placeListApiResponse.status ==
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
                                        googleMapResponse.placeListApiResponse
                                            .data!.predictions![index].placeId!,
                                      );
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
                              : const CustomLoadingWidget(),
                    ),
                  ],
                ),
            ],
          ),
        ));
  }
}
