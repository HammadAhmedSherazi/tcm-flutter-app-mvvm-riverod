import 'dart:async';


import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';


class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewConsumerState();
}

class _HomeViewConsumerState extends ConsumerState<HomeView> {
  final List<ProductDataModel> buyfromStore = [
    ProductDataModel(
        id: 1,
        productName: 'Pepsi S’mores collection 3 can',
        productImage: 'https://i.ibb.co/Rhm9Txj/image.png',
        productPrice: 1.50,
        status: "",
        categoryId: -1,
        isStoreProduct: true),
    ProductDataModel(
        id: 4,
        productName: 'Bold, vibrant 100% cotton beach towels.',
        productImage: 'https://i.ibb.co/2WLKNNS/image3.png',
        productPrice: 15.99,
        status: "",
        categoryId: -1,
        isStoreProduct: true),
    ProductDataModel(
        id: 11,
        productName: 'Holder Toothpaste Stand Bathroom ',
        productImage:
            'https://i.ibb.co/2nWcVzr/Holder-Toothpaste-Stand-Bathroom.png',
        productPrice: 19.99,
        status: "",
        categoryId: -1,
        isStoreProduct: true),
    ProductDataModel(
        id: 3,
        productName: 'Master Roll Eco Friendly Luxury Bamboo Toilet ',
        productImage: 'https://i.ibb.co/4FjzjWt/image-19.png',
        productPrice: 19.99,
        status: "",
        categoryId: -1,
        isStoreProduct: true),
    ProductDataModel(
        id: 3,
        productName: 'Prime Hydration Drink Variety Pack ',
        productImage: 'https://i.ibb.co/rZk39RC/prime.png',
        productPrice: 19.99,
        status: "",
        categoryId: -1,
        isStoreProduct: true),
    ProductDataModel(
        id: 5,
        productName: 'Red Bull Energy Drink 3 can',
        productImage: 'https://i.ibb.co/kSK3Jbw/1.png',
        productPrice: 2.99,
        status: "",
        categoryId: -1,
        isStoreProduct: true),
  ];

  @override
  void initState() {
    super.initState();
    appLog("HomeView initState");
    Future.delayed(Duration.zero, () {
      appLog("Run Apis");

      ref.read(productDataProvider).onDispose();
      final loc = ref.read(currentLocationProvider).currentLocation;
      if (loc.lat == 0.0 && loc.lat == 0.0) {
        ref.read(currentLocationProvider).checkLocationPermission();
      }

      ref.read(authRepoProvider).getBanner();
      ref.read(productDataProvider).getMainCategories(limit: null);
      ref.read(productDataProvider).getCartsItem();
    });
  }

  @override
  void didChangeDependencies() {
    Future.delayed(Duration.zero, () async {
      ref.read(chatRepoProvider).chatInit();
      ref.read(productDataProvider.notifier).clearCheckOutList();
    });

    super.didChangeDependencies();
  }

  // @override
  // void dispose() {
  //   Future.microtask(() {
  //     ref.read(productDataProvider.notifier).onDispose();
  //   });
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // final products = ref.watch(productDataProvider).nearByProducts;
    final productProvider = ref.watch(productDataProvider);
    final homeProductApiResponse =
        productProvider.homeProductsApiResponse.status;
    final isLoad = homeProductApiResponse == Status.loading ||
        homeProductApiResponse == Status.undertermined;
    final location = ref.watch(currentLocationProvider).currentLocation;
    if (location.lat != 0.0 &&
        location.lon != 0.0 &&
        homeProductApiResponse == Status.undertermined) {
      Future.delayed(Duration.zero, () {
        ref
            .read(productDataProvider)
            .getHomeProducts(limit: 10, lat: location.lat, long: location.lon);
      });
    }
    final bannerLoader = ref.watch(authRepoProvider).bannerApiResponse.status;
    final topBanner = List.from(ref
        .watch(authRepoProvider)
        .banners
        .where((element) => element.meta.bannerType == "top"));
    final bottomBanner = List.from(ref
        .watch(authRepoProvider)
        .banners
        .where((element) => element.meta.bannerType == "bottom"));

