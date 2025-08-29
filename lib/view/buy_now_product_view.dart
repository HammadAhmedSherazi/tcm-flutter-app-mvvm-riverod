import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';


class BuyNowProductView extends ConsumerStatefulWidget {
  final StoreProductDetailDataModel data;
  const BuyNowProductView({super.key, required this.data});

  @override
  ConsumerState<BuyNowProductView> createState() =>
      _BuyNowProductViewConsumerState();
}

class _BuyNowProductViewConsumerState extends ConsumerState<BuyNowProductView> {
  List<String> safetyInstruction = [
    "Only meet in public / crowded places.",
    "Never go alone to meet a buyer/seller always take someone with you.",
    "Trust your instincts—if something feels off, walk away from the deal.",
    "Check and inspect the product properly"
  ];

  @override
  void initState() {
    Future.microtask(() {
      ref.read(cardProvider).unsetCard();
      ref.read(productDataProvider).unSetLocation();
      ref.read(authRepoProvider).unSetContactInfo();
    });
    super.initState();
  }
  void showUserInfoBottomSheet(
      BuildContext context, WidgetRef ref, ContactInfoDataModel contactInfo) {
    final nameController = TextEditingController(text: contactInfo.username);
    final PhoneNumber? phone = contactInfo.phoneNo != ""
        ? PhoneNumber.parse(contactInfo.phoneNo.replaceAll("null", "+1"))
        : null;
    final phoneNumberController =
        TextEditingController(text: phone != null ? phone.nsn : "");

    // phoneNumberController.text = frPhone0.nsn;
    // initialCountryCode = frPhone0.isoCode.name;
    // String phoneNumber = ;
    String initialCountryCode = phone != null ? phone.isoCode.name : "US";
    String countryCode = phone != null ? phone.countryCode : "+1";
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
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // GenericTranslateWidget( "Enter your details",
              //     style: context.textStyle.displayMedium),
              // 16.ph,

              // Name Field
              CustomTextFieldWidget(ref:ref,
                hintText: 'Full Name',
                controller: nameController,
              ),

              16.ph,

              // Phone Number Field with Country Code
              IntlPhoneField(
                disableLengthCheck: false,
                controller: phoneNumberController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.r, horizontal: 14.r),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: AppColors.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: AppColors.borderColor),
                  ),
                  hintText: "Phone",
                  hintStyle: context.inputTheme.hintStyle!
                      .copyWith(color: Colors.black.withValues(alpha: 0.5)),
                ),
                initialCountryCode: initialCountryCode,
                onChanged: (phone) {
                  phoneNumberController.text = phone.number;
                  countryCode = phone.countryCode;
                },
              ),

              16.ph,

              CustomButtonWidget(
                  title: "Done",
                  onPressed: () {
                    ref.read(authRepoProvider).setContactInfo(
                        nameController.text,
                        "$countryCode${phoneNumberController.text}");
                    AppRouter.back();
                  })
            ],
          ),
        );
      },
    );
  }



  bool isConfirm = false;
  final ScrollController scrollController = ScrollController();
  int quantity = 1;

  String shippingType = "Standard";
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(cardProvider);
    final userProvider = ref.watch(authRepoProvider);
    final productProvider = ref.watch(productDataProvider);
    final totalAmount = (widget.data.productPrice! * quantity) +
       Helper.getDeliveryPriceByType(
            widget.data.storeData.deliveryOptions, shippingType);
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
                child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              trackVisibility: true,
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.symmetric(
                    horizontal: AppStyles.screenHorizontalPadding),
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!isConfirm) {
                        AppRouter.push(const SelectLocationView(
                          isCheckoutProcess: true,
                        ));
                      }
                    },
                    child: Container(
                      height: 67.h,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 10.r),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: AppColors.borderColor),
                          color: const Color(0xffEFEDEC)),
                      child: productProvider.deliveryLocation == null
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  Assets.plusIcon,
                                  width: 24.r,
                                ),
                                GenericTranslateWidget( 
                                  "Add Shipping Address",
                                  style: context.textStyle.displayMedium!
                                      .copyWith(fontSize: 16.sp),
                                )
                              ],
                            )
                          : Row(
                              children: [
                                Container(
                                  width: 50.r,
                                  height: 50.r,
                                  padding: EdgeInsets.all(8.r),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(3.13.r)),
                                  child: SvgPicture.asset(
                                      Assets.setPinLocationIcon),
                                ),
                                10.pw,
                                Expanded(
                                    child: GenericTranslateWidget( 
                                  productProvider.deliveryLocation!.placeName,
                                  style: context.textStyle.displayMedium!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                if (!isConfirm)
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 17.r,
                                  )
                              ],
                            ),
                    ),
                  ),
                  //PRODUCT WIDGET
                  20.ph,
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: DisplayNetworkImage(
                          imageUrl: widget.data.productImage ?? "",
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
                              widget.data.productName ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.textStyle.displayMedium!
                                  .copyWith(fontSize: 16.sp),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GenericTranslateWidget( 
                                  "\$${widget.data.productPrice! * quantity}",
                                  style: context.textStyle.displayLarge!
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                                if (isConfirm) ...[
                                  GenericTranslateWidget( 
                                    "Qty: $quantity",
                                    style: context.textStyle.displayMedium,
                                  )
                                ],
                                if (!isConfirm) ...[
                                  Container(
                                    height: 40.h,
                                    padding: EdgeInsets.all(1.r),
                                    decoration: BoxDecoration(
                                        color: const Color(0xffEFEDEC),
                                        borderRadius:
                                            BorderRadius.circular(421.r)),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (quantity > 0) {
                                              quantity--;
                                              setState(() {});
                                            }
                                          },
                                          child: Container(
                                            height: 36.r,
                                            width: 36.r,
                                            padding: EdgeInsets.all(7.r),
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle),
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
                                          onTap: () {
                                            quantity++;
                                            setState(() {});
                                          },
                                          child: Container(
                                            height: 36.r,
                                            width: 36.r,
                                            padding: EdgeInsets.all(7.r),
                                            decoration: const BoxDecoration(
                                                gradient:
                                                    AppColors.primaryGradinet,
                                                shape: BoxShape.circle),
                                            child: SvgPicture.asset(
                                              Assets.plusIcon,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                      Colors.white,
                                                      BlendMode.srcIn),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  if (widget.data.storeData.deliveryOptions != null) ...[
                    18.ph,
                    Row(
                      children: [
                        GenericTranslateWidget( 
                          "Delivery Options",
                          style: context.textStyle.displayMedium!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    18.ph,
                    ListView.separated(
                      itemBuilder: (context, i) {
                        final option =
                            widget.data.storeData.deliveryOptions![i];
                        return isConfirm
                            ? shippingType == option.type
                                ? DeliverOptionSelectionWidget(
                                    deliveryTime:
                                        " Delivery in ${option.description}",
                                    isSelect: shippingType == option.type,
                                    price: option.price.toString(),
                                    title: "${option.type} Delivery",
                                    isfinal: isConfirm,
                                    onTap: () {},
                                  )
                                : const SizedBox.shrink()
                            : DeliverOptionSelectionWidget(
                                deliveryTime:
                                    " Delivery in ${option.description}",
                                isSelect: shippingType == option.type,
                                price: option.price.toString(),
                                title: "${option.type} Delivery",
                                isfinal: isConfirm,
                                onTap: () {
                                  shippingType = option.type;

                                  setState(() {});
                                },
                              );
                      },
                      separatorBuilder: (context, index) => 10.ph,
                      itemCount: widget.data.storeData.deliveryOptions!.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  ],

                  20.ph,
                  Row(
                    children: [
                      Expanded(
                        child: GenericTranslateWidget( 
                          provider.selectCard != null
                              ? "Payment Method"
                              : "Select Payment Method",
                          style: context.textStyle.displayMedium!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      if (provider.selectCard != null && !isConfirm)
                        GestureDetector(
                          onTap: () {
                            AppRouter.push(const SelectPaymentAddMoreView(
                              isCheckOut: true,
                            ));
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
                      if (provider.selectCard == null && !isConfirm) {
                        AppRouter.push(const SelectPaymentAddMoreView(
                          isCheckOut: true,
                        ));
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
                          if (provider.selectCard == null)
                            SvgPicture.asset(
                              Assets.plusIcon,
                              width: 22.r,
                            ),
                          Expanded(
                            child: GenericTranslateWidget( 
                              provider.selectCard == null
                                  ? "Add Card"
                                  : "${Helper.capitalize(provider.selectCard!.brand)} ****${provider.selectCard!.last4}",
                              style: context.textStyle.displayMedium!,
                            ),
                          ),
                          provider.selectCard != null
                              ? SvgPicture.asset(Helper.setCardIcon(
                                  provider.selectCard!.brand))
                              : const Icon(Icons.add_card)
                        ],
                      ),
                    ),
                  ),
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
              ),
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
                        "Merchandise Subtotal",
                        style: context.textStyle.displayMedium,
                      ),
                      10.pw,
                      GenericTranslateWidget( 
                        "(1 item)",
                        style: context.textStyle.bodySmall,
                      ),
                      const Spacer(),
                      GenericTranslateWidget( 
                        "\$${widget.data.productPrice! * quantity}",
                        style: context.textStyle.bodyMedium!.copyWith(
                            fontSize: 18.sp, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  5.ph,
                  Row(
                    children: [
                      GenericTranslateWidget( 
                        "Shipping Fee Subtotal",
                        style: context.textStyle.displayMedium,
                      ),
                      const Spacer(),
                      GenericTranslateWidget( 
                        "\$${Helper.getDeliveryPriceByType(widget.data.storeData.deliveryOptions, shippingType)}",
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
                        totalAmount.toStringAsFixed(2),
                        style: context.textStyle.displayMedium!.copyWith(
                            fontSize: 20.sp, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  20.ph,
                  CustomButtonWidget(
                      isLoad: productProvider.buyNowApiResponse.status ==
                          Status.loading,
                      title: isConfirm ? "Confirm Order" : "Checkout",
                      onPressed: () {
                        if (productProvider.deliveryLocation == null) {
                          Helper.showMessage("Please select a location");
                        } else if (provider.selectCard == null) {
                          Helper.showMessage("Please select a payment method");
                        } 
                        else if (userProvider.contactInfo == null) {
                          Helper.showMessage("Please enter a contact info");
                        } 
                        else {
                          if (!isConfirm) {
                            isConfirm = true;
                            setState(() {});
                          } else {
                            ref.read(productDataProvider).buyNow(
                              contactInfo: userProvider.contactInfo!.toJson(),
                                paymentMethodId: provider.selectCard!.id,
                                shippingAddress:
                                    productProvider.deliveryLocation!.toJson2(),
                                productId: widget.data.id!,
                                saveCard: provider.cards.any((x) => x.fingerPrint == provider.selectCard!.fingerPrint)
    ? false
    : provider.saveCard,
                                productAmount: double.tryParse(totalAmount.toStringAsFixed(2))! - Helper.getDeliveryPriceByType(
                                    widget.data.storeData.deliveryOptions,
                                    shippingType),
                                quantity: quantity,
                                deliveryChargers:Helper.getDeliveryPriceByType(
                                    widget.data.storeData.deliveryOptions,
                                    shippingType));
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


