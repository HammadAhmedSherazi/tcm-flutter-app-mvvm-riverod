import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';

class MyCartView extends ConsumerStatefulWidget {
  const MyCartView({super.key});

  @override
  ConsumerState<MyCartView> createState() => _MyCartViewConsumerState();
}

class _MyCartViewConsumerState extends ConsumerState<MyCartView> {
  // List<bool> check = [];
  List<StoreOrderDataModel> buildStoreOrderDataModels(
      List<CheckoutListItemModel> selectedItems) {
    // Step 2: Group by storeId
    final Map<int, List<CheckoutListItemModel>> groupedByStore = {};

    for (var item in selectedItems) {
      final storeId = item.product.storeData.id;
      if (!groupedByStore.containsKey(storeId)) {
        groupedByStore[storeId] = [];
      }
      groupedByStore[storeId]!.add(item);
    }

    // Step 3: Convert each group into StoreOrderDataModel
    final List<StoreOrderDataModel> storeOrders = [];

    groupedByStore.forEach((storeId, items) {
      storeOrders.add(
        StoreOrderDataModel(
          shippingType: "Standard", 
          storeId: storeId,
          orderItems: items.map((item) {
            return OrderItemDataModel(
              cartId: item.id,
              productId: item.product.id!,
              quantity: item.quantity,
            );
          }).toList(),
          product: List.from(items.map((e) => e.product)), // Optional field
        ),
      );
    });

    return storeOrders;
  }