    return TabScreenTemplate(
      height: context.screenheight * 0.34,
      onRefresh: () async {
        final location = ref.watch(currentLocationProvider).currentLocation;
        if (location.lat == 0.0 && location.lon == 0.0) {
          ref.read(currentLocationProvider).checkLocationPermission();
        } else {
          ref
              .read(currentLocationProvider)
              .fetchWeatherOfCity(location.cityName);
        }

        ref.read(productDataProvider).getMainCategories(limit: null);
        ref.read(authRepoProvider).getBanner();
        ref.read(productDataProvider).getCartsItem();
        ref
            .read(productDataProvider)
            .getHomeProducts(limit: 10, lat: location.lat, long: location.lon);
      },
      tabIndex: 0,
      topImage: Assets.beachViewImage,
      childrens: homeProductApiResponse != Status.error
          ? [
              20.ph,
              Skeletonizer(
                  enabled: bannerLoader != Status.completed,
                  child: topBanner.isEmpty && bannerLoader == Status.loading
                      ? Container(
                          height: 105.h,
                          margin: EdgeInsets.symmetric(
                              horizontal: AppStyles.screenHorizontalPadding),
                          decoration: BoxDecoration(
                            // Use your primary color here
                            color: AppColors.reactionIconColor,
                            borderRadius: BorderRadius.circular(10.r),
                          ))
                      : AdSliderWidget(
                          images: List.from(
                              topBanner.map((e) => e.meta.imageUrl).toList()),
                        )),
              10.ph,
              CategoriesWidget(
                ref: ref,
                isShowTitle: true,
                index: 0,
              ),
              ProductDisplayWidget(
                showSeeAll: homeProductApiResponse == Status.completed &&
                    productProvider.preOwnedProducts.isNotEmpty &&
                    productProvider.preOwnedProducts.length >= 10,
                isLoad: isLoad,
                items: isLoad
                    ? productProvider.loadingProduct
                    : productProvider.preOwnedProducts,
                title: "Pre-owned Items Nearby",
                onTap: () {
                  AppRouter.push(const SearchProductView(
                    title: "Pre-owned Items Nearby",
                    type: "Ad",
                  ));
                },
              ),
              // if (bottomBanner.isNotEmpty) ...[
              //   BannerWidget(
              //     image: bottomBanner.first.meta.imageUrl,
              //   ),
              // ],
              Skeletonizer(
                  enabled: bannerLoader != Status.completed,
                  child: bottomBanner.isEmpty && bannerLoader == Status.loading
                      ? Container(
                          height: 200.h,
                          margin: EdgeInsets.symmetric(
                              horizontal: AppStyles.screenHorizontalPadding),
                          decoration: const BoxDecoration(
                            // Use your primary color here
                            color: AppColors.reactionIconColor,
                          ))
                      : bottomBanner.isNotEmpty
                          ? BannerWidget(
                              image: bottomBanner.first.meta.imageUrl,
                            )
                          : const SizedBox.shrink()),

              ProductDisplayWidget(
                showSeeAll: homeProductApiResponse == Status.completed &&
                    productProvider.discountedProducts.isNotEmpty &&
                    productProvider.discountedProducts.length >= 10,
                isLoad: isLoad,
                items: isLoad
                    ? productProvider.loadingProduct
                    : productProvider.discountedProducts,
                title: "Under \$10 Products",
                isUnder10: true,
                onTap: () {
                  AppRouter.push(const SearchProductView(
                    title: "Under \$10 Products",
                    type: "Ad",
                    under10: true,
                  ));
                },
              ),

              OfferWidget(
                isLoad: isLoad,
                items: isLoad
                    ? productProvider.loadingProduct
                    : productProvider.dealProducts,
              ),
              // ProductDisplayWidget(
              //   items: buyfromStore,
              //   showAddCard: true,
              //   title: "Buy from Stores",
              //   onTap: () {
              //     AppRouter.push(SearchProductView(
              //       title: "Buy from Stores",
              //       products: buyfromStore,
              //     ));
              //   },
              // ),
              ProductDisplayWidget(
                showSeeAll: homeProductApiResponse == Status.completed &&
                    productProvider.discountedProducts.isNotEmpty &&
                    productProvider.discountedProducts.length >= 10,
                isLoad: isLoad,
                items: isLoad
                    ? productProvider.loadingProduct
                    : productProvider.storeProducts,
                title: "Buy from Stores",
                onTap: () {
                  AppRouter.push(const SearchProductView(
                    title: "Buy from Stores",
                    type: "Store",
                  ));
                },
              ),
            ]
          : [
              SizedBox(
                height: context.screenheight * 0.5,
                child: CustomErrorWidget(onPressed: () {
                  final location =
                      ref.read(currentLocationProvider).currentLocation;
                  ref.read(productDataProvider).getHomeProducts(
                      limit: 5, lat: location.lat, long: location.lon);
                }),
              )
            ],
    );
  }
}

