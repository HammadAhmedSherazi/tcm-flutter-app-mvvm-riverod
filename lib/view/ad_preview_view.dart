import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';



class AdPreviewView extends ConsumerWidget {
  final ProductDetailDataModel? data;
  const AdPreviewView({super.key, this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = data ?? ref.watch(productDataProvider).adReview;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (data == null) {
            AppRouter.pushAndRemoveUntil(const NavigationView());
          } else {
            AppRouter.back();
          }
        }
      },
      child: CommonScreenTemplateWidget(
          leadingWidget: CustomBackButtonWidget(
            onTap: () {
              if (data == null) {
                AppRouter.pushAndRemoveUntil(const NavigationView());
              } else {
                AppRouter.back();
              }
            },
          ),
          title: "Your Ad",
          appBarHeight: 70.h,
          bottomWidget: data == null
              ? Padding(
                  padding: EdgeInsets.all(AppStyles.screenHorizontalPadding),
                  child: Consumer(
                    builder: (_, WidgetRef ref, __) {
                      final isLoad = ref
                              .watch(productDataProvider)
                              .deleteAdApiResponse
                              .status ==
                          Status.loading;
                      return CustomButtonWidget(
                        onPressed: () {
                          ref
                              .read(productDataProvider.notifier)
                              .deleteAd(id: product!.id!, index: null);
                        },
                        isLoad: isLoad,
                        title: "Delete Ad",
                        color: AppColors.deleteButtonColor,
                      );
                    },
                  ),
                )
              : null,
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProductMultipleImageDisplayWidget(
                    images: product!.productSampleImages!,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppStyles.screenHorizontalPadding),
                    child: Column(
                      spacing: 10.h,
                      children: [
                        ProductTitleWidget(
                          title: product.productName!,
                          address: product.locationData!.placeName,
                          price: product.productPrice,
                          status: product.status,
                        ),
                        AdDetailWidget(
                          list: [
                            ProductDetailTitleDataModel(
                                title: "Brand", description: product.brand!),
                            ProductDetailTitleDataModel(
                                title: "Condition",
                                description: product.condition ?? ""),
                            ProductDetailTitleDataModel(
                                title: "Check In",
                                description: Helper.setCheckInFormat(
                                        product.checkIn.toString()) ??
                                    ""),
                            ProductDetailTitleDataModel(
                                title: "Check Out",
                                description: Helper.setCheckInFormat(
                                        product.checkOut.toString()) ??
                                    ""),
                            ProductDetailTitleDataModel(
                                title: "Set",
                                description: product.quantity.toString()),
                          ],
                        ),
                        ProductDetailWidget(
                          description: product.productDescription!,
                          features: const [
                            "This is a short description.", // 5 words
                            "This description is much longer and contains many more words for testing purposes.", // 12 words
                            "Another item with text to test exceeding limits.", // 8 words
                            "A fourth item to ensure proper functionality.", // 7 words
                          ],
                        ),
                        if (product.category != null) ...[
                          GenericTranslateWidget( 
                            "Category",
                            style: context.textStyle.displayMedium!
                                .copyWith(fontSize: 18.sp),
                          ),
                          10.ph,
                          CategoryTitleWidget(
                            parentCategory: null,
                            subCategory: product.category,
                          ),
                        ],
                        LocationDetailWidget(
                          address: product.locationData!.placeName,
                          lat: product.locationData!.lat,
                          long: product.locationData!.lon,
                        ),
                      ],
                    ),
                  ),
                  150.ph
                ],
              ),
            ),
          )),
    );
  }
}

class ProductDetailWidget extends StatelessWidget {
  final String description;
  final List<String> features;

