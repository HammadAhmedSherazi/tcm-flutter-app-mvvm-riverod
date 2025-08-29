
import 'package:tcm/utils/app_extensions.dart';



import '../export_all.dart';


class VenderProductDetailView extends ConsumerStatefulWidget {
  final int id;
  final int index;
  final int? orderId;

  final List<ProductDataModel> list;
  final String keyString;
  const VenderProductDetailView(
      {super.key,
      required this.id,
      required this.index,
      required this.list,
      this.orderId,
      required this.keyString});

  @override
  ConsumerState<VenderProductDetailView> createState() =>
      _VenderProductDetailViewConsumerState();
}

class _VenderProductDetailViewConsumerState
    extends ConsumerState<VenderProductDetailView> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(productDataProvider).getStoreProductDetails(id: widget.id);
      ref.read(chatRepoProvider).setResponse();
      ref.read(productDataProvider).getProductReview(
          cursor: null, input: {"product_id": widget.id, "limit": 10});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(productDataProvider);
    final status = provider.getStoreProductDetailApiResponse.status;
    final similarStatus = provider.similarProductsApiResponse.status;
    final isLoad = similarStatus == Status.loading;
    final similarProducts =
        isLoad ? provider.loadingProduct : provider.similarProducts;
    final loc = ref.watch(currentLocationProvider).currentLocation;

    final StoreProductDetailDataModel? data =
        provider.getStoreProductDetailApiResponse.data;
    if (data != null && similarStatus == Status.undertermined) {
      if (data.category != null && data.category!.id > -1) {
        Future.microtask(() {
          ref.read(productDataProvider.notifier).getSimilarVenderProducts(
              productId: data.id!,
              id: data.category!.id,
              lat: loc.lat,
              limit: 10,
              long: loc.lon);
        });
      }
    }
    return RefreshIndicator(
      onRefresh: () async {
        ref.read(productDataProvider).getStoreProductDetails(id: widget.id);
        if (data!.category != null && data.category!.id > -1) {
          Future.microtask(() {
            ref.read(productDataProvider.notifier).getSimilarVenderProducts(
                productId: data.id!,
                id: data.category!.id,
                lat: loc.lat,
                limit: 10,
                long: loc.lon);
          });
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        bottomNavigationBar: data != null && data.quantity! > 0
            ? Padding(
                padding: EdgeInsets.all(AppStyles.screenHorizontalPadding),
                child: Row(
                  children: [
                    Expanded(child: Consumer(
                      builder: (_, WidgetRef ref, __) {
                        final productProvider = ref.watch(productDataProvider);

                        return CustomButtonWidget(
                          title: "Add to Cart",
                          onPressed: () {
                            if (productProvider.checkOutList.length <= 10) {
                              showModalBottomSheet(
                                showDragHandle: true,
                                context: context,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15.r)),
                                ),
                                builder: (context) {
                                  int quantity = 1;
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        child: DraggableScrollableSheet(
                                          initialChildSize: 0.35,
                                          minChildSize: 0.35,
                                          maxChildSize: 0.5,
                                          expand: false,
                                          builder: (context, scrollController) {
                                            return Container(
                                              padding: EdgeInsets.all(AppStyles
                                                  .screenHorizontalPadding),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.r),
                                                        child:
                                                            DisplayNetworkImage(
                                                          imageUrl:
                                                              data.productImage ??
                                                                  "",
                                                          width: 77.297.w,
                                                          height: 75.595.h,
                                                        ),
                                                      ),
                                                      10.pw,
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: GenericTranslateWidget( 
                                                                    data.productName ??
                                                                        "",
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: context
                                                                        .textStyle
                                                                        .displayMedium!
                                                                        .copyWith(
                                                                            fontSize:
                                                                                16.sp),
                                                                  ),
                                                                ),
                                                                GenericTranslateWidget( 
                                                                  "Avaliable Stock: ${data.quantity}",
                                                                  style: context
                                                                      .textStyle
                                                                      .bodyMedium,
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                GenericTranslateWidget( 
                                                                  "\$${data.productPrice}",
                                                                  style: context
                                                                      .textStyle
                                                                      .displayLarge!
                                                                      .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                ),
                                                                Container(
                                                                  height: 40.h,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(1
                                                                              .r),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: const Color(
                                                                        0xffEFEDEC),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            421.r),
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          if (quantity >
                                                                              1) {
                                                                            setState(() {
                                                                              quantity--;
                                                                            });
                                                                          }
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              36.r,
                                                                          width:
                                                                              36.r,
                                                                          padding:
                                                                              EdgeInsets.all(7.r),
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                          child:
                                                                              SvgPicture.asset(
                                                                            Assets.deleteIcon,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 18.r),
                                                                        child:
                                                                            GenericTranslateWidget( 
                                                                          "$quantity",
                                                                          style: context
                                                                              .textStyle
                                                                              .displayMedium!
                                                                              .copyWith(fontSize: 18.sp),
                                                                        ),
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            if (quantity <
                                                                                data.quantity!) {
                                                                              quantity++;
                                                                            }
                                                                          });
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              36.r,
                                                                          width:
                                                                              36.r,
                                                                          padding:
                                                                              EdgeInsets.all(7.r),
                                                                          decoration: quantity < data.quantity!
                                                                              ? const BoxDecoration(
                                                                                  gradient: AppColors.primaryGradinet,
                                                                                  shape: BoxShape.circle,
                                                                                )
                                                                              : const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                                                                          child:
                                                                              SvgPicture.asset(
                                                                            Assets.plusIcon,
                                                                            colorFilter:
                                                                                const ColorFilter.mode(
                                                                              Colors.white,
                                                                              BlendMode.srcIn,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  Consumer(
                                                    builder:
                                                        (_, WidgetRef ref, __) {
                                                      return CustomButtonWidget(
                                                        title: "Add To Cart",
                                                        onPressed: () {
                                                          ref
                                                              .read(
                                                                  productDataProvider)
                                                              .addToCard(
                                                                  product: data,
                                                                  quantity:
                                                                      quantity,
                                                                  index: widget
                                                                      .index,
                                                                  list: widget
                                                                      .list,
                                                                  categoryKey:
                                                                      widget
                                                                          .keyString);
                                                        },
                                                        isLoad: ref
                                                                .watch(
                                                                    productDataProvider)
                                                                .addToCartApiResponse
                                                                .status ==
                                                            Status.loading,
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            } else {
                              Helper.showMessage(
                                  "Cart limit reached: 10 items maximum.");
                            }
                          },
                          border: Border.all(color: AppColors.borderColor),
                          textColor: Colors.black,
                          color: const Color(0xffEFEDEC),
                        );
                      },
                    )),
                    9.pw,
                    Expanded(
                        child: CustomButtonWidget(
                            title: "Buy Now",
                            onPressed: () {
                              AppRouter.push(BuyNowProductView(
                                data: data,
                              ));
                            }))
                  ],
                ),
              )
            : null,
        // appBar: AppBar(
        //   iconTheme: IconThemeData(size: 100.r),
        //   automaticallyImplyLeading: false,
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   leading: const CustomBackButtonWidget(),
        // ),
        body: status == Status.error && data == null
            ? CustomErrorWidget(onPressed: () {
                ref
                    .read(productDataProvider)
                    .getStoreProductDetails(id: widget.id);
              })
            : status == Status.completed && data != null
                ? ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              ProductMultipleImageDisplayWidget(
                                images: data.productSampleImages ?? [],
                              ),
                              const Positioned(
                                  top: 30,
                                  left: 20,
                                  child: CustomBackButtonWidget())
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppStyles.screenHorizontalPadding),
                            child: Column(
                              spacing: 10.h,
                              children: [
                                15.ph,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 27.h,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.r),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: AppColors.secondaryColor1,
                                          borderRadius:
                                              BorderRadius.circular(4.r)),
                                      child: GenericTranslateWidget( 
                                        data.category?.title ?? "",
                                        style: context.textStyle.displayMedium!
                                            .copyWith(
                                                foreground:
                                                    AppColors.gradientPaint),
                                      ),
                                    ),
                                    if (data.storeData.deliveryOptions?.any(
                                            (element) =>
                                                element.type == "Fast") ??
                                        false)
                                      Container(
                                        height: 30.h,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(
                                            left: 12.6.r, right: 12.6),
                                        decoration: BoxDecoration(
                                            color: const Color(0xffFFFF00),
                                            borderRadius:
                                                BorderRadius.horizontal(
                                                    left:
                                                        Radius.circular(700.r),
                                                    right: Radius.circular(
                                                        700.r))),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            GenericTranslateWidget( 
                                              'Fast Delivery',
                                              style:
                                                  context.textStyle.bodyMedium,
                                            ),
                                            3.pw,
                                            SvgPicture.asset(
                                              Assets.deliveryVanIcon,
                                              width: 17.r,
                                            ),
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GenericTranslateWidget( 
                                        data.productName!,
                                        style: context.textStyle.displayLarge!
                                            .copyWith(fontSize: 20.sp),
                                      ),
                                    )
                                  ],
                                ),
                                10.ph,
                                Row(
                                  children: [
                                    GenericTranslateWidget( 
                                      "\$${data.productPrice!.toStringAsFixed(2)}",
                                      style: context.textStyle.displayMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 30.sp),
                                    ),
                                    if (data.discountValue != 0.0) ...[
                                      5.pw,
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 10.r),
                                        child: GenericTranslateWidget( 
                                          "\$${data.productPrice! + data.discountValue}",
                                          style: context.textStyle.bodyMedium!
                                              .copyWith(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],

                                    // TextSpan(
                                    //     text: '2',
                                    //     style: TextStyle(
                                    //         color: Colors.black,
                                    //         fontSize: 30,
                                    //         fontFeatures: [
                                    //           FontFeature.superscripts()
                                    //         ])),
                                    // TextSpan(
                                    //     text: 'O',
                                    //     style: TextStyle(
                                    //         color: Colors.black, fontSize: 30)),

                                    const Spacer(),
                                    Container(
                                      height: 27.h,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.r,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .white, // background color (equivalent to background: #FFF)
                                        borderRadius: BorderRadius.horizontal(
                                            left: Radius.circular(500.r),
                                            right: Radius.circular(
                                                500.r)), // border-radius: 500px
                                        border: Border.all(
                                          color: AppColors
                                              .borderColor, // border: 1px solid rgba(0, 0, 0, 0.10)
                                          width: 2,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromRGBO(0, 0, 0,
                                                0.10), // box-shadow: 0px 1px 16px 0px rgba(0, 0, 0, 0.10)
                                            blurRadius: 16,
                                            offset: Offset(0,
                                                1), // This corresponds to the 0px horizontal and 1px vertical offset
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GenericTranslateWidget( 
                                            "${data.averageRating}",
                                            style: context
                                                .textStyle.displayMedium!
                                                .copyWith(
                                                    height: 1.3,
                                                    fontSize: 16.sp,
                                                    foreground: AppColors
                                                        .gradientPaint),
                                          ),
                                          3.pw,
                                          SvgPicture.asset(
                                            Assets.ratingStarIcon,
                                            width: 12.r,
                                          ),
                                          3.pw,
                                          GenericTranslateWidget( 
                                            "(${data.totalReviews})",
                                            style: context.textStyle.bodyMedium!
                                                .copyWith(
                                                    height: 1.3,
                                                    foreground: AppColors
                                                        .gradientPaint),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  height: 102.h,
                                  width: context.screenwidth,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12.r, horizontal: 9.r),
                                  decoration: BoxDecoration(
                                      color: AppColors.secondaryColor1,
                                      borderRadius:
                                          BorderRadius.circular(10.r)),
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) =>
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                                minWidth:
                                                    (context.screenwidth / 3) *
                                                        0.78,
                                                maxWidth:
                                                    (context.screenwidth / 3) *
                                                        0.78),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 49.r,
                                                  height: 46.r,
                                                  padding: EdgeInsets.all(10.r),
                                                  decoration: BoxDecoration(
                                                    // Background with linear gradient (from #F5F6F9 to #FFF)
                                                    gradient:
                                                        const LinearGradient(
                                                      begin: Alignment
                                                          .topCenter, // Linear gradient direction (0deg)
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Colors.white,
                                                        Color(0xFFF5F6F9),
                                                      ], // #F5F6F9 to #FFF
                                                    ),
                                                    // Border radius of 4px
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: SvgPicture.asset(
                                                    ProductFeatureDataModel
                                                        .feature[index].icon,
                                                  ),
                                                ),
                                                10.ph,
                                                Expanded(
                                                  child: GenericTranslateWidget( 
                                                    ProductFeatureDataModel
                                                        .feature[index].title,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: context
                                                        .textStyle.displaySmall!
                                                        .copyWith(
                                                            height: 0.8,
                                                            color: Colors.black
                                                                .withValues(
                                                                    alpha:
                                                                        0.7)),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                      separatorBuilder: (context, index) =>
                                          const VerticalDivider(),
                                      itemCount: ProductFeatureDataModel
                                          .feature.length),
                                  // child: Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: List.generate(
                                  //       4,
                                  //       (index) => Container(
                                  //             // margin: index != 3
                                  //             //     ? EdgeInsets.only(left: 15.r)
                                  //             //     : null,
                                  //             // padding: index != 3
                                  //             //     ? EdgeInsets.only(right: 15.r)
                                  //             //     : null,
                                  //             decoration: BoxDecoration(
                                  //                 border: index != 3
                                  //                     ? Border(
                                  //                         right: BorderSide(
                                  //                         color: AppColors.borderColor,
                                  //                       ))
                                  //                     : null),
                                  //             child: Column(
                                  //               children: [
                                  //                 Container(
                                  //                   width: 49.r,
                                  //                   height: 46.r,
                                  //                   decoration: BoxDecoration(
                                  //                     // Background with linear gradient (from #F5F6F9 to #FFF)
                                  //                     gradient: const LinearGradient(
                                  //                       begin: Alignment
                                  //                           .topCenter, // Linear gradient direction (0deg)
                                  //                       end: Alignment.bottomCenter,
                                  //                       colors: [
                                  //                         Colors.white,
                                  //                         Color(0xFFF5F6F9),
                                  //                       ], // #F5F6F9 to #FFF
                                  //                     ),
                                  //                     // Border radius of 4px
                                  //                     borderRadius:
                                  //                         BorderRadius.circular(4),
                                  //                   ),
                                  //                 ),
                                  //                 Row(
                                  //                   children: [
                                  //                     GenericTranslateWidget( 
                                  //                       "High Rated",
                                  //                       style: context
                                  //                           .textStyle.displaySmall!
                                  //                           .copyWith(
                                  //                               color: Colors.black
                                  //                                   .withValues(
                                  //                                       alpha: 0.7)),
                                  //                     ),
                                  //                   ],
                                  //                 )
                                  //               ],
                                  //             ),
                                  //           )),
                                  // ),
                                ),
                                ProductDetailWidget(
                                  description: data.productDescription ?? "",
                                  features: data.keyFeatures ?? [],
                                ),
                                AboutSellerWidget(
                                  store: data.storeData,
                                ),
                                UserRatingWidget(
                                  id: widget.id,
                                  storeOrderId: widget.orderId,
                                  storeName: data.storeData.title,
                                  numberOfReviews: data.totalReviews,
                                  cursor: provider.reviewCursor,
                                  rating: double.parse(
                                      data.averageRating.toString()),
                                ),
                                const Row(
                                  children: [
                                    Expanded(
                                        child: TitleHeadingWidget(
                                            title:
                                                "More Product Similar To This"))
                                  ],
                                ),
                                10.ph,
                              ],
                            ),
                          ),
                          similarStatus != Status.error
                              ? VerticalProjectsDisplayLayoutWidget(
                                  temp: similarProducts,
                                  isLoad: isLoad,
                                  keyString: "",
                                )
                              : SizedBox(
                                  height: context.screenheight * 0.5,
                                  width: context.screenwidth,
                                  child: CustomErrorWidget(onPressed: () {
                                    ref
                                        .read(productDataProvider.notifier)
                                        .getSimilarVenderProducts(
                                            productId: data.id!,
                                            id: data.category!.id,
                                            lat: loc.lat,
                                            limit: 10,
                                            long: loc.lon);
                                  }),
                                ),
                        ],
                      ),
                    ))
                : const CustomLoadingWidget(),
      ),
    );
  }
}

