import 'package:tcm/utils/app_extensions.dart';
import '../../export_all.dart';


class MyReviewsView extends ConsumerStatefulWidget {
  const MyReviewsView({super.key});

  @override
  ConsumerState<MyReviewsView> createState() => _MyReviewsViewConsumerState();
}

class _MyReviewsViewConsumerState extends ConsumerState<MyReviewsView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      ref.read(productDataProvider).getProductReview(
          cursor: null, input: {"filter": "to_review", "limit": 10});
    });
    tabController.addListener(() {
      if (tabController.indexIsChanging) return;
      final provider = ref.watch(productDataProvider);
      if (provider.adApiResponse.status != Status.loading) {
        ref.read(productDataProvider).getProductReview(cursor: null, input: {
          "filter": tabController.index == 0 ? "to_review" : "my_review",
          "limit": 10
        });
      }
    });

    Future.microtask(() {
      // ref.read(productDataProvider).getMyAdProducts(
      //     limit: 15, cursor: null, myStatus: setType(tabController.index));
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Future.delayed(Duration.zero, () {
          String? cursor = ref.watch(productDataProvider).reviewCursor;

          ref
              .read(productDataProvider)
              .getProductReview(cursor: cursor, input: {
            "filter": tabController.index == 0 ? "to_review" : "my_review",
            "limit": 10
          });
                });
      }
    });
    super.initState();
  }

  final ScrollController scrollController = ScrollController();
  void showReviewBottomSheet(BuildContext context,
      {double? rating,
      String? review,
      List<File>? images,
      int? reviewId,
      required int productId,
      int? storeOrderId}) {
    // final TextEditingController _reviewController = TextEditingController();
    // final ValueNotifier<double> _rating = ValueNotifier(0);
    // final ValueNotifier<List<File>> _images = ValueNotifier([]);
    // final List<File> _images = [];
    // final double _rating = 0;
    // final String _review = "";
    final TextEditingController reviewController = review == null
        ? TextEditingController()
        : TextEditingController(text: review);
    final ValueNotifier<double> rating0 = ValueNotifier(rating ?? 0.0);
    final ValueNotifier<List<File>> images0 = ValueNotifier(images ?? []);
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GenericTranslateWidget( 
                            review == null
                                ? "Write a Review"
                                : "Update a Review",
                            style: context.textStyle.displayMedium!
                                .copyWith(fontSize: 18.sp),
                          ),
                        ],
                      ),

                      // Rating stars
                      ValueListenableBuilder<double>(
                        valueListenable: rating0,
                        builder: (context, value, _) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return IconButton(
                                icon: Icon(
                                  size: 35.r,
                                  value >= index + 1
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                ),
                                onPressed: rating == null
                                    ? () => rating0.value = index + 1.0
                                    : null,
                              );
                            }),
                          );
                        },
                      ),

                      // Review text input
                      CustomTextFieldWidget(ref:ref,
                        controller: reviewController,
                        hintText: "Write your review here...",
                        minLines: 4,
                        maxline: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your review";
                          } else if (value.length > 1000) {
                            return "Review must not exceed 1000 characters";
                          }
                          return null;
                        },
                      ),

                      16.ph,
                      // Preview attached images
                      if (images0.value.isNotEmpty)
                        ValueListenableBuilder<List<File>>(
                          valueListenable: images0,
                          builder: (context, files, _) {
                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.start,
                              children: files.map((file) {
                                return Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        AppRouter.push(FullImageView(
                                          imagePath: file.path,
                                        ));
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: file.path.contains('http')
                                            ? DisplayNetworkImage(
                                                imageUrl: file.path,
                                                width: 80.r,
                                                height: 80.r,
                                              )
                                            : Image.file(
                                                file,
                                                width: 80.r,
                                                height: 80.r,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        images0.value = List.from(images0.value)
                                          ..remove(file);
                                      },
                                      child: const CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.red,
                                        child: Icon(Icons.close,
                                            size: 12, color: Colors.white),
                                      ),
                                    )
                                  ],
                                );
                              }).toList(),
                            );
                          },
                        ),

                      // Attach images
                      const Divider(),
                      10.ph,

                      /// **Add Images Row**
                      GestureDetector(
                        onTap: () async {
                          if (images0.value.length >= 5) {
                            Helper.showMessage("You can only select 5 images");
                            return;
                          }
                          final selectImages = await ImageSelector.selectImages(
                              context: context,
                              compressImageFn: Helper.compressImage,
                              maxImages: 5);
                          if (selectImages.isNotEmpty) {
                            images0.value = List.from(images0.value)
                              ..addAll(selectImages);
                            setState(() {});
                          }
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              Assets.chatGalleryIcon,
                              width: 30.r,
                              height: 30.r,
                            ),
                            10.pw,
                            Expanded(
                              child: GenericTranslateWidget( 
                                "Add Images",
                                style: context.textStyle.bodyMedium,
                              ),
                            )
                          ],
                        ),
                      ),

                      24.ph,

                      Consumer(
                        builder: (_, WidgetRef ref, __) {
                          final productProvider =
                              ref.watch(productDataProvider);
                          return CustomButtonWidget(
                            title: "Submit",
                            isLoad: productProvider
                                    .createProductReviewApiResponse.status ==
                                Status.loading,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                if (review == null) {
                                  productProvider.createProductReview(
                                    storeOrderId: storeOrderId!,
                                    productId: productId,
                                    rating: rating0.value,
                                    review: reviewController.text,
                                    images: images0.value.isEmpty
                                        ? null
                                        : images0.value,
                                  );
                                } else {
                                  productProvider.updateProductReview(
                                    id: reviewId!,
                                    productId: productId,
                                    oldImages: List.from(images0.value
                                        .where((e) => e.path.contains('http'))
                                        .map((e) => e.path.replaceFirst(
                                            BaseApiServices.imageURL, ''))),
                                    review: reviewController.text,
                                    images: images0.value.isEmpty
                                        ? null
                                        : List.from(images0.value.where(
                                            (e) => !(e.path.contains('http')))),
                                  );
                                }
                              }

                              // Close bottom sheet
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(productDataProvider);
    final status = provider.productReviewApiResponse.status;
    final isLoad = status == Status.loading;
    final list = isLoad
        ? List.generate(
            3,
            (index) => ProductReviewsDataModel(
                id: -1, review: "sfdgsfh", rating: 0.0, user: null),
          )
        : provider.productReviews;
    return CommonScreenTemplateWidget(
        appBarHeight: AppBar().preferredSize.height + 70.h,
        leadingWidget: const CustomBackButtonWidget(),
        bottomAppbarWidget:
            CustomTabBarWidget(controller: tabController, tabs: [
                Tab(text: Helper.getCachedTranslation(ref: ref, text: "Reviews")),
                Tab(text: Helper.getCachedTranslation(ref: ref, text:  "History")),
     
         
        ]),
        title: "My Reviews",
        child: TabBarView(controller: tabController, children: [
          AsyncStateHandler(
            status: status,
            dataList: list,
            scrollController: scrollController,
            padding: EdgeInsets.all(AppStyles.screenHorizontalPadding),
            // loadingWidget: Skeletonizer(
            //   enabled: isLoad,
            //   child: ListView.separated(
            //       shrinkWrap: true,
            //       padding: EdgeInsets.symmetric(
            //           horizontal: AppStyles.screenHorizontalPadding),
            //       physics: const NeverScrollableScrollPhysics(),
            //       itemBuilder: (context, index) {
            //         final review = list[index];
            //         return GenericTranslateWidget( "${review.id}");
            //       },
            //       separatorBuilder: (context, index) => 10.ph,
            //       itemCount: list.length),
            // ),
            itemBuilder: (context, index) {
              if (index == list.length - 1 && status == Status.loadingMore) {
                return const Center(child: CircularProgressIndicator());
              } else {
                final review = list[index];

                return Column(
                  spacing: 10.h,
                  children: [
                    Row(
                      children: [
                        DisplayNetworkImage(
                          imageUrl: review.product!.storeData.image,
                          width: 35.r,
                          height: 33.r,
                        ),
                        5.pw,
                        Text( 
                          review.product!.storeData.title,
                          style: context.textStyle.displayMedium,
                        )
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 95.h,
                      child: Row(
                        spacing: 10.w,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: DisplayNetworkImage(
                                imageUrl: review.product!.productImage!,
                                height: double.infinity,
                                width: 95.r,
                              )),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GenericTranslateWidget( 
                                review.product!.productName!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: context.textStyle.displayMedium!,
                              ),

                              // TextButton(
                              //     style: const ButtonStyle(
                              //       visualDensity: VisualDensity(
                              //           horizontal: -4, vertical: -4),
                              //       padding:
                              //           WidgetStatePropertyAll(EdgeInsets.zero),
                              //     ),
                              //     onPressed: () {
                              //       showReviewBottomSheet(context,
                              //           productId: review.product!.id!,
                              //           storeOrderId: review.storeOrderId,
                              //           images: null,
                              //           rating: null,
                              //           review: null,
                              //           reviewId: null);
                              //     },
                              //     child: GenericTranslateWidget( 
                              //       "Review",
                              //       style: context.textStyle.displayMedium!
                              //           .copyWith(
                              //         color: AppColors.primaryColor,
                              //         decoration: TextDecoration.underline,
                              //       ),
                              //     )),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomButtonWidget(
                                    title: "Review",
                                    onPressed: () {
                                      showReviewBottomSheet(context,
                                          productId: review.product!.id!,
                                          storeOrderId: review.storeOrderId,
                                          images: null,
                                          rating: null,
                                          review: null,
                                          reviewId: null);
                                    },
                                    width: 100.w,
                                    height: 30.h,
                                  ),
                                ],
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
            onRetry: () {
              ref.read(productDataProvider).getProductReview(
                  cursor: null, input: {"filter": "to_review", "limit": 10});
            },
          ),
          AsyncStateHandler(
            status: status,
            dataList: list,
            padding: EdgeInsets.all(AppStyles.screenHorizontalPadding),
            scrollController: scrollController,
            // loadingWidget: Skeletonizer(
            //   enabled: isLoad,
            //   child: ListView.separated(
            //       shrinkWrap: true,
            //       padding: EdgeInsets.symmetric(
            //           horizontal: AppStyles.screenHorizontalPadding),
            //       physics: const NeverScrollableScrollPhysics(),
            //       itemBuilder: (context, index) {
            //         final review = list[index];
            //         return ;
            //       },
            //       separatorBuilder: (context, index) => 10.ph,
            //       itemCount: list.length),
            // ),
            itemBuilder: (context, index) {
              if (index == list.length - 1 && status == Status.loadingMore) {
                return const Center(child: CircularProgressIndicator());
              } else {
                final review = list[index];
                DateTime currentDate = review.createdAt ?? DateTime.now();

                // Get previous date (if exists)
                DateTime? previousDate =
                    index > 0 ? list[index - 1].createdAt : null;

                // Show date header if it's the first item or a new day
                bool showDateHeader = currentDate.day != previousDate!.day ||
                    currentDate.month != previousDate.month ||
                    currentDate.year != previousDate.year;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showDateHeader) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: GenericTranslateWidget( 
                          Helper.getReadableDateHeader(currentDate),
                          style: context.textStyle.displayMedium!
                              .copyWith(fontSize: 16.sp),
                        ),
                      ),
                    ],
                    Column(
                      spacing: 10.h,
                      children: [
                        Row(
                          children: [
                            DisplayNetworkImage(
                              imageUrl: review.product!.storeData.image,
                              width: 35.r,
                              height: 33.r,
                            ),
                            5.pw,
                            Text( 
                              review.product!.storeData.title,
                              style: context.textStyle.displayMedium,
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                showReviewBottomSheet(context,
                                    productId: review.product!.id!,
                                    storeOrderId: review.storeOrderId,
                                    images: review.images.isNotEmpty
                                        ? List.from(
                                            review.images.map((e) => File(e)))
                                        : null,
                                    rating: review.rating,
                                    review: review.review,
                                    reviewId: review.id);
                              },
                              icon: SvgPicture.asset(Assets.editProfile),
                              padding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(
                                  horizontal: -4.0, vertical: -4.0),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 110.h,
                          child: Row(
                            spacing: 10.w,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: DisplayNetworkImage(
                                    imageUrl: review.product!.productImage!,
                                    height: double.infinity,
                                    width: 98.r,
                                  )),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GenericTranslateWidget( 
                                    review.product!.productName! * 10,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.textStyle.displayMedium!,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: GenericTranslateWidget( 
                                        review.review,
                                        style: context.textStyle.bodySmall,
                                      )),
                                      Row(
                                        children: List.generate(
                                          review.images.length,
                                          (index) => ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6.r),
                                            child: DisplayNetworkImage(
                                              imageUrl: review.images[index],
                                              width: 52.r,
                                              height: 68.r,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),

                                  // TextButton(
                                  //     style: const ButtonStyle(
                                  //       visualDensity: VisualDensity(
                                  //           horizontal: -4, vertical: -4),
                                  //       padding:
                                  //           WidgetStatePropertyAll(EdgeInsets.zero),
                                  //     ),
                                  //     onPressed: () {
                                  //       showReviewBottomSheet(context,
                                  //           productId: review.product!.id!,
                                  //           storeOrderId: review.storeOrderId,
                                  //           images: null,
                                  //           rating: null,
                                  //           review: null,
                                  //           reviewId: null);
                                  //     },
                                  //     child: GenericTranslateWidget( 
                                  //       "Review",
                                  //       style: context.textStyle.displayMedium!
                                  //           .copyWith(
                                  //         color: AppColors.primaryColor,
                                  //         decoration: TextDecoration.underline,
                                  //       ),
                                  //     )),

                                  CustomRatingIndicator(rating: review.rating)
                                ],
                              ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
            onRetry: () {
              ref.read(productDataProvider).getProductReview(
                  cursor: null, input: {"filter": "my_review", "limit": 10});
            },
          ),
        ]));
  }
}