class OfferWidget extends StatelessWidget {
  final bool isLoad;
  final List<ProductDataModel> items;
  const OfferWidget({
    super.key,
    this.isLoad = false,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return items.isNotEmpty
        ? Container(
            height:context.screenheight * 0.28,
            padding: EdgeInsets.symmetric(
                horizontal: AppStyles.screenHorizontalPadding, vertical: 15.r),
            margin: EdgeInsets.only(bottom: 10.r),
            color: AppColors.primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: GenericTranslateWidget(
                      "Hurry! Vacation deals vanish fast!",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyle.displayMedium!
                          .copyWith(color: Colors.white, fontSize: 18.sp),
                    )),
                    if (items.isNotEmpty && items.length >= 10)
                      TextButton(
                          style: const ButtonStyle(
                              padding: WidgetStatePropertyAll(EdgeInsets.zero),
                              visualDensity: VisualDensity(
                                  vertical: -4.0, horizontal: -4.0)),
                          onPressed: () {
                            AppRouter.push(const SearchProductView(
                              title: "Vanish Deals Product",
                              type: "Ad",
                              isVanish: true,
                            ));
                          },
                          child: GenericTranslateWidget(
                            "See All",
                            style: context.textStyle.bodyMedium!
                                .copyWith(color: Colors.white),
                          ))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: GenericTranslateWidget(
                      "These pre-owned vacation treasures disappear soon",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyle.bodyMedium!
                          .copyWith(color: Colors.white),
                    ))
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,

                    itemCount: items.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                      top: 30.r,
                    ),
                    physics:
                        const ClampingScrollPhysics() // Horizontal scrolling without overflow
                    , // Disable scrolling if it's vertical
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          1, // Single column horizontally, 2 columns vertically
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 1.0,
                      childAspectRatio:
                          0.65.r, // Adjust aspect ratio based on layout
                    ),
                    itemBuilder: (context, index) {
                      return Skeletonizer(
                        enabled: isLoad,
                        child: GestureDetector(
                          onTap: () {
                            AppRouter.push(ProductDetailView(
                              productId: items[index].id!,
                              categoryId: items[index].categoryId!,
                              isVanish: true,
                            ));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.r, vertical: 6.r),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.r)),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Spacer(),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.r),
                                          height: 22.h,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              gradient:
                                                  AppColors.primaryGradinet,
                                              borderRadius:
                                                  BorderRadius.circular(500.r)),
                                          child: isLoad ? Text( 
                                            Helper.timeLeft(
                                                items[index].checkOut!),
                                            style: context.textStyle.bodySmall!
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 10.sp),
                                          ) :  GenericTranslateWidget( 
                                            Helper.timeLeft(
                                                items[index].checkOut!),
                                            style: context.textStyle.bodySmall!
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 10.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                                    3.ph,
                                    SizedBox(
                                      height: 45.h,
                                      child: GenericTranslateWidget( items[index].productName!,
                                          style: context.textStyle.labelMedium,
                                          maxLines: 2,
                                          overflow: TextOverflow.visible),
                                    ),
                                    const Spacer(),
                                    isLoad ? Text( 
                                      "\$${items[index].productPrice}",
                                      style: context.textStyle.displayMedium!
                                          .copyWith(fontSize: 18.sp),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ):
                                    GenericTranslateWidget( 
                                      "\$${items[index].productPrice}",
                                      style: context.textStyle.displayMedium!
                                          .copyWith(fontSize: 18.sp),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer()
                                  ],
                                )),
                                10.pw,
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: DisplayNetworkImage(
                                    height: context.screenheight,
                                    imageUrl: items[index].productImage!,
                                    width: 84.r,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}

class BannerWidget extends StatelessWidget {
  final String image;

  const BannerWidget({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRouter.push(const BuyProductView());
      },
      child: Container(
        height: 200.h,
        margin: EdgeInsets.only(bottom: 10.r),
        decoration: BoxDecoration(
            image:
                DecorationImage(image: NetworkImage(image), fit: BoxFit.cover)),
      ),
    );
  }
}

