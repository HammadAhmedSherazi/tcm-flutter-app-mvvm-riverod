
import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';


class StoreOrderView extends ConsumerStatefulWidget {
  const StoreOrderView({super.key});

  @override
  ConsumerState<StoreOrderView> createState() => _StoreOrderViewConsumerState();
}

class _StoreOrderViewConsumerState extends ConsumerState<StoreOrderView> {
  late final ScrollController? scrollController;
  int selectIndex = 0;
  final List<String> filterList = [
    "Pending",
    "Processing",
    "Dispatched",
    "Delivered"
  ];

  @override
  void initState() {
    scrollController = ScrollController();
    Future.microtask(() {
      ref.read(productDataProvider.notifier).onDispose();
      ref.read(productDataProvider.notifier).getStoreOrder(
          cursor: null, limit: 10, status: filterList[selectIndex]);
    });
    scrollController?.addListener(() {
      if (scrollController?.position.pixels ==
          scrollController?.position.maxScrollExtent) {
        Future.microtask(() {
          String? cursor = ref.watch(productDataProvider).orderHistoryCursor;
          // String status = ref.watch(productDataProvider).status;
          ref.read(productDataProvider).getStoreOrder(
              cursor: cursor, limit: 5, status: filterList[selectIndex]);
                });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(productDataProvider);
    final status = provider.orderApiResponse.status;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppStyles.screenHorizontalPadding, vertical: 15),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                filterList.length,
                (index) => GestureDetector(
                  onTap: () {
                    selectIndex = index;
                    ref.read(productDataProvider.notifier).getStoreOrder(
                        cursor: null,
                        limit: 10,
                        status: filterList[selectIndex]);
                    setState(() {});
                  },
                  child: Container(
                    height: 28.h,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 15.r),
                    margin: EdgeInsets.only(right: 5.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(15.r),
                          right: Radius.circular(15.r)),
                      gradient: selectIndex == index
                          ? AppColors.primaryGradinet
                          : null,
                    ),
                    child: GenericTranslateWidget( 
                      filterList[index],
                      style: context.textStyle.bodyMedium!.copyWith(
                          color: selectIndex == index
                              ? Colors.white
                              : Colors.black.withValues(alpha: 0.6)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
            child: RefreshIndicator(
          onRefresh: () async {
            ref.read(productDataProvider).getStoreOrder(
                cursor: null,
                limit: 5,
                status: selectIndex == 0 ? null : filterList[selectIndex]);
          },
          child: AsyncStateHandler(
              status: status,
              emptyMessage: "No order exist!",
              dataList: provider.orderHistory,
              padding: EdgeInsets.only(
                  left: AppStyles.screenHorizontalPadding,
                  right: AppStyles.screenHorizontalPadding,
                  bottom: 50.r),
              itemBuilder: (context, index) {
                if (status == Status.loadingMore &&
                    index == provider.orderHistory.length) {
                  return const CustomLoadingWidget();
                } else {
                  final OrderDataModel orderData = provider.orderHistory[index];
                  return GestureDetector(
                    onTap: () {
                      num totalShippingPrice =
                          orderData.stores.fold(0, (sum, store) {
                        return sum + store.shippingCost;
                      });
                      AppRouter.push(
                          OrderDetailView(
                              summary: {
                                "Order No": orderData.orderNo,
                                "Name": orderData.contactInfo.username,
                                "Phone": orderData.contactInfo.phoneNo,
                                "Sub total":
                                    "${orderData.totalAmount - totalShippingPrice}",
                                "Shipping Charges": "$totalShippingPrice"
                              },
                              totalAmount: orderData.totalAmount,
                              locationData: orderData.shippingAddress,
                              child: StoreOrderCardWidget(
                                showOrderId: false,
                                order: orderData,
                              )), fun: () {
                        ref.read(productDataProvider.notifier).getStoreOrder(
                            cursor: null,
                            limit: 10,
                            status: selectIndex == 0
                                ? null
                                : filterList[selectIndex]);
                      });
                    },
                    child: StoreOrderCardWidget(
                      order: orderData,
                      showOrderId: true,
                    ),
                  );
                }
              },
              onRetry: () {
                ref.read(productDataProvider.notifier).getStoreOrder(
                    cursor: null, limit: 10, status: filterList[selectIndex]);
              }),
        ))
      ],
    );
  }
}

class StoreOrderCardWidget extends StatelessWidget {
  final OrderDataModel order;
  final bool? showOrderId;
  const StoreOrderCardWidget(
      {super.key, required this.order, this.showOrderId = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white, // background: #FFF
        borderRadius: BorderRadius.circular(10), // border-radius: 10px
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.09), // rgba(0,0,0,0.09)
            offset: const Offset(0, 3), // x=0, y=3
            blurRadius: 4, // blur-radius: 4px
            spreadRadius: 0, // spread-radius: 0
          ),
        ],
      ),
      child: Column(
        spacing: 10,
        children: [
          if (showOrderId!)
            Row(
              children: [
                GenericTranslateWidget( 
                  "Order No: ${order.orderNo}",
                  style: context.textStyle.displayMedium!
                      .copyWith(fontSize: 18.sp),
                )
              ],
            ),
          ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final store = order.stores[index];
                return Column(
                  spacing: 10,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: DisplayNetworkImage(
                            imageUrl: store.store.image,
                            width: 37.r,
                            height: 32.r,
                          ),
                        ),
                        10.pw,
                        GenericTranslateWidget( 
                          store.store.title,
                          style: context.textStyle.displayMedium!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        if (store.status == "Pending")
                          CustomButtonWidget(
                              height: 30.h,
                              width: 100.r,
                              isElevated: true,
                              color: Colors.red,
                              title: "Cancel",
                              onPressed: () {
                                final TextEditingController
                                    reasonTextEditController =
                                    TextEditingController();

                                final formKey = GlobalKey<FormState>();
                                String value = "Ordered by mistake";
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  showDragHandle: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom +
                                            16,
                                        left: 16,
                                        right: 16,
                                      ),
                                      child: StatefulBuilder(
                                        builder: (context, setState) {
                                          return SingleChildScrollView(
                                            child: Form(
                                              key: formKey,
                                              child: Column(
                                                spacing: 10,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CustomDropDown(
                                                      placeholderText:
                                                          "Select Reason",
                                                      onChanged: (c) {
                                                        value = c!;
                                                        if (c != "Other") {
                                                          reasonTextEditController
                                                              .text = "";
                                                        }
                                                        setState(() {});
                                                      },
                                                      value: value,
                                                      options: [
                                                        "Ordered by mistake",
                                                        "Found a better price elsewhere",
                                                        "Item is no longer needed",
                                                        "Changed my mind",
                                                        "Estimated delivery time is too long",
                                                        "Wrong item or size ordered",
                                                        "I want to change my order",
                                                        "Other",
                                                      ]
                                                          .map((c) =>
                                                              CustomDropDownOption(
                                                                  value: c,
                                                                  displayOption:
                                                                      c))
                                                          .toList()),

                                                  // Review text input
                                                  Consumer(
                                                    builder: (context, ref, child) {
                                                      return CustomTextFieldWidget(ref:ref,
                                                        controller:
                                                            reasonTextEditController,
                                                        hintText:
                                                            "Write your reason here...",
                                                        minLines: 4,
                                                        maxline: 4,
                                                        readOnly: value != "Other",
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return "Please enter your review";
                                                          } else if (value.length >
                                                              1000) {
                                                            return "Review must not exceed 1000 characters";
                                                          }
                                                          return null;
                                                        },
                                                      );
                                                    }
                                                  ),

                                                  24.ph,

                                                  Consumer(
                                                    builder:
                                                        (_, WidgetRef ref, __) {
                                                      final productProvider =
                                                          ref.watch(
                                                              productDataProvider);
                                                      return CustomButtonWidget(
                                                        title: "Submit",
                                                        isLoad: productProvider
                                                                .createProductReviewApiResponse
                                                                .status ==
                                                            Status.loading,
                                                        onPressed: () {
                                                          if (value ==
                                                              "Other") {
                                                            if (formKey
                                                                .currentState!
                                                                .validate()) {
                                                              ref
                                                                  .read(productDataProvider
                                                                      .notifier)
                                                                  .cancelOrder(
                                                                      storeId:
                                                                          store
                                                                              .id,
                                                                      reason: reasonTextEditController
                                                                          .text,
                                                                      status: store
                                                                          .status);
                                                            }
                                                          } else {
                                                            ref
                                                                .read(productDataProvider
                                                                    .notifier)
                                                                .cancelOrder(
                                                                    storeId:
                                                                        store
                                                                            .id,
                                                                    reason:
                                                                        value,
                                                                    status: store
                                                                        .status);
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

                                // showReviewBottomSheet(BuildContext context,
                                //     {required int productId,
                                //     int? storeOrderId}) {

                                //    }
                              }),
                        if (store.status != "Pending")
                          Container(
                            height: 22.h,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 10.r),
                            decoration: BoxDecoration(
                                color: const Color(0xffE1E1E1),
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(10.r),
                                    right: Radius.circular(10.r))),
                            child: GenericTranslateWidget( 
                              store.status,
                              style: context.textStyle.bodySmall!.copyWith(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                      ],
                    ),
                    ListView.separated(
                      itemBuilder: (context, i) {
                        final item = store.orderItems[i];
                        return SizedBox(
                          height: 102.h,
                          child: Row(
                            spacing: 10,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: DisplayNetworkImage(
                                  imageUrl: item.image,
                                  width: 102.r,
                                  height: double.infinity,
                                ),
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: GenericTranslateWidget( 
                                        item.title,
                                        style: context.textStyle.displayMedium!
                                            .copyWith(fontSize: 18.sp),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                      GenericTranslateWidget( 
                                        "Qty: ${item.quantity}",
                                        style: context.textStyle.displayMedium,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                  if (store.shippingType == "Fast" &&
                                      store.status != "Delivered") ...[
                                    Row(
                                      children: [
                                        Container(
                                          height: 30.h,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.only(
                                              left: 12.6.r, right: 12.6),
                                          decoration: BoxDecoration(
                                              color: const Color(0xffFFFF00),
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                      left: Radius.circular(
                                                          700.r),
                                                      right: Radius.circular(
                                                          700.r))),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              GenericTranslateWidget( 
                                                'Fast Delivery',
                                                style: context
                                                    .textStyle.bodyMedium,
                                              ),
                                              3.pw,
                                              SvgPicture.asset(
                                                Assets.deliveryVanIcon,
                                                width: 17.r,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                  if (store.status == "Delivered") ...[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CustomButtonWidget(
                                            height: 30.h,
                                            width: 100.r,
                                            isElevated: !item.isRefunded,
                                            color: Colors.red,
                                            title: !item.isRefunded
                                                ? "Refund"
                                                : "Refunded",
                                            onPressed: !item.isRefunded
                                                ? () {
                                                    final TextEditingController
                                                        reasonTextEditController =
                                                        TextEditingController();

                                                    final ValueNotifier<
                                                            List<File>> images =
                                                        ValueNotifier([]);
                                                    String value =
                                                        "Damaged_Item";
                                                    final formKey =
                                                        GlobalKey<FormState>();

                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      showDragHandle: true,
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        20)),
                                                      ),
                                                      builder: (context) {
                                                        return Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            bottom: MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom +
                                                                16,
                                                            left: 16,
                                                            right: 16,
                                                          ),
                                                          child:
                                                              StatefulBuilder(
                                                            builder: (context,
                                                                setState) {
                                                              return SingleChildScrollView(
                                                                child: Form(
                                                                  key: formKey,
                                                                  child: Column(
                                                                    spacing: 10,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      CustomDropDown(
                                                                          placeholderText:
                                                                              "Select Reason",
                                                                          onChanged:
                                                                              (c) {
                                                                            value =
                                                                                c!;
                                                                            if (c !=
                                                                                "Other") {
                                                                              reasonTextEditController.text = "";
                                                                            }
                                                                            setState(() {});
                                                                          },
                                                                          value:
                                                                              value,
                                                                          options: const [
                                                                            CustomDropDownOption(
                                                                                value: "Damaged_Item",
                                                                                displayOption: "Damaged Item"),
                                                                            CustomDropDownOption(
                                                                                value: "Wrong_Item",
                                                                                displayOption: "Wrong Item"),
                                                                            CustomDropDownOption(
                                                                                value: "Missing_Item",
                                                                                displayOption: "Missing Item"),
                                                                            CustomDropDownOption(
                                                                                value: "Other",
                                                                                displayOption: "Other"),
                                                                          ]),
                                                                      // Review text input
                                                                      Consumer(
                                                                        builder: (context, ref, child) {
                                                                          return CustomTextFieldWidget(ref:ref,
                                                                            controller:
                                                                                reasonTextEditController,
                                                                            hintText:
                                                                                "Write your reason here...",
                                                                            minLines:
                                                                                4,
                                                                            maxline:
                                                                                4,
                                                                            readOnly:
                                                                                value !=
                                                                                    "Other",
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null ||
                                                                                  value
                                                                                      .isEmpty) {
                                                                                return "Please enter your review";
                                                                              } else if (value.length >
                                                                                  1000) {
                                                                                return "Review must not exceed 1000 characters";
                                                                              }
                                                                              return null;
                                                                            },
                                                                          );
                                                                        }
                                                                      ),

                                                                      16.ph,
                                                                      // Preview attached images
                                                                      if (images
                                                                          .value
                                                                          .isNotEmpty)
                                                                        ValueListenableBuilder<
                                                                            List<File>>(
                                                                          valueListenable:
                                                                              images,
                                                                          builder: (context,
                                                                              files,
                                                                              _) {
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
                                                                                        images.value = List.from(images.value)..remove(file);
                                                                                      },
                                                                                      child: const CircleAvatar(
                                                                                        radius: 10,
                                                                                        backgroundColor: Colors.red,
                                                                                        child: Icon(Icons.close, size: 12, color: Colors.white),
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
                                                                        onTap:
                                                                            () async {
                                                                          if (images.value.length >=
                                                                              5) {
                                                                            Helper.showMessage("You can only select 5 images");
                                                                            return;
                                                                          }
                                                                          final selectImages = await ImageSelector.selectImages(
                                                                              context: context,
                                                                              compressImageFn: Helper.compressImage,
                                                                              maxImages: 5);
                                                                          if (selectImages
                                                                              .isNotEmpty) {
                                                                            images.value = List.from(images.value)
                                                                              ..addAll(selectImages);
                                                                            setState(() {});
                                                                          }
                                                                        },
                                                                        child:
                                                                            Row(
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
                                                                        builder: (_,
                                                                            WidgetRef
                                                                                ref,
                                                                            __) {
                                                                          final productProvider =
                                                                              ref.watch(productDataProvider);
                                                                          return CustomButtonWidget(
                                                                            title:
                                                                                "Submit",
                                                                            isLoad:
                                                                                productProvider.createProductReviewApiResponse.status == Status.loading,
                                                                            onPressed:
                                                                                () {
                                                                              if (images.value.isEmpty) {
                                                                                Helper.showMessage("Please attach images");
                                                                                return;
                                                                              }
                                                                              if (value == "Other") {
                                                                                if (formKey.currentState!.validate()) {
                                                                                  ref.read(productDataProvider.notifier).refundRequest(images: images.value, orderItemId: order.id, reason: reasonTextEditController.text, reasonCode: value, status: store.status);
                                                                                }
                                                                              } else {
                                                                                ref.read(productDataProvider.notifier).refundRequest(images: images.value, orderItemId: order.id, reason: value.replaceAll("_", " "), reasonCode: value, status: store.status);
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
                                                : null),
                                      ],
                                    )
                                  ],
                                  // Row(
                                  //   children: [
                                  //     Container(
                                  //       height: 22.h,
                                  //       alignment: Alignment.center,
                                  //       padding: EdgeInsets.symmetric(
                                  //           horizontal: 10.r),
                                  //       decoration: BoxDecoration(
                                  //           color: const Color(0xffE1E1E1),
                                  //           borderRadius:
                                  //               BorderRadius.horizontal(
                                  //                   left: Radius.circular(10.r),
                                  //                   right:
                                  //                       Radius.circular(10.r))),
                                  //       child: GenericTranslateWidget( 
                                  //         "Home",
                                  //         style: context.textStyle.bodySmall!
                                  //             .copyWith(
                                  //                 color: Colors.black
                                  //                     .withValues(alpha: 0.4),
                                  //                 fontWeight: FontWeight.w500),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GenericTranslateWidget( 
                                        "\$${item.totalAmount}",
                                        style: context.textStyle.displayMedium!
                                            .copyWith(fontSize: 18.sp),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      CustomButtonWidget(
                                          height: 30.h,
                                          width: 100.r,
                                          isElevated: true,
                                          title: "Buy Again",
                                          onPressed: () {
                                            AppRouter.push(
                                                VenderProductDetailView(
                                                    id: item.productId,
                                                    orderId: item.id,
                                                    index: -1,
                                                    list: const [],
                                                    keyString: ""));
                                          })
                                    ],
                                  ),
                                ],
                              ))
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, i) => const Divider(),
                      itemCount: store.orderItems.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) => 10.ph,
              itemCount: order.stores.length)
        ],
      ),
    );
  }
}