  @override
  void initState() {
    Future.microtask(() {
      ref.read(productDataProvider).getCartsItem();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(productDataProvider);
    final checkoutList = provider.checkOutList;
    final status = provider.getCartItemsApiResponse.status;

    final List<int> trueIndexes = checkoutList
        .asMap()
        .entries
        .where((entry) => entry.value.isSelect)
        .map((entry) => entry.key)
        .toList();
    final isCheck = provider.checkOutList.length == trueIndexes.length;
    final List<CheckoutListItemModel> selectedItem =
        List.from(checkoutList.where((e) => e.isSelect));
    final total = double.tryParse(selectedItem.fold(0.0, (total, item) => total + (item.product.productPrice! * item.quantity)).toStringAsFixed(2))!;

    return CommonScreenTemplateWidget(
        leadingWidget: const CustomBackButtonWidget(),
        onRefresh: () async {
          ref.read(productDataProvider).getCartsItem();
        },
        bottomWidget: checkoutList.isNotEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppStyles.screenHorizontalPadding,
                    vertical: AppStyles.screenHorizontalPadding),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        ref.read(productDataProvider).checkAllCarts(!isCheck);
                      },
                      child: Container(
                        width: 22.r,
                        height: 22.r,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient:
                                isCheck ? AppColors.primaryGradinet : null,
                            border: !isCheck
                                ? Border.all(color: Colors.black)
                                : null),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 17.r,
                        ),
                      ),
                    ),
                    5.pw,
                    GenericTranslateWidget( 
                      "All",
                      style: context.textStyle.bodyMedium,
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GenericTranslateWidget( 
                          "Total:",
                          style: context.textStyle.displayMedium!
                              .copyWith(fontSize: 16.sp),
                        ),
                        GenericTranslateWidget( 
                          "\$${selectedItem.fold(0.0, (total, item) => total + (item.product.productPrice! * item.quantity)).toStringAsFixed(2)}",
                          style: context.textStyle.displayLarge!.copyWith(
                              fontWeight: FontWeight.w700, fontSize: 24.sp),
                        )
                      ],
                    ),
                    20.pw,
                    SizedBox(
                        width: 126.w,
                        child: CustomButtonWidget(
                            title: selectedItem.isNotEmpty
                                ? "Check Out (${selectedItem.length})"
                                : "Check Out",
                            onPressed: () {
                              if (selectedItem.isNotEmpty) {
                                ref
                                    .read(productDataProvider.notifier)
                                    .setOrderList(buildStoreOrderDataModels(
                                        selectedItem));
                                AppRouter.push( StoreCheckoutView(
                                  totalAmount: total ,
                                ));
                              } else {
                                Helper.showMessage(
                                    "Please select any cart item");
                              }
                            }))
                  ],
                ),
              )
            : null,
        actionWidget: checkoutList.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  if (isCheck) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r)),
                        actions: [
                          TextButton(
                            onPressed: () {
                              AppRouter.back();
                            },
                            child: GenericTranslateWidget( 
                              "No",
                              style: context.textStyle.displayMedium!
                                  .copyWith(fontSize: 18.sp),
                            ),
                          ),
                          Consumer(
                            builder: (_, WidgetRef ref, __) {
                              final isLoad = ref
                                  .watch(productDataProvider)
                                  .clearCartItemsApiResponse
                                  .status;
                              return isLoad == Status.loading
                                  ? const CircularProgressIndicator()
                                  : TextButton(
                                      onPressed: () {
                                        ref
                                            .read(productDataProvider)
                                            .clearCart();
                                      },
                                      child: GenericTranslateWidget( 
                                        "Yes",
                                        style: context.textStyle.displayMedium!
                                            .copyWith(fontSize: 18.sp),
                                      ),
                                    );
                            },
                          ),
                        ],
                        content: Row(
                          children: [
                            Expanded(
                              child: GenericTranslateWidget( 
                                "Are you sure to delete all cart items?",
                                style: context.textStyle.displayMedium!
                                    .copyWith(fontSize: 20.sp),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    if (trueIndexes.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r)),
                          actions: [
                            TextButton(
                              onPressed: () {
                                AppRouter.back();
                              },
                              child: GenericTranslateWidget( 
                                "No",
                                style: context.textStyle.displayMedium!
                                    .copyWith(fontSize: 18.sp),
                              ),
                            ),
                            Consumer(
                              builder: (_, WidgetRef ref, __) {
                                final isLoad = ref
                                    .watch(productDataProvider)
                                    .deleteItemsApiResponse
                                    .status;
                                return isLoad == Status.loading
                                    ? const CircularProgressIndicator()
                                    : TextButton(
                                        onPressed: () {
                                          ref
                                              .read(productDataProvider)
                                              .removeCardItem(
                                                  id: List.generate(
                                                trueIndexes.length,
                                                (index) =>
                                                    checkoutList[index].id,
                                              ));

                                          // ref
                                          //     .read(productDataProvider)
                                          //     .clearCart();
                                        },
                                        child: GenericTranslateWidget( 
                                          "Yes",
                                          style: context
                                              .textStyle.displayMedium!
                                              .copyWith(fontSize: 18.sp),
                                        ),
                                      );
                              },
                            ),
                          ],
                          content: Row(
                            children: [
                              Expanded(
                                child: GenericTranslateWidget( 
                                  "Are you sure to delete selected cart items?",
                                  style: context.textStyle.displayMedium!
                                      .copyWith(fontSize: 20.sp),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      Helper.showMessage("Please select any cart please");
                    }
                  }
                },
                child: Container(
                  width: 31.r,
                  height: 31.r,
                  padding: EdgeInsets.all(6.r),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: SvgPicture.asset(
                    Assets.deleteIcon,
                  ),
                ),
              )
            : null,
        title: "My Cart",
        child: status == Status.error
            ? CustomErrorWidget(onPressed: () {
                ref.read(productDataProvider).getCartsItem();
              })
            : status == Status.completed
                ? checkoutList.isNotEmpty
                    ? ListView.separated(
                        itemBuilder: (context, index) {
                          final item = checkoutList[index];
                          return AddCartWidget(
                            index: index,
                            title: checkoutList[index].product.productName!,
                            maxQuanity: item.product.quantity ?? 1,
                            subtitle: item.product.productDescription ?? "",
                            price: item.product.productPrice!,
                            image: item.product.productImage!,
                            storeName: item.product.storeData.title,
                            storeImage: item.product.storeData.image,
                            isSelect: item.isSelect,
                            isAvaliable: item.product.isAvaliable!,
                            isStock: item.product.isStock!,
                            onTap: () {
                              if(total <999999.99){
                                ref
                                  .read(productDataProvider)
                                  .toggleCheckCart(index);
                              }
                              else{
                                Helper.showMessage("You can not select more than 999999.99");
                              }
                              
                            },
                          );
                        },
                        separatorBuilder: (context, index) => 10.ph,
                        itemCount: checkoutList.length)
                    : SizedBox(
                        width: context.screenwidth,
                        height: context.screenheight,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: AppStyles.screenHorizontalPadding,
                              right: AppStyles.screenHorizontalPadding,
                              bottom: 100.r),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(Assets.noCartItemLottie,
                                  width: 240.r),
                              GenericTranslateWidget( 
                                "No Product In Cart",
                                style: context.textStyle.displayLarge!
                                    .copyWith(fontSize: 22.sp),
                              )
                            ],
                          ),
                        ),
                      )
                : const CustomLoadingWidget());
    // child: ListView(
    //   children: [
    // AddCartWidget(
    //   title: "Red bull Energy drink 24 can available",
    //   subtitle: "Redbull, Energy Drink, Weight 32gram",
    //   price: "12.00",
    //   image: "",
    //   isSelect: cart1,
    //   onTap: () {
    //     cart1 = !cart1;
    //     setState(() {});
    //   },
    // ),
    //     10.ph,
    //     AddCartWidget(
    //       title: "Red bull Energy drink 24 can available",
    //       subtitle: "Redbull, Energy Drink, Weight 32gram",
    //       price: "12.00",
    //       image: "",
    //       isSelect: cart2,
    //       onTap: () {
    //         cart2 = !cart2;
    //         setState(() {});
    //       },
    //     )
    //   ],
    // ));
  }
}

