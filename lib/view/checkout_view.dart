import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';

class CheckoutView extends ConsumerStatefulWidget {

  final ProductDetailDataModel? product;
  const CheckoutView(
      {super.key,

      this.product,
});

  @override
  ConsumerState<CheckoutView> createState() => _CheckoutViewConsumerState();
}

class _CheckoutViewConsumerState extends ConsumerState<CheckoutView> {
 
  List<String> safetyInstruction = [
    "Only meet in public / crowded places.",
    "Never go alone to meet a buyer/seller always take someone with you.",
    "Trust your instincts—if something feels off, walk away from the deal.",
    "Check and inspect the product properly"
  ];
  @override
  void initState() {
   ref.read(cardProvider).unsetCard();
   ref.read(authRepoProvider).unSetContactInfo();
    super.initState();
  }
  bool isConfirm = false;
   @override
  Widget build(BuildContext context) {
    final provider = ref.watch(cardProvider);
    final productProvider = ref.watch(productDataProvider);
      final userProvider = ref.watch(authRepoProvider);
    final totalAmount = widget.product!.productPrice! + widget.product!.applicationFee!;
    return PopScope(
      canPop: !isConfirm,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && isConfirm) {
          isConfirm = false;
          setState(() {});
        }
      },
      child: CommonScreenTemplateWidget(
        title: "Checkout",
        leadingWidget: CustomBackButtonWidget(
          onTap: () {
            if (isConfirm) {
              isConfirm = false;
              setState(() {});
            } else {
              AppRouter.back();
            }
          },
        ),
        appBarHeight: 70.h,
        child: Column(
          children: [
            Expanded(
                child: ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: AppStyles.screenHorizontalPadding),
              children: [
                
               
                  20.ph,
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: DisplayNetworkImage(
                          imageUrl: widget.product?.productImage ?? "",
                          width: 77.297.w,
                          height: 75.595.h,
                        ),
                      ),
                      10.pw,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GenericTranslateWidget( 
                              widget.product?.productName ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.textStyle.displayMedium!
                                  .copyWith(fontSize: 16.sp),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GenericTranslateWidget( 
                                  "\$${widget.product?.productPrice}",
                                  style: context.textStyle.displayLarge!
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                               
                                  // Container(
                                  //   height: 40.h,
                                  //   padding: EdgeInsets.all(1.r),
                                  //   decoration: BoxDecoration(
                                  //       color: const Color(0xffEFEDEC),
                                  //       borderRadius:
                                  //           BorderRadius.circular(421.r)),
                                  //   child: Row(
                                  //     children: [
                                  //       GestureDetector(
                                  //         onTap: () {
                                  //           if (quantity > 0) {
                                  //             quantity--;
                                  //             setState(() {});
                                  //           }
                                  //         },
                                  //         child: Container(
                                  //           height: 36.r,
                                  //           width: 36.r,
                                  //           padding: EdgeInsets.all(7.r),
                                  //           decoration: const BoxDecoration(
                                  //               color: Colors.white,
                                  //               shape: BoxShape.circle),
                                  //           child: SvgPicture.asset(
                                  //             Assets.deleteIcon,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //       Padding(
                                  //         padding: EdgeInsets.symmetric(
                                  //             horizontal: 18.r),
                                  //         child: GenericTranslateWidget( 
                                  //           "$quantity",
                                  //           style: context
                                  //               .textStyle.displayMedium!
                                  //               .copyWith(fontSize: 18.sp),
                                  //         ),
                                  //       ),
                                  //       GestureDetector(
                                  //         onTap: () {
                                  //           quantity++;
                                  //           setState(() {});
                                  //         },
                                  //         child: Container(
                                  //           height: 36.r,
                                  //           width: 36.r,
                                  //           padding: EdgeInsets.all(7.r),
                                  //           decoration: const BoxDecoration(
                                  //               gradient:
                                  //                   AppColors.primaryGradinet,
                                  //               shape: BoxShape.circle),
                                  //           child: SvgPicture.asset(
                                  //             Assets.plusIcon,
                                  //             colorFilter: const ColorFilter.mode(
                                  //                 Colors.white, BlendMode.srcIn),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // )
                              
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                
            
                
                if ((
                        provider.selectCard != null) ||
                    !isConfirm) ...[
                  20.ph,
                  Row(
                    children: [
                      Expanded(
                        child: GenericTranslateWidget( 
                      provider.selectCard != null ?    "Payment Method" : "Select Payment Method",
                          style: context.textStyle.displayMedium!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      if(provider.selectCard != null && !isConfirm)
                      GestureDetector(
                        onTap: () {
                         AppRouter.push(const SelectPaymentAddMoreView());
                        },
                        child: GenericTranslateWidget( 
                          "Edit",
                          style: context.textStyle.displayMedium,
                        ),
                      )
                    ],
                  ),
                  12.ph,
                  GestureDetector(
                    onTap: () {
                      if(provider.selectCard == null){
                        AppRouter.push(const SelectPaymentAddMoreView());
                      }
                      
                    },
                    child: Container(
                      height: 44.h,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 12.r),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: AppColors.borderColor)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if(provider.selectCard == null)
                          SvgPicture.asset(
                            Assets.plusIcon,
                            width: 22.r,
                          ),
                          Expanded(
                            child: GenericTranslateWidget( 
                           provider.selectCard == null ? "Add Card" :   "${Helper.capitalize(provider.selectCard!.brand)} ****${provider.selectCard!.last4}",
                              style: context.textStyle.displayMedium!,
                            ),
                          ),
                         
                       provider.selectCard != null ? SvgPicture.asset(Helper.setCardIcon(provider.selectCard!.brand)) : const Icon(Icons.add_card)
                        ],
                      ),
                    ),
                  )
                ],
                 20.ph,
                    Row(
                      children: [
                        Expanded(
                          child: GenericTranslateWidget( 
                            "Contact Info",
                            style: context.textStyle.displayMedium!
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        if (userProvider.contactInfo != null && !isConfirm)
                          GestureDetector(
                            onTap: () {
                              showUserInfoBottomSheet(
                                  context, ref, userProvider.contactInfo!);
                            },
                            child: GenericTranslateWidget( 
                              "Edit",
                              style: context.textStyle.displayMedium,
                            ),
                          )
                      ],
                    ),
                    12.ph,
                    userProvider.contactInfo == null
                        ? GestureDetector(
                            onTap: () {
                              showUserInfoBottomSheet(
                                  context,
                                  ref,
                                  ContactInfoDataModel(
                                      username: userProvider.userData!.userName,
                                      phoneNo: userProvider.userData!.phoneNo));
                            },
                            child: Container(
                              height: 44.h,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 12.r),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  border:
                                      Border.all(color: AppColors.borderColor)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    Assets.plusIcon,
                                    width: 22.r,
                                  ),
                                  Expanded(
                                    child: GenericTranslateWidget( 
                                      "Add Contact Info",
                                      style: context.textStyle.displayMedium!,
                                    ),
                                  ),
                                  const Icon(Icons.person)
                                ],
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    GenericTranslateWidget( 
                                      "Name: ",
                                      style: context.textStyle.displayMedium,
                                    ),
                                    GenericTranslateWidget( 
                                      userProvider.contactInfo!.username,
                                      style: context.textStyle.bodyMedium,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GenericTranslateWidget( 
                                      "Phone: ",
                                      style: context.textStyle.displayMedium,
                                    ),
                                    GenericTranslateWidget( 
                                      userProvider.contactInfo!.phoneNo,
                                      style: context.textStyle.bodyMedium,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                   
               
              
                  30.ph,
                  GenericTranslateWidget( 
                    "Your safety matters to us!",
                    style: context.textStyle.displayMedium!
                        .copyWith(color: context.colors.primary),
                  ),
                  10.ph,
                  ...List.generate(
                    safetyInstruction.length,
                    (index) => Row(
                      children: [
                        10.pw,
                        const GenericTranslateWidget( "•"),
                        10.pw,
                        Expanded(child: GenericTranslateWidget( safetyInstruction[index]))
                      ],
                    ),
                  )
      
              ],
            )),
            
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: AppStyles.screenHorizontalPadding,
                    vertical: 30.r),
                decoration: const BoxDecoration(color: Color(0xffF8F8F8)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GenericTranslateWidget( 
                         "Product Price",
                          style: context.textStyle.displayMedium,
                        ),
                        // 10.pw,
                        // GenericTranslateWidget( 
                        //   "($quantity items)",
                        //   style: context.textStyle.bodySmall,
                        // ),
                        const Spacer(),
                        GenericTranslateWidget( 
                          "\$${widget.product!.productPrice! }",
                          style: context.textStyle.bodyMedium!.copyWith(
                              fontSize: 18.sp, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    5.ph,
                    Row(
                      children: [
                        GenericTranslateWidget( 
                          "Application Fee",
                          style: context.textStyle.displayMedium,
                        ),
                        const Spacer(),
                        GenericTranslateWidget( 
                         "\$${widget.product!.applicationFee}" ,
                          style: context.textStyle.bodyMedium!.copyWith(
                              fontSize: 18.sp, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    const Divider(),
                    10.ph,
                    Row(
                      children: [
                        GenericTranslateWidget( 
                          "Total",
                          style: context.textStyle.displayMedium!.copyWith(
                              fontSize: 20.sp, fontWeight: FontWeight.w700),
                        ),
                        const Spacer(),
                        GenericTranslateWidget( 
                     
                              "\$${totalAmount.toStringAsFixed(2)}"
                             ,
                          style: context.textStyle.displayMedium!.copyWith(
                              fontSize: 20.sp, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    20.ph,
                    CustomButtonWidget(
                        isLoad: productProvider.adBuyNowApiResponse.status ==
                          Status.loading,
                      title: isConfirm ? "Confirm Order" : "Checkout",
                        onPressed: () {
                        if (provider.selectCard == null) {
                          Helper.showMessage("Please select a payment method");
                        } else if (userProvider.contactInfo == null) {
                          Helper.showMessage("Please enter a contact info");
                        } else {
                          if (!isConfirm) {
                            isConfirm = true;
                            setState(() {});
                          } else {
                            ref.read(productDataProvider).adBuyNow(
                              product: widget.product!,
                                contactInfo: userProvider.contactInfo!.toJson(),
                                adId: widget.product!.id!,
                                amount: double.tryParse(totalAmount.toStringAsFixed(2))!,
                                paymentMethodId: provider.selectCard!.id,
                                saveCard: provider.cards.any((x) => x.fingerPrint == provider.selectCard!.fingerPrint)
    ? false
    : provider.saveCard);
                          }
                        }

                        }),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}