class AboutSellerWidget extends StatelessWidget {
  final TopVenderDataModel store;
  const AboutSellerWidget({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleHeadingWidget(title: "About Seller"),
        15.ph,
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 10.r),
          decoration: BoxDecoration(
              color: AppColors.secondaryColor1,
              borderRadius: BorderRadius.circular(10.r)),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: DisplayNetworkImage(
                      imageUrl: store.image,
                      width: 37.r,
                      height: 32.r,
                    ),
                  ),
                  10.pw,
                  Text( 
                    store.title,
                    style: context.textStyle.displaySmall!
                        .copyWith(fontWeight: FontWeight.w700),
                  )
                ],
              ),
              // 10.ph,
              // Container(
              //   // height: 45.h,
              //   // constraints: BoxConstraints(maxHeight: 45.h, minHeight: 45.h),
              //   padding: EdgeInsets.symmetric(vertical: 4.r),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(6.r),
              //       color: const Color(0xffE8F0FF)),
              //   child: Row(
              //     children: List.generate(
              //       3,
              //       (index) => Expanded(
              //           child: Container(
              //         padding: EdgeInsets.only(left: 20.r),
              //         decoration: BoxDecoration(
              //             border: index == 1
              //                 ? Border(
              //                     left:
              //                         BorderSide(color: AppColors.borderColor),
              //                     right:
              //                         BorderSide(color: AppColors.borderColor))
              //                 : null),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Row(
              //               children: [
              //                 GenericTranslateWidget( 
              //                   index == 0 ? "84%" : "100%",
              //                   style: context.textStyle.displayMedium,
              //                 ),
              //                 3.pw,
              //                 index == 0
              //                     ? GenericTranslateWidget( 
              //                         "Medium",
              //                         style: context.textStyle.bodySmall!
              //                             .copyWith(fontSize: 10.sp),
              //                       )
              //                     : Container(
              //                         padding: EdgeInsets.symmetric(
              //                           horizontal: 5.r,
              //                           // vertical: 2.r
              //                         ),
              //                         decoration: BoxDecoration(
              //                             color: const Color(0xff4CAF50),
              //                             borderRadius:
              //                                 BorderRadius.circular(2.r)),
              //                         child: GenericTranslateWidget( 
              //                           "High",
              //                           style: context.textStyle.bodySmall!
              //                               .copyWith(
              //                                   fontSize: 10.sp,
              //                                   color: Colors.white),
              //                         ),
              //                       )
              //               ],
              //             ),
              //             Row(
              //               children: [
              //                 Expanded(
              //                   child: GenericTranslateWidget( 
              //                     index == 0
              //                         ? "Positive Seller..."
              //                         : index == 1
              //                             ? "Ship on Time"
              //                             : "Return Guaranteed",
              //                     style: context.textStyle.bodySmall!,
              //                     maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                   ),
              //                 ),
              //               ],
              //             )
              //           ],
              //         ),
              //       )),
              //     ),
              //   ),
              // )
            ],
          ),
        )
      ],
    );
  }
}