class AddCartWidget extends StatelessWidget {
  final String title;
  final double price;
  final String subtitle;
  final String image;
  final int maxQuanity;
  final bool isSelect;
  final int index;
  final String storeImage;
  final String storeName;
  final bool isAvaliable;
  final bool isStock;
  final VoidCallback onTap;
  const AddCartWidget(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.image,
      required this.price,
      required this.maxQuanity,
      required this.isSelect,
      required this.index,
      required this.storeName,
      required this.storeImage,
      required this.isAvaliable,
      required this.isStock,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
          horizontal: AppStyles.screenHorizontalPadding, vertical: 20.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              20.ph,
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 22.r,
                  height: 22.r,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isSelect ? AppColors.primaryGradinet : null,
                      border:
                          !isSelect ? Border.all(color: Colors.black) : null),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 17.r,
                  ),
                ),
              ),
            ],
          ),
          10.pw,
          Expanded(
              child: Column(
            children: [
              Row(
                children: [
                  DisplayNetworkImage(
                    imageUrl: storeImage,
                    width: 35.r,
                    height: 33.r,
                  ),
                  5.pw,
                  GenericTranslateWidget( 
                    storeName,
                    style: context.textStyle.displayMedium,
                  )
                ],
              ),
              10.ph,
              if(!isAvaliable)
              GenericTranslateWidget( "This product is no longer active, so please remove from cart items", style: context.textStyle.bodySmall!.copyWith(
                                color: Colors.black.withValues(alpha: 0.6)),),
              if(isAvaliable && !isStock)
              GenericTranslateWidget( "This product is out of stock, so please remove from cart items", style: context.textStyle.bodySmall!.copyWith(
                                color: Colors.black.withValues(alpha: 0.6)),),              

              Row(
                spacing: 10,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9.r),
                    child: DisplayNetworkImage(
                      imageUrl: image,
                      width: 99.r,
                      height: 93.r,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        GenericTranslateWidget( 
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textStyle.displayMedium,
                        ),
                        // 10.ph,
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.r, vertical: 2),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 67, 240, 246)
                                  .withValues(alpha: 0.10)),
                          child: GenericTranslateWidget( 
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textStyle.bodySmall!.copyWith(
                                color: Colors.black.withValues(alpha: 0.6)),
                          ),
                        ),
                        // 10.ph,
                        Consumer(
                          builder: (_, WidgetRef ref, __) {
                            final quantity = ref
                                .watch(productDataProvider)
                                .checkOutList[index]
                                .quantity;

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GenericTranslateWidget( 
                                  double.tryParse("${price * quantity}")!.toStringAsFixed(2),
                                  style: context.textStyle.displayMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20.sp),
                                ),
                                Container(
                                  height: 40.h,
                                  padding: EdgeInsets.all(1.r),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffEFEDEC),
                                    borderRadius: BorderRadius.circular(421.r),
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (quantity > 1) {
                                            ref
                                                .read(productDataProvider)
                                                .removeQuantity(index);
                                          } else {
                                            // ref
                                            //     .read(productDataProvider)
                                            //     .setAddCardResponse();
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.r)),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      AppRouter.back();
                                                    },
                                                    child: GenericTranslateWidget( 
                                                      "No",
                                                      style: context.textStyle
                                                          .displayMedium!
                                                          .copyWith(
                                                              fontSize: 18.sp),
                                                    ),
                                                  ),
                                                  Consumer(
                                                    builder:
                                                        (_, WidgetRef ref, __) {
                                                      final isLoad = ref
                                                          .watch(
                                                              productDataProvider)
                                                          .deleteItemsApiResponse
                                                          .status;
                                                      return isLoad ==
                                                              Status.loading
                                                          ? const CircularProgressIndicator()
                                                          : TextButton(
                                                              onPressed: () {
                                                                ref
                                                                    .read(
                                                                        productDataProvider)
                                                                    .removeCardItem(
                                                                        id: [
                                                                      ref
                                                                          .read(
                                                                              productDataProvider)
                                                                          .checkOutList[
                                                                              index]
                                                                          .id
                                                                    ]);

                                                                // ref
                                                                //     .read(productDataProvider)
                                                                //     .clearCart();
                                                              },
                                                              child: GenericTranslateWidget( 
                                                                "Yes",
                                                                style: context
                                                                    .textStyle
                                                                    .displayMedium!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            18.sp),
                                                              ),
                                                            );
                                                    },
                                                  ),
                                                ],
                                                content: Row(
                                                  children: [
                                                    Expanded(
                                                      child: GenericTranslateWidget( 
                                                        "Are you sure to remove this cart item?",
                                                        style: context.textStyle
                                                            .displayMedium!
                                                            .copyWith(
                                                                fontSize:
                                                                    20.sp),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Container(
                                          height: 36.r,
                                          width: 36.r,
                                          padding: EdgeInsets.all(7.r),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: SvgPicture.asset(
                                            Assets.deleteIcon,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18.r),
                                        child: GenericTranslateWidget( 
                                          "$quantity",
                                          style: context
                                              .textStyle.displayMedium!
                                              .copyWith(fontSize: 18.sp),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: quantity < maxQuanity
                                            ? () {
                                                ref
                                                    .read(productDataProvider)
                                                    .addQuantity(index);
                                              }
                                            : () {},
                                        child: Container(
                                          height: 36.r,
                                          width: 36.r,
                                          padding: EdgeInsets.all(7.r),
                                          decoration: quantity < maxQuanity
                                              ? const BoxDecoration(
                                                  gradient:
                                                      AppColors.primaryGradinet,
                                                  shape: BoxShape.circle,
                                                )
                                              : const BoxDecoration(
                                                  color: Colors.grey,
                                                  shape: BoxShape.circle),
                                          child: SvgPicture.asset(
                                            Assets.plusIcon,
                                            colorFilter: const ColorFilter.mode(
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
                            );
                          },
                        ),

                        // GenericTranslateWidget( 
                        //   "\$$price",
                        //   style: context.textStyle.displayMedium!
                        //       .copyWith(fontSize: 18.sp),
                        // )
                      ],
                    ),
                  ),
                  // GenericTranslateWidget( "Qty: $quantity")
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}