class ProductDisplayWidget extends StatelessWidget {
  final String title;
  final List<ProductDataModel> items;
  final VoidCallback? onTap;
  final bool? showSeeAll;
  final bool? showAddCard;
  final double? height;
  final bool isLoad;
  final Function? fun;
  final bool? isUnder10;
  const ProductDisplayWidget(
      {super.key,
      required this.title,
      required this.items,
      this.onTap,
      this.showSeeAll = true,
      this.showAddCard = false,
      this.height,
      this.fun,
      this.isLoad = false,
      this.isUnder10});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 318.h,
      margin: EdgeInsets.only(bottom: 20.r),
      padding:
          EdgeInsets.symmetric(horizontal: AppStyles.screenHorizontalPadding),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: !showSeeAll! ? 10.h : 0.0,
        children: [
          Row(
            children: [
              Expanded(
                  child: GenericTranslateWidget(
                title,
                style:
                    context.textStyle.displayMedium!.copyWith(fontSize: 18.sp),
              )),
              if (showSeeAll!)
                TextButton(
                    onPressed: onTap,
                    style: const ButtonStyle(
                        padding: WidgetStatePropertyAll(EdgeInsets.zero),
                        visualDensity: VisualDensity(horizontal: -4.0)),
                    child: GenericTranslateWidget(
                      "See All",
                      style: context.textStyle.bodyMedium!
                          .copyWith(color: AppColors.primaryColor),
                    ))
            ],
          ),
          Expanded(
            child: items.isNotEmpty
                ?
                // ListView.builder(
                //     scrollDirection:
                //         Axis.horizontal, // Horizontal scrolling
                //     itemCount: items.length,
                //     shrinkWrap: true,
                //     padding: EdgeInsets.zero,
                //     physics:
                //         const ClampingScrollPhysics(), // Prevents unnecessary scrolling issues
                //     itemBuilder: (context, index) {
                //       return Padding(
                //         padding: EdgeInsets.only(
                //             right:
                //                 12.r), // Maintain spacing like GridView
                //         child: Skeletonizer(
                //           enabled: isLoad,
                //           child: ProductItemCard(
                //             product: items[index],
                //             isAddToCard: items[index].isStoreProduct,
                //             productId: items[index].id!,
                //             categoryId: items[index].categoryId ?? -1,
                //             fun: fun,
                //           ),
                //         ),
                //       );
                //     },
                //   )
                GridView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics:
                        const ClampingScrollPhysics() // Horizontal scrolling without overflow
                    , // Disable scrolling if it's vertical
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          1, // Single column horizontally, 2 columns vertically
                      mainAxisSpacing: 12.r,
                      crossAxisSpacing: 1.r,
                      childAspectRatio:
                          1.72.r, // Adjust aspect ratio based on layout
                    ),
                    itemBuilder: (context, index) {
                      return Skeletonizer(
                        enabled: isLoad,
                        child: ProductItemCard(
                          product: items[index],
                          isAddToCard: items[index].isStoreProduct,
                          productId: items[index].id!,
                          categoryId: items[index].categoryId ?? -1,
                          fun: fun,
                          isUnder10: isUnder10,
                          index: index,
                          list: items,
                          keyString: "",
                        ),
                      );
                    },
                  )
                : Center(
                    child: Column(
                    children: [
                      Lottie.asset(Assets.noCategoryAnimation,
                          repeat: true, width: 200.r, fit: BoxFit.fill),
                      const GenericTranslateWidget("No Product Found"),
                    ],
                  )),
          )
        ],
      ),
    );
  }
}

class AdSliderWidget extends StatefulWidget {
  final List<String> images;
  const AdSliderWidget({super.key, required this.images});

  @override
  State<AdSliderWidget> createState() => _AdSliderWidgetState();
}

class _AdSliderWidgetState extends State<AdSliderWidget> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Automatically transition images every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), _onTimerTick);
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onTimerTick(Timer timer) {
    if (widget.images.isNotEmpty) {
      if (_currentIndex < widget.images.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.images.isNotEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppStyles.screenHorizontalPadding),
            child: Column(
              children: [
                Container(
                  height: 105.h,
                  decoration: BoxDecoration(
                    color: Colors.blue, // Use your primary color here
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return DisplayNetworkImage(
                            imageUrl: widget.images[index]);
                      },
                    ),
                  ),
                ),
                7.ph,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PagerDot(
                      length: widget.images.length,
                      currentIndex: _currentIndex,
                      isCircle: true,
                    )
                  ],
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