  const ProductDetailWidget(
      {super.key, required this.description, required this.features});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // spacing: 12.h,
      children: [
        const TitleHeadingWidget(title: "Product Detail"),
        12.ph,
        // Row(
        //   children: [
        //     Expanded(
        //         child: GenericTranslateWidget( 
        //       description,
        //       style: context.textStyle.bodyMedium,
        //     )),
        //   ],
        // ),
        Row(
          children: [
            Expanded(
              child: TextWithSeeMore(
                maxLength: 200,
                text: description,
              ),
            ),
          ],
        )
        // 12.ph,
        // GenericTranslateWidget( 
        //   "Key Features",
        //   style: context.textStyle.bodyMedium,
        // ),
        // features.length > 1
        // ?
        // ReadMoreWidget(items: features)
        //     : Padding(
        //         padding: EdgeInsets.only(left: 10.r),
        //         child: Row(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             GenericTranslateWidget( 
        //               "•",
        //               style: context.textStyle.bodyMedium!,
        //             ),
        //             10.pw,
        //             Expanded(
        //               child: TextWithSeeMore(
        //                 maxLength: 80,
        //                 text: features[0],
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),

        // Padding(
        //     padding: EdgeInsets.only(left: 10.r),
        //     child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         GenericTranslateWidget( 
        //           "•",
        //           style: context.textStyle.bodyMedium!,
        //         ),
        //         10.pw,
        //         Expanded(
        //             child: GenericTranslateWidget( 
        //           features?[0] ?? "This is Best" * 10,
        //           style: context.textStyle.bodyMedium,
        //         )),
        //       ],
        //     )),

        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     GenericTranslateWidget( 
        //       " •",
        //       style: context.textStyle.bodyMedium!
        //           .copyWith(color: const Color(0xff727272)),
        //     ),
        //     10.pw,
        //     Expanded(
        //       child: GenericTranslateWidget( 
        //         "sfdghasfdgasfdgh" * 1,
        //         style: context.textStyle.bodyMedium!,
        //         // overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
        //       ),
        //     ),
        //   ],
        // )
      ],
    );
  }
}

class LocationDetailWidget extends StatelessWidget {
  final String address;
  final double lat;
  final double long;
  const LocationDetailWidget(
      {super.key,
      required this.address,
      required this.lat,
      required this.long});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleHeadingWidget(title: "Location"),
        AddressDisplayTextWidget(address: address),
        LocationWidget(
          lat: lat,
          long: long,
        )
      ],
    );
  }
}

class AdDetailWidget extends StatelessWidget {
  final bool? showRecipt;
  final VoidCallback? onTap;
  final List<ProductDetailTitleDataModel> list;

  const AdDetailWidget(
      {super.key, this.showRecipt = false, this.onTap, required this.list});

  @override
  Widget build(BuildContext context) {
    // List<ProductDetailTitleDataModel> list = [];
    // if (showRecipt!) {
    //   list = List.from(list);
    //   list.insertAll(2, [
    // ProductDetailTitleDataModel(
    //     title: "Buying receipt", description: "View Receipt")
    //   ]);

    // } else {
    //   list = List.from(list);
    // }
    return Column(
      spacing: 10.h,
      children: [
        const Row(
          children: [TitleHeadingWidget(title: "Details")],
        ),
        ...List.generate(
          list.length,
          (index) => ProductDetailTitleWidget(
            title: list[index].title,
            description: list[index].description,
            showOutline: index != list.length - 1,
            onTap: onTap,
          ),
        )
      ],
    );
  }
}

class ProductDetailTitleWidget extends StatelessWidget {
  final String title;
  final String description;
  final bool showOutline;
  final VoidCallback? onTap;

  const ProductDetailTitleWidget(
      {super.key,
      required this.title,
      required this.description,
      this.onTap,
      this.showOutline = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 3.r),
      padding: EdgeInsets.symmetric(vertical: 5.r),
      decoration: BoxDecoration(
          border: showOutline
              ? Border(bottom: BorderSide(color: AppColors.borderColor))
              : null),
      child: Row(
        children: [
          GenericTranslateWidget( 
            title,
            style: context.textStyle.bodyMedium!.copyWith(fontSize: 16.sp),
          ),
          Expanded(
              child: description != "View Receipt"
                  ? GenericTranslateWidget( 
                      description,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      style: context.textStyle.displayMedium!
                          .copyWith(fontSize: 16.sp),
                    )
                  : GestureDetector(
                      onTap: onTap,
                      child: GenericTranslateWidget( 
                        description,
                        textAlign: TextAlign.right,
                        style: context.textStyle.displayMedium!.copyWith(
                          decoration: TextDecoration.underline,
                          fontSize: 16.sp,
                          color: AppColors.primaryColor,
                        ),
                      )))
        ],
      ),
    );
  }
}

