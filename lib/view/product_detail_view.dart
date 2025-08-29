
import 'dart:ui';

import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';

class ProductDetailView extends ConsumerStatefulWidget {
  final int productId;
  final int categoryId;
  final bool? isVanish;
  final bool? isUnder10;

  const ProductDetailView(
      {super.key,
      required this.productId,
      required this.categoryId,
      this.isVanish,
      this.isUnder10});

  @override
  ConsumerState<ProductDetailView> createState() =>
      _ProductDetailViewConsumerState();
}

class _ProductDetailViewConsumerState extends ConsumerState<ProductDetailView> {
  @override
  void initState() {
    super.initState();
    final loc = ref.read(currentLocationProvider).currentLocation;

    Future.delayed(Duration.zero, () {
      ref.read(chatRepoProvider).setResponse();
      ref.read(productDataProvider).getProductDetails(id: widget.productId);
      
      if (widget.categoryId > -1) {
        ref.read(productDataProvider.notifier).getSimilarProducts(
            adId: widget.productId,
            id: widget.categoryId,
            lat: loc.lat,
            limit: 10,
            long: loc.lon);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(productDataProvider);
    final isLoad = provider.similarProductsApiResponse.status;
    final isLoad2 = provider.productDetailApiResponse.status;
    final products = isLoad == Status.loading
        ? ref.watch(productDataProvider).loadingProduct
        : ref.watch(productDataProvider).similarProducts;
    final ProductDetailDataModel? data = provider.productDetailApiResponse.data;
    final isFavourite = provider.isFavourite;
    return isLoad2 == Status.loading && data == null
        ? Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: const CustomLoadingWidget())
        : isLoad2 == Status.completed && data != null
            ? RefreshIndicator(
                onRefresh: () async {
                  final loc =
                      ref.watch(currentLocationProvider).currentLocation;
                  ref
                      .read(productDataProvider)
                      .getProductDetails(id: widget.productId);

                  ref.read(productDataProvider.notifier).getSimilarProducts(
                      adId: widget.productId,
                      id: widget.categoryId,
                      lat: loc.lat,
                      limit: 10,
                      long: loc.lon);
                },
                child: Scaffold(
                  extendBodyBehindAppBar: true,
                  bottomSheet: data.status == "Active"
                      ? Padding(
                          padding:
                              EdgeInsets.all(AppStyles.screenHorizontalPadding),
                          child: Row(
                            children: [
                              Expanded(
                                  child: CustomButtonWidget(
                                title: "Send Message",
                                onPressed: () {
                                  AppRouter.push(
                                      ChattingView(
                                        user: data.productOwner,
                                        chatId: data.chatId,
                                        ad: data,
                                      ), fun: () {
                                    ref
                                        .read(productDataProvider)
                                        .getProductDetails(
                                            id: widget.productId);
                                  });
                                },
                                border:
                                    Border.all(color: AppColors.borderColor),
                                textColor: Colors.black,
                                color: const Color(0xffEFEDEC),
                              )),
                              9.pw,
                              Expanded(
                                  child: CustomButtonWidget(
                                      title: "Buy Now",
                                      onPressed: () {
                                        AppRouter.push(CheckoutView(
                                          product: data,
                                        ));
                                      }))
                            ],
                          ),
                        )
                      : null,
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            ProductMultipleImageDisplayWidget(
                              images: data.productSampleImages ?? [],
                            ),
                            Positioned(
                              top: 30,
                              left: 20,
                              right: 20,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const CustomBackButtonWidget(),
                                  GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(productDataProvider)
                                          .checkFavourite(
                                              isFavourite, data.id!, null);
                                    },
                                    child: Container(
                                      width: 31.r,
                                      height: 31.r,
                                      padding: EdgeInsets.all(4.r),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: SvgPicture.asset(
                                        isFavourite
                                            ? Assets.favouriteCheckedIcon
                                            : Assets.favouriteIcon,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppStyles.screenHorizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10.h,
                            children: [
                              ProductTitleWidget(
                                address: data.locationData?.placeName,
                                title: data.productName,
                                price: data.productPrice,
                                status: data.status,
                              ),
                              10.ph,
                              AdDetailWidget(
                                showRecipt: data.buyingReceipt!.isNotEmpty,
                                list: data.buyingReceipt!.isNotEmpty
                                    ? [
                                        ProductDetailTitleDataModel(
                                            title: "Brand",
                                            description: data.brand!),
                                        ProductDetailTitleDataModel(
                                            title: "Condition",
                                            description: data.condition!),
                                        ProductDetailTitleDataModel(
                                            title: "Buying receipt",
                                            description: "View Receipt"),
                                        ProductDetailTitleDataModel(
                                            title: "Check In",
                                            description: Helper.setCheckInFormat(
                                                    data.checkIn!) ??
                                                ""),
                                        ProductDetailTitleDataModel(
                                            title: "Check Out",
                                            description: Helper.setCheckInFormat(
                                                    data.checkOut!) ??
                                                ""),
                                        ProductDetailTitleDataModel(
                                            title: "Set",
                                            description:
                                                data.quantity.toString()),
                                      ]
                                    : [
                                        ProductDetailTitleDataModel(
                                            title: "Brand",
                                            description: data.brand!),
                                        ProductDetailTitleDataModel(
                                            title: "Condition",
                                            description: data.condition!),
                                        ProductDetailTitleDataModel(
                                            title: "Check In",
                                            description: Helper.setCheckInFormat(
                                                    data.checkIn!) ??
                                                ""),
                                        ProductDetailTitleDataModel(
                                            title: "Check Out",
                                            description: Helper.setCheckInFormat(
                                                    data.checkOut!) ??
                                                ""),
                                        ProductDetailTitleDataModel(
                                            title: "Set",
                                            description:
                                                data.quantity.toString()),
                                      ],
                                onTap: () {
                                  if (data.buyingReceipt!.isNotEmpty) {
                                    showFullScreenReceiptModal(
                                        context, data.buyingReceipt!.first);
                                  }
                                },
                              ),
                              ProductDetailWidget(
                                description: data.productDescription ?? "",
                                features: data.keyFeatures ?? [],
                              ),
                              if (data.category != null) ...[
                                GenericTranslateWidget( 
                                  "Category",
                                  style: context.textStyle.displayMedium!
                                      .copyWith(fontSize: 18.sp),
                                ),
                                10.ph,
                                CategoryTitleWidget(
                                  parentCategory: null,
                                  subCategory: data.category,
                                ),
                              ],
                              LocationDetailWidget(
                                address: data.locationData?.placeName ?? "",
                                lat: data.locationData?.lat ?? 0.0,
                                long: data.locationData?.lon ?? 0.0,
                              ),
                              20.ph,
                              if (data.productOwner != null) ...[
                                const TitleHeadingWidget(
                                    title: "Listed by private user"),
                                ListTile(
                                  minVerticalPadding: 0,
                                  contentPadding: EdgeInsets.zero,
                                  leading: UserProfileWidget(
                                      radius: 30.r,
                                      imageUrl: data.productOwner!.picture),
                                  title: GenericTranslateWidget( 
                                    "${data.productOwner!.fname} ${data.productOwner!.lname}",
                                    style: context.textStyle.displayMedium!
                                        .copyWith(fontSize: 16.sp),
                                  ),
                                  // subtitle: GenericTranslateWidget( 
                                  //   "Nice se",
                                  //   style: context.textStyle.bodySmall,
                                  // ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 13.r,
                                  ),
                                ),
                                20.ph,
                              ]
                            ],
                          ),
                        ),
                        isLoad == Status.error
                            ? CustomErrorWidget(onPressed: () {
                                final loc = ref
                                    .read(currentLocationProvider)
                                    .currentLocation;
                                if (data.category != null) {
                                  ref
                                      .read(productDataProvider.notifier)
                                      .getSimilarProducts(
                                          adId: data.id!,
                                          id: data.category!.id,
                                          lat: loc.lat,
                                          limit: 10,
                                          long: loc.lon);
                                }
                              })
                            : ProductDisplayWidget(
                                isLoad: isLoad == Status.loading,
                                items: products,
                                onTap: () {
                                  AppRouter.push(SearchProductView(
                                    title: "Similar Products",
                                    type: "Ad",
                                    isVanish: widget.isVanish,
                                    under10: widget.isUnder10,
                                    categoryId: data.category!.id,
                                  ));
                                },
                                showSeeAll: isLoad == Status.completed &&
                                    products.isNotEmpty &&
                                    10 >= products.length,
                                showAddCard: true,
                                fun: () {
                                  final loc = ref
                                      .watch(currentLocationProvider)
                                      .currentLocation;
                                  ref
                                      .read(productDataProvider)
                                      .getProductDetails(id: data.id!);

                                  ref
                                      .read(productDataProvider.notifier)
                                      .getSimilarProducts(
                                          adId: data.id!,
                                          id: data.category!.id,
                                          lat: loc.lat,
                                          limit: 10,
                                          long: loc.lon);
                                },
                                height: 320.h,
                                title: "Similar Products",
                              ),
                        100.ph
                      ],
                    ),
                  ),
                ),
              )
            : Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white,
                child: CustomErrorWidget(onPressed: () {
                  ref
                      .read(productDataProvider)
                      .getProductDetails(id: widget.productId);
                }),
              );
  }
}

void showFullScreenReceiptModal(BuildContext context, String imageUrl) {
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
                child: const Scaffold(
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(23.r),
                  child: DisplayNetworkImage(
                    imageUrl: imageUrl,
                    height: 443.r,
                    width: 329.701.w,
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(AppStyles.screenHorizontalPadding),
              child: CustomButtonWidget(
                  title: 'Done',
                  onPressed: () {
                    AppRouter.back();
                  }),
            )
          ])
        ],
      );
    },
  );
}