class UserRatingWidget extends StatelessWidget {
  final ScrollController? controller;
  final String storeName;
  final int id;
  final int? storeOrderId;
  final double rating;
  final int numberOfReviews;
  final String? cursor;
  const UserRatingWidget(
      {super.key,
      this.controller,
      required this.numberOfReviews,
      required this.id,
      required this.storeName,
      required this.rating,
      this.cursor,
      required this.storeOrderId});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (cursor != null) {
              AppRouter.push(RatingReviewView(
                  id: id, rating: rating, numberOfReviews: numberOfReviews));
            }
          },
          child: Row(
            children: [
              const TitleHeadingWidget(title: "Ratings & Reviews"),
              const Spacer(),
              GenericTranslateWidget( 
                "$rating",
                style: context.textStyle.displayMedium!.copyWith(
                    // height: 1.3,
                    fontSize: 18.sp,
                    foreground: AppColors.gradientPaint),
              ),
              CustomRatingIndicator(
                rating: rating,
              ),
              if (cursor != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12.r,
                  color: Colors.black,
                ),

              // RatingBar(
              //   initialRating: 3,
              //   direction: Axis.horizontal,
              //   allowHalfRating: true,
              //   itemCount: 5,
              //   ratingWidget: RatingWidget(
              //     full: SvgPicture.asset(Assets.ratingStarIcon),
              //     half: SvgPicture.asset(Assets.ratingStarIcon),
              //     empty: SvgPicture.asset(Assets.ratingStarIcon),
              //   ),
              //   itemSize: 16.r,
              //   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              //   onRatingUpdate: (rating) {
              //     print(rating);
              //   },
              // )
            ],
          ),
        ),
        // if (isEnabled)
        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        // TextButton(
        //     style: const ButtonStyle(
        //       visualDensity:
        //           VisualDensity(horizontal: -4, vertical: -4),
        //       padding: WidgetStatePropertyAll(EdgeInsets.zero),
        //     ),
        //     onPressed: () {
        //       showReviewBottomSheet(context, null, null, null, null);
        //     },
        //     child: GenericTranslateWidget( 
        //       "Add Review",
        //       style: context.textStyle.displayMedium!.copyWith(
        //         color: AppColors.primaryColor,
        //         decoration: TextDecoration.underline,
        //       ),
        //     )),
        //     ],
        //   ),
        20.ph,
        Consumer(
          builder: (_, WidgetRef ref, __) {
            final provider = ref.watch(productDataProvider);
            final status = provider.productReviewApiResponse.status;
            final isLoad = status == Status.loading;
            final list = isLoad
                ? List.generate(
                    3,
                    (index) => ProductReviewsDataModel(
                        id: -1,
                        review: "sfdgsfh",
                        rating: 0.0,
                        user: UserDataModel(id: -1)),
                  )
                : provider.productReviews;
            return AsyncStateHandler(
                loadingWidget: Skeletonizer(
                  enabled: isLoad,
                  child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final review = list[index];
                        return ReviewCardWidget(review: review);
                      },
                      separatorBuilder: (context, index) => 10.ph,
                      itemCount: list.length),
                ),
                status: status,
                dataList: list,
                itemBuilder: (p0, p1) => const SizedBox.shrink(),
                onRetry: () {
                  ref.read(productDataProvider).getProductReview(
                      cursor: null, input: {"product_id": id, "limit": 10});
                },
                customSuccessWidget: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final review = list[index];
                      return ReviewCardWidget(review: review);
                    },
                    separatorBuilder: (context, index) => 10.ph,
                    itemCount: list.length));
          },
        )
      ],
    );
  }
}

