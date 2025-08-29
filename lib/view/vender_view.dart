import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';


class VenderView extends ConsumerStatefulWidget {
  const VenderView({super.key});

  @override
  ConsumerState<VenderView> createState() => _VenderViewConsumerState();
}

class _VenderViewConsumerState extends ConsumerState<VenderView> {
 
  @override
  void initState() {
    Future.microtask(() {
      ref.read(productDataProvider).onDispose();
      ref.read(productDataProvider).getTopStore(limit: 4);
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
   
    final venderProductApiResponse =
        productProvider.venderProductsApiResponse.status;
    final isLoad = venderProductApiResponse == Status.loading ||
        venderProductApiResponse == Status.undertermined;
    final storeApiStatus = productProvider.getTopStoresApiResponse.status;
    final isStoreLoad = storeApiStatus == Status.loading;
    final stores = isStoreLoad
        ? List.generate(
            4,
            (index) =>
                TopVenderDataModel(title: "sdsa", image: "sadadsa", id: 0),
          )
        : productProvider.topStores;
    final venderData = productProvider.venderProductsApiResponse.data;
    final location = ref.watch(currentLocationProvider).currentLocation;
    if (location.lat != 0.0 &&
        location.lon != 0.0 &&
        venderProductApiResponse == Status.undertermined) {
      Future.delayed(Duration.zero, () {
        ref.read(productDataProvider).getVenderProducts(
            limit: 10, lat: location.lat, long: location.lon);
      });
    }

    return TabScreenTemplate(
        tabIndex: 3,
        height: context.screenheight * 0.23,
        onRefresh: () async {
          ref.read(productDataProvider).getVenderProducts(
              limit: 10, lat: location. lat, long: location.lon);
          ref.read(productDataProvider).getTopStore(limit: 4);
        },
        topImage: Assets.venderTopViewImage,
        childrens: venderProductApiResponse != Status.error
            ? [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppStyles.screenHorizontalPadding),
                  child: CustomSearchBarWidget(
                    isArabic: languageCode == "ar",
                      onTap: () {
                        AppRouter.push(const CategoryProductView(
                            category: null, index: 2));
                      },
                      controller: TextEditingController(),
                      hintText: Helper.getCachedTranslation(ref: ref, text: "What are you looking for?")),
                ),
                CategoriesWidget(
                  ref: ref,
                  isShowTitle: false,
                  index: 2,
                ),
                if (isLoad) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppStyles.screenHorizontalPadding),
                    child: Row(
                      children: [
                        Expanded(
                            child: GenericTranslateWidget( 
                          "Most Sell Products",
                          style: context.textStyle.displayMedium!
                              .copyWith(fontSize: 18.sp),
                        )),
                      ],
                    ),
                  ),
                  20.ph,
                  VerticalProjectsDisplayLayoutWidget(
                    temp: productProvider.loadingProduct,
                    isLoad: true,
                    keyString: "",
                  ),
                  20.ph,
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppStyles.screenHorizontalPadding),
                    child: Row(
                      children: [
                        Expanded(
                            child: GenericTranslateWidget( 
                          "New Porduct on TCM",
                          style: context.textStyle.displayMedium!
                              .copyWith(fontSize: 18.sp),
                        )),
                      ],
                    ),
                  ),
                  20.ph,
                  VerticalProjectsDisplayLayoutWidget(
                    temp: productProvider.loadingProduct,
                    isLoad: true,
                    keyString: "",
                  ),
                ],
                if (venderProductApiResponse == Status.completed &&
                    venderData != null &&
                    venderData.mapData != null) ...[
                  ...List.generate(
                    venderData.mapData!.length + 1,
                    (index) {
                      final item = venderData.mapData!.entries
                          .elementAt(index > 1 ? index - 1 : index);
                      List<ProductDataModel> products = item.value;
                      return index == 1
                          ? stores.isNotEmpty &&
                                  storeApiStatus != Status.completed
                              ? Container(
                                  height: 196.h,
                                  margin: EdgeInsets.only(bottom: 20.r),
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          AppStyles.screenHorizontalPadding,
                                      vertical: 18.r),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: storeApiStatus != Status.error
                                          ? const Color(0xff0675D5)
                                          : Colors.white),
                                  child: storeApiStatus == Status.error
                                      ? CustomErrorWidget(onPressed: () {
                                          ref
                                              .read(productDataProvider)
                                              .getTopStore(limit: 4);
                                        })
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GenericTranslateWidget( "Top Big Vendor Store",
                                                style: context
                                                    .textStyle.displayMedium!
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 18.sp)),
                                            10.ph,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: List.generate(
                                                stores.length,
                                                (index) {
                                                  final item = stores[index];
                                                  return Skeletonizer(
                                                    enabled: isStoreLoad,
                                                    child: Column(
                                                      children: [
                                                        CircleAvatar(
                                                          maxRadius: 40.r,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: ClipOval(
                                                            child:
                                                                Image.network(
                                                              item.image,
                                                              width: 70.r,
                                                              height: 70.r,
                                                              fit: BoxFit.cover,
                                                              errorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return Icon(
                                                                  Icons.photo,
                                                                  color: Colors
                                                                      .grey,
                                                                  size: 40.r,
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        3.ph,
                                                        GenericTranslateWidget( 
                                                          item.title,
                                                          style: context
                                                              .textStyle
                                                              .labelMedium!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                )
                              : const SizedBox.shrink()
                          : Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          AppStyles.screenHorizontalPadding),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: GenericTranslateWidget( 
                                        item.key,
                                        style: context.textStyle.displayMedium!
                                            .copyWith(fontSize: 18.sp),
                                      )),
                                      if (products.isNotEmpty &&
                                          products.length >= 10)
                                        TextButton(
                                            onPressed: () {
                                              AppRouter.push(SearchProductView(
                                                title: item.key,
                                                categoryId: null,
                                                type: "Store",
                                              ));
                                            },
                                            style: const ButtonStyle(
                                                padding: WidgetStatePropertyAll(
                                                    EdgeInsets.zero),
                                                visualDensity: VisualDensity(
                                                    horizontal: -4.0)),
                                            child: GenericTranslateWidget( 
                                              "See All",
                                              style: context
                                                  .textStyle.bodyMedium!
                                                  .copyWith(
                                                      color: AppColors
                                                          .primaryColor),
                                            ))
                                    ],
                                  ),
                                ),
                                20.ph,
                                VerticalProjectsDisplayLayoutWidget(
                                  temp: products,
                                  isLoad: false,
                                  keyString: item.key,
                                ),
                                20.ph,
                              ],
                            );
                    },
                  )
                ],

                // 20.ph,
                // Padding(
                //   padding: EdgeInsets.symmetric(
                //       horizontal: AppStyles.screenHorizontalPadding),
                //   child: Row(
                //     children: [
                //       Expanded(
                //           child: GenericTranslateWidget( 
                //         "New Porduct on TCM",
                //         style: context.textStyle.displayMedium!
                //             .copyWith(fontSize: 18.sp),
                //       )),
                //     ],
                //   ),
                // ),
                // 20.ph,
                // VerticalProjectsDisplayLayoutWidget(
                //   temp: newTcmProducts,
                //   isLoad: false,

                // ),
              ]
            : [
                SizedBox(
                  height: context.screenheight * 0.6,
                  child: CustomErrorWidget(onPressed: () {
                    ref.read(productDataProvider).getVenderProducts(
                        limit: 10, lat: location.lat, long: location.lon);
                  }),
                )
              ]);
  }
}

