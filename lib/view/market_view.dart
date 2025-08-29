
import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';

class MarketView extends ConsumerStatefulWidget {
  const MarketView({super.key});

  @override
  ConsumerState<MarketView> createState() => _MarketViewConsumerState();
}

class _MarketViewConsumerState extends ConsumerState<MarketView> {
  @override
  void initState() {
    Future.microtask( () {
      ref.read(productDataProvider).onDispose();
    
      final location = ref.read(currentLocationProvider).currentLocation;
      if(location.lat == 0.0 && location.lon == 0.0) {
        ref.read(currentLocationProvider).checkLocationPermission();
      }
      
    });
    super.initState();
  }
  //  @override
  // void dispose() {

  //   super.dispose();
  //   Future.microtask((){
  //     ref.read(productDataProvider.notifier).onDispose();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final productProvider = ref.watch(productDataProvider);
     final languageCode = ref.watch(languageChangeNotifierProvider).currentLanguage.code;
   
    final marketPlaceProductApiResponse =
        productProvider.marketPlaceProductsApiResponse.status;
    final isLoad = marketPlaceProductApiResponse == Status.loading ||
        marketPlaceProductApiResponse == Status.undertermined;
    final bannerLoader = ref.watch(authRepoProvider).bannerApiResponse.status;
    final marketData = productProvider.marketPlaceProductsApiResponse.data;
    final bottomBanner = List.from(ref
        .watch(authRepoProvider)
        .banners
        .where((element) => element.meta.bannerType == "bottom"));
    final location = ref.watch(currentLocationProvider).currentLocation;
    if (location.lat != 0.0 &&
        location.lon != 0.0 &&
        marketPlaceProductApiResponse == Status.undertermined) {
      Future.delayed(Duration.zero, () {
        ref.read(productDataProvider).getMarketPlaceProducts(
            limit: 10, lat: location.lat, long: location.lon);
      });
    }
    return TabScreenTemplate(
        tabIndex: 1,
        height: context.screenheight * 0.23,
        onRefresh: () async {
          ref.read(productDataProvider).getMarketPlaceProducts(
              limit: 10, lat: location.lat, long: location.lon);
        },
        topImage: Assets.marketTopViewImage,
        childrens: marketPlaceProductApiResponse != Status.error
            ? [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppStyles.screenHorizontalPadding),
                  child: CustomSearchBarWidget(
                    isArabic: languageCode == "ar",
                      onTap: () {
                        AppRouter.push(const CategoryProductView(
                            category: null, index: 1));
                      },
                      controller: TextEditingController(),
                      hintText: Helper.getCachedTranslation(ref: ref, text: "What are you looking for?")),
                ),
                CategoriesWidget(
                  ref: ref,
                  isShowTitle: false,
                  index: 1,
                ),
                if (isLoad) ...[
                  ProductDisplayWidget(
                    title: "Marketplace All Prodcuts",
                    showSeeAll: false,
                    isLoad: true,
                    items: productProvider.loadingProduct,
                  ),
                  OfferWidget(
                    isLoad: true,
                    items: productProvider.loadingProduct,
                  ),
                  ProductDisplayWidget(
                    title: "Pre-owned Products",
                    isLoad: true,
                    items: productProvider.loadingProduct,
                  ),
                ],
                if (marketPlaceProductApiResponse == Status.completed &&
                    marketData != null &&
                    marketData.mapData != null) ...[
                  ...List.generate(
                    marketData.mapData!.length,
                    (index) {
                      final item = marketData.mapData!.entries.elementAt(index);
                      List<ProductDataModel> products = item.value;
                      return item.key.toLowerCase() == "vanish deals"
                          ? OfferWidget(items: item.value)
                          : ProductDisplayWidget(
                              title: item.key,
                              isLoad: false,
                              showSeeAll:
                                  products.isNotEmpty && products.length >= 10,
                              items: products,
                              onTap: () {
                                if (products.isNotEmpty) {
                                  AppRouter.push(SearchProductView(
                                    title: item.key,
                                    categoryId:
                                        item.key.toLowerCase() == "all products"
                                            ? null
                                            : products.first.categoryId,
                                    type: "Ad",
                                  ));
                                }
                              },
                            );
                    },
                  )
                ],
                Skeletonizer(
                    enabled: bannerLoader != Status.completed,
                    child: bottomBanner.isEmpty &&
                            bannerLoader == Status.loading
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
              ]
            : [
                SizedBox(
                  height: context.screenheight * 0.6,
                  child: CustomErrorWidget(onPressed: () {
                    
                    ref.read(productDataProvider).getMarketPlaceProducts(
                        limit: 10, lat: location.lat, long: location.lon);
                  }),
                )
              ]);
  }
}
