import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';

class ProductItemCard extends StatelessWidget {
  final ProductDataModel product;
  final bool? isAddToCard;
  final int productId;
  final int categoryId;
  final Function? fun;
  final bool? isUnder10;
  final bool? isFavourite;
  final int index;
  final String keyString;
  final List<ProductDataModel> list;

  const ProductItemCard(
      {super.key,
      required this.product,
      required this.productId,
      required this.categoryId,
      this.fun,
      this.isAddToCard = false,
      this.isUnder10,
      this.isFavourite = false,
      required this.keyString,
      required this.list,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!product.isStoreProduct) {
          AppRouter.push(
              // product.isStoreProduct
              // ? VenderProductDetailView(product: product)
              // :
              ProductDetailView(
                productId: productId,
                categoryId: categoryId,
                isUnder10: isUnder10,
              ), fun: () {
            if (fun != null) {
              fun!();
            }

            // }
            // final id = ref.watch(productDataProvider).lastId;
          });
        }
        else{
          AppRouter.push(
              // product.isStoreProduct
              // ? VenderProductDetailView(product: product)
              // :
              VenderProductDetailView(
               id: productId,
               index: index,
               keyString: keyString,
               list: list,
              ), fun: () {
            if (fun != null) {
              fun!();
            }

            // }
            // final id = ref.watch(productDataProvider).lastId;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          isAddToCard!
              ? Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: DisplayNetworkImage(
                          imageUrl: product.productImage!,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                      ),
                      Positioned(
                          top: 10,
                          right: 7,
                          child: Consumer(
                            builder: (_, ref, __) {
                              final productProvider = ref.watch(productDataProvider);
                              return GestureDetector(
                                onTap: () {
                                  if(product.quantity! >0){
                                    if(productProvider.checkOutList.length <= 10){
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
                                              builder:
                                                  (context, scrollController) {
                                                return Container(
                                                  padding: EdgeInsets.all(AppStyles
                                                      .screenHorizontalPadding),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.r),
                                                            child:
                                                                DisplayNetworkImage(
                                                              imageUrl: product
                                                                      .productImage ??
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
                                                                      child:
                                                                          GenericTranslateWidget( 
                                                                        product.productName ??
                                                                            "Red Bull Energy Drink Can 250ml Pack of 4 full Extreme Energy",
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: context
                                                                            .textStyle
                                                                            .displayMedium!
                                                                            .copyWith(fontSize: 16.sp),
                                                                      ),
                                                                    ),
                                                                    GenericTranslateWidget( 
                                                                      "Avaliable Stock: ${product.quantity}",
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
                                                                      "\$${product.productPrice}",
                                                                      style: context
                                                                          .textStyle
                                                                          .displayLarge!
                                                                          .copyWith(
                                                                              fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          40.h,
                                                                      padding: EdgeInsets
                                                                          .all(1
                                                                              .r),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: const Color(
                                                                            0xffEFEDEC),
                                                                        borderRadius:
                                                                            BorderRadius.circular(421.r),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              if (quantity > 1) {
                                                                                setState(() {
                                                                                  quantity--;
                                                                                });
                                                                              }
                                                                            },
                                                                            child:
                                                                                Container(
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
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 18.r),
                                                                            child:
                                                                                GenericTranslateWidget( 
                                                                              "$quantity",
                                                                              style: context.textStyle.displayMedium!.copyWith(fontSize: 18.sp),
                                                                            ),
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                if (quantity < product.quantity!) {
                                                                                  quantity++;
                                                                                }
                                                                              });
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: 36.r,
                                                                              width: 36.r,
                                                                              padding: EdgeInsets.all(7.r),
                                                                              decoration: quantity < product.quantity!
                                                                                  ? const BoxDecoration(
                                                                                      gradient: AppColors.primaryGradinet,
                                                                                      shape: BoxShape.circle,
                                                                                    )
                                                                                  : const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
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
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const Spacer(),
                                                      Consumer(
                                                        builder: (_,
                                                            WidgetRef ref, __) {
                                                          return CustomButtonWidget(
                                                            title:
                                                                "Add To Cart",
                                                            onPressed: () {
                                                              ref
                                                                  .read(
                                                                      productDataProvider)
                                                                  .addToCard(
                                                                      product:
                                                                          product,
                                                                      quantity:
                                                                          quantity,
                                                                      index:
                                                                          index,
                                                                          list: productProvider.storeProducts,
                                                                        categoryKey: keyString

                                                                          );
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
                           
                                  }
                                  else{
                                    Helper.showMessage("Cart limit reached: 10 items maximum.");
                                  }
                                  }else{
                                     Helper.showMessage("Product is out of stock");
                                  }
                                  
                                
                                       },
                                child: Container(
                                  height: 30.r,
                                  width: 30.r,
                                  padding: EdgeInsets.all(5.r),
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .white, // Background color (white)
                                    borderRadius: BorderRadius.circular(
                                        4.r), // Border radius of 4px
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                            alpha:
                                                0.25), // Shadow color with opacity
                                        offset: const Offset(0,
                                            4), // Horizontal and vertical offsets (0px, 4px)
                                        blurRadius: 8.2, // Blur radius (8.2px)
                                        spreadRadius:
                                            0, // No spread of the shadow
                                      ),
                                    ],
                                  ),
                                  child: SvgPicture.asset(Assets.addCartIcon),
                                ),
                              );
                            },
                          )),
                    ],
                  ),
                )
              : Expanded(
                  child: isFavourite!
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: DisplayNetworkImage(
                                imageUrl: product.productImage!,
                                height: double.infinity,
                                width: double.infinity,
                              ),
                            ),
                            Positioned(
                                top: 10,
                                right: 7,
                                child: Consumer(
                                  builder: (_, WidgetRef ref, __) {
                                    return GestureDetector(
                                      onTap: () {
                                        ref
                                            .read(productDataProvider)
                                            .checkFavourite(
                                                true, productId, index);
                                      },
                                      child: Container(
                                        height: 30.r,
                                        width: 30.r,
                                        padding: EdgeInsets.all(5.r),
                                        decoration: const BoxDecoration(
                                            color: Colors
                                                .white, // Background color (white)
                                            // Border radius of 4px
                                            shape: BoxShape.circle),
                                        child: SvgPicture.asset(
                                            Assets.favouriteCheckedIcon),
                                      ),
                                    );
                                  },
                                ))
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: DisplayNetworkImage(
                            imageUrl: product.productImage!,
                            height: double.infinity,
                            width: double.infinity,
                          ),
                        ),
                ),
          5.ph,
          // Space between image and product name
          SizedBox(
            height: 50.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: GenericTranslateWidget( 
                  product.productName!,
                  style: context.textStyle.labelMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                )),
              ],
            ),
          ),
          // 5.ph,
          // Spacer(),
          GenericTranslateWidget( 
            "\$${product.productPrice}",
            style: context.textStyle.displayMedium!.copyWith(fontSize: 18.sp),
          ),
        ],
      ),
    );
  }
}