class VerticalProjectsDisplayLayoutWidget extends StatelessWidget {
  const VerticalProjectsDisplayLayoutWidget(
      {super.key,
      required this.temp,
      required this.isLoad,
      this.fun,
      this.physics,
      this.isLoadMore = false,
      this.scrollController,
      required this.keyString,
      this.isFavourite = false});

  final List<ProductDataModel> temp;
  final bool isLoad;
  final bool? isLoadMore;
  final bool? isFavourite;
  final Function? fun;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final String keyString;

  @override
  Widget build(BuildContext context) {
    return temp.isNotEmpty
        ? GridView.builder(
            scrollDirection: Axis.vertical,
            controller: scrollController,
            itemCount: isLoadMore! ? temp.length + 1 : temp.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(
                left: AppStyles.screenHorizontalPadding,
                right: AppStyles.screenHorizontalPadding,
                bottom: 50.r),
            physics: physics ??
                const NeverScrollableScrollPhysics(), // Disable scrolling if it's vertical
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  2, // Single column horizontally, 2 columns vertically
              mainAxisSpacing: 12.r,
              crossAxisSpacing: 16.r,
              childAspectRatio: 0.83.r, // Adjust aspect ratio based on layout
            ),
            itemBuilder: (context, index) {
              return isLoadMore! && index == temp.length
                  ? const CustomLoadingWidget()
                  : Skeletonizer(
                      enabled: isLoad,
                      child: ProductItemCard(
                        product: temp[index],
                        isAddToCard: temp[index].isStoreProduct,
                        categoryId: temp[index].categoryId ?? -1,
                        productId: temp[index].id ?? -1,
                        isFavourite: isFavourite,
                        index: index,
                        list: temp,
                        fun: fun,
                        keyString: keyString,
                      ),
                    );
            },
          )
        : SizedBox(
            height: 200,
            width: context.screenwidth,
            child: Center(
                child: Column(
              children: [
                Lottie.asset(Assets.noCategoryAnimation,
                    repeat: true, width: 200.r, fit: BoxFit.fill),
                const GenericTranslateWidget( "No Product Found"),
              ],
            )),
          );
  }
}