class ProductTitleWidget extends StatelessWidget {
  final String? title;
  final String? address;
  final double? price;
  final String? status;

  const ProductTitleWidget(
      {super.key, this.title, this.address, this.price, this.status});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GenericTranslateWidget( 
                title ??
                    "Best Travel neck pillow available two sets in good price",
                style:
                    context.textStyle.displayLarge!.copyWith(fontSize: 20.sp),
              ),
            )
          ],
        ),
        10.ph,
        Row(
          children: [
            GenericTranslateWidget( 
              "\$${price ?? 12.00}",
              style: context.textStyle.headlineLarge,
            ),
            const Spacer(),
            if (status != "Active")
              Container(
                height: 36.h,
                padding: EdgeInsets.symmetric(horizontal: 16.r),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(100.r),
                        right: Radius.circular(100.r))),
                child: GenericTranslateWidget( 
                  status == "Sold" ? "Sold" : "Expired",
                  style: context.textStyle.bodyMedium!
                      .copyWith(color: Colors.white),
                ),
              )
          ],
        ),
        AddressDisplayTextWidget(
            address: address ?? "Rainbow Resort, San Luis Obispo"),
      ],
    );
  }
}

class AddressDisplayTextWidget extends StatelessWidget {
  final String address;

  const AddressDisplayTextWidget({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(Assets.locationIcon,
            colorFilter: ColorFilter.mode(
              context.colors.primary,
              BlendMode.srcIn,
            )),
        5.pw,
        Expanded(
            child: GenericTranslateWidget( 
          address,
          style: context.textStyle.bodyMedium!
              .copyWith(color: context.colors.primary),
        ))
      ],
    );
  }
}

class ProductMultipleImageDisplayWidget extends StatefulWidget {
  final List<String> images;

  final double? height;

  const ProductMultipleImageDisplayWidget(
      {super.key, this.height, required this.images});

  @override
  State<ProductMultipleImageDisplayWidget> createState() =>
      _ProductMultipleImageDisplayWidgetState();
}

class _ProductMultipleImageDisplayWidgetState
    extends State<ProductMultipleImageDisplayWidget> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 397.h,
      width: double.infinity,
      child: Column(
        children: [
          if (widget.images.isNotEmpty)
            Expanded(
                child: GestureDetector(
              onTap: () => AppRouter.push(FullScreenImageView(
                  imageUrls: widget.images, initialIndex: index)),
              child: DisplayNetworkImage(
                imageUrl: widget.images[index],
                width: double.infinity,
              ),
            )),
          5.ph,
          SizedBox(
            height: 70.h,
            width: double.infinity,
            child: ListView.separated(
                padding: EdgeInsets.symmetric(
                    horizontal: AppStyles.screenHorizontalPadding,
                    vertical: 5.r),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) => GestureDetector(
                      onTap: () {
                        index = i;
                        setState(() {});
                      },
                      child: Container(
                        height: 62.r,
                        width: 65.r,
                        padding: index == i ? EdgeInsets.all(1.4.r) : null,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            gradient: AppColors.primaryGradinet),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r - 1.4.r),
                            child: DisplayNetworkImage(
                                imageUrl: widget.images[i])),
                      ),
                    ),
                separatorBuilder: (context, index) => 7.pw,
                itemCount: widget.images.length),
          )
        ],
      ),
    );
  }
}

class ProductDetailTitleDataModel {
  late final String title;
  late final String description;

  ProductDetailTitleDataModel({required this.title, required this.description});

  static final List<ProductDetailTitleDataModel> detailList = [
    // ProductDetailTitleDataModel(title: "Brand", description: "Unknown"),
    ProductDetailTitleDataModel(title: "Condition", description: "New"),
    ProductDetailTitleDataModel(
        title: "Check In", description: "20 may 2024,3:20pm"),
    ProductDetailTitleDataModel(
        title: "Check Out", description: "26 may 2024,3:20pm"),
    ProductDetailTitleDataModel(title: "Set", description: "2"),
  ];
}