class ReviewCardWidget extends StatelessWidget {
  const ReviewCardWidget({
    super.key,
    required this.review,
  });

  final ProductReviewsDataModel review;

  @override
  Widget build(BuildContext context) {
    // ValueNotifier for the "See More / See Less" functionality
    ValueNotifier<bool> reviewTextExpanded = ValueNotifier(false);
    ValueNotifier<bool> replyTextExpanded = ValueNotifier(false);

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor1,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: review.reply != ""
          ? Column(
              spacing: 5.h,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User's name
                          Text( 
                            review.user!.userName,
                            style: context.textStyle.displaySmall!.copyWith(
                                color: Colors.black.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w700),
                          ),

                          // Review text with See More/See Less toggle
                          ValueListenableBuilder<bool>(
                            valueListenable: reviewTextExpanded,
                            builder: (context, isExpanded, _) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GenericTranslateWidget( 
                                    review.review,
                                    maxLines: !isExpanded ? null : 2,
                                    overflow: !isExpanded
                                        ? TextOverflow.ellipsis
                                        : null,
                                    style: context.textStyle.bodySmall,
                                  ),
                                  if (review.review.length > 20)
                                    GestureDetector(
                                      onTap: () {
                                        reviewTextExpanded.value = !isExpanded;
                                      },
                                      child: GenericTranslateWidget( 
                                        isExpanded ? "See Less" : "See More",
                                        style: context.textStyle.displaySmall,
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          CustomRatingIndicator(rating: review.rating),
                        ],
                      ),
                    ),
                    // Displaying Review images
                    Row(
                      children: List.generate(
                        review.images.length,
                        (index) => ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: DisplayNetworkImage(
                            imageUrl: review.images[index],
                            width: 52.r,
                            height: 68.r,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Reply Section
                Container(
                  margin: EdgeInsets.only(left: 10.r),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 5.r, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 67, 240, 246)
                        .withValues(alpha: 0.10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Reply title
                      Text( 
                        review.product?.storeData.title ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyle.displaySmall!,
                      ),
                      // Reply text with See More/See Less toggle
                      ValueListenableBuilder<bool>(
                        valueListenable: replyTextExpanded,
                        builder: (context, isExpanded, _) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GenericTranslateWidget( 
                                review.reply!,
                                maxLines: !isExpanded ? null : 2,
                                overflow:
                                    !isExpanded ? TextOverflow.ellipsis : null,
                                style: context.textStyle.bodySmall!.copyWith(
                                  color: Colors.black.withValues(alpha: 0.6),
                                ),
                              ),
                              if (review.reply!.length > 20)
                                GestureDetector(
                                  onTap: () {
                                    replyTextExpanded.value = !isExpanded;
                                  },
                                  child: GenericTranslateWidget( 
                                      isExpanded ? "See Less" : "See More",
                                      style: context.textStyle.displaySmall),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GenericTranslateWidget( 
                        review.user!.userName,
                        style: context.textStyle.displaySmall!.copyWith(
                            color: Colors.black.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w700),
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: reviewTextExpanded,
                        builder: (context, isExpanded, _) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GenericTranslateWidget( 
                                review.review,
                                maxLines: isExpanded ? null : 2,
                                overflow: TextOverflow.ellipsis,
                                style: context.textStyle.bodySmall,
                              ),
                              GestureDetector(
                                onTap: () {
                                  reviewTextExpanded.value = !isExpanded;
                                },
                                child: GenericTranslateWidget( 
                                  isExpanded ? "See Less" : "See More",
                                  style: context.textStyle.bodySmall!.copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      CustomRatingIndicator(rating: review.rating),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 5.r,
                  children: List.generate(
                    review.images.length,
                    (index) => GestureDetector(
                      onTap: () {
                        AppRouter.push(FullImageView(
                          imagePath: review.images[index],
                        ));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: DisplayNetworkImage(
                          imageUrl: review.images[index],
                          width: 52.r,
                          height: 68.r,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}

class CustomRatingIndicator extends StatelessWidget {
  final double rating;
  final double? iconSize;
  const CustomRatingIndicator({super.key, required this.rating, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: rating,
      itemBuilder: (context, index) => SvgPicture.asset(Assets.ratingStarIcon),
      itemCount: 5,
      itemSize: iconSize ?? 16.r,
      direction: Axis.horizontal,
    );
  }
}

class ProductFeatureDataModel {
  late final String title;
  late final String icon;

  ProductFeatureDataModel({required this.title, required this.icon});

  static List<ProductFeatureDataModel> feature = [
    ProductFeatureDataModel(
        title: "Delivery on time", icon: Assets.deliveryTruckIcon),
    ProductFeatureDataModel(
        title: "High Rated Seller", icon: Assets.ratingStarIcons),
    // ProductFeatureDataModel(
    //     title: "Cash on Delivery", icon: Assets.cashNoteIcons),
    ProductFeatureDataModel(
        title: "Secure Transaction", icon: Assets.securityIcons),
  ];
}

// class UserReviewDataModel {
//   late final String username;
//   late final String content;
//   late final double rating;
//   late final List<String> images;

//   UserReviewDataModel(
//       {required this.username,
//       required this.images,
//       required this.content,
//       required this.rating});

//   static List<UserReviewDataModel> reviews = [
//     UserReviewDataModel(
//         username: "John D.",
//         images: [
//           'https://i.redd.it/m2xp6d1ur3g91.jpg',
//           'https://i.redd.it/fz0nz3pikvf41.jpg'
//         ],
//         content:
//             "I've been a Red Bull drinker for years, and it never fails to give me the need.....",
//         rating: 5.0),
//     UserReviewDataModel(
//         username: "Samantha R.",
//         images: [
//           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBQBoGbqxFShzs_xCnKfiYVpi-8gcAKVOo6w&s',
//           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRx0fxiCritsq37WVktkCOIwJLXk8nDExX1DZkSDctmAd3YxncjdbIQJLUOVlqEgjpUG9E&usqp=CAU'
//         ],
//         content:
//             "I've been a Red Bull drinker for years, and it never fails to give me the need.....",
//         rating: 5.0),
//     UserReviewDataModel(
//         username: "Kelly T.",
//         images: [
//           'https://i.redd.it/m2xp6d1ur3g91.jpg',
//           'https://i.redd.it/fz0nz3pikvf41.jpg'
//         ],
//         content:
//             "I've been a Red Bull drinker for years, and it never fails to give me the need.....",
//         rating: 5.0),
//   ];
// }
