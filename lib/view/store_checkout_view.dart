import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';


class StoreCheckoutView extends ConsumerStatefulWidget {
  final num totalAmount;
  const StoreCheckoutView({super.key, required this.totalAmount});

  @override
  ConsumerState<StoreCheckoutView> createState() =>
      _StoreCheckoutViewConsumerState();
}

class _StoreCheckoutViewConsumerState extends ConsumerState<StoreCheckoutView> {
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

  bool isConfirm = false;
  final ScrollController scrollController = ScrollController();

    @override
  Widget build(BuildContext context) {
    final provider = ref.watch(cardProvider);
    final userProvider = ref.watch(authRepoProvider);
    final productProvider = ref.watch(productDataProvider);
    final List<StoreOrderDataModel> orderList = productProvider.orders;
    final num shippingPrice = double.tryParse(orderList
        .fold(
            0.0,
            (total, item) =>
                total +
                Helper.getDeliveryPriceByType(
                    item.product!.first.storeData.deliveryOptions,
                    item.shippingType))
        .toStringAsFixed(2))!;

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
                  ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return OrderCardWidget(
                        ref: ref,
                        index: index,
                        isConfirm: isConfirm,
                      );
                    },
                    separatorBuilder: (context, index) => 10.ph,
                    itemCount: orderList.length,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
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
                        "(${orderList.length}} items)",
                        style: context.textStyle.bodySmall,
                      ),
                      const Spacer(),
                      GenericTranslateWidget( 
                        "\$${widget.totalAmount.toStringAsFixed(2)}",
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
                        "\$$shippingPrice",
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
                        (widget.totalAmount + shippingPrice).toStringAsFixed(2),
                        style: context.textStyle.displayMedium!.copyWith(
                            fontSize: 20.sp, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  20.ph,
                  CustomButtonWidget(
                      isLoad: productProvider.orderCheckOutApiResponse.status ==
                          Status.loading,
                      title: isConfirm ? "Confirm Order" : "Checkout",
                      onPressed: () {
                        if (productProvider.deliveryLocation == null) {
                          Helper.showMessage("Please select a location");
                        } else if (provider.selectCard == null) {
                          Helper.showMessage("Please select a payment method");
                        } else if (userProvider.contactInfo == null) {
                          Helper.showMessage("Please enter a contact info");
                        } else {
                          if (!isConfirm) {
                            isConfirm = true;
                            setState(() {});
                          } else {
                            ref.read(productDataProvider).checkOut(
                                contactInfo: userProvider.contactInfo!.toJson(),
                                productAmount: widget.totalAmount - shippingPrice,
                                deliveryChargers: shippingPrice,
                                paymentMethodId: provider.selectCard!.id,
                                shippingAddress:
                                    productProvider.deliveryLocation!.toJson2(),
                                storesOrders: List.generate(
                                  orderList.length,
                                  (index) => orderList[index].toJson(),
                                ),
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

class OrderCardWidget extends StatelessWidget {
  final WidgetRef ref;
  final int index;
  final bool isConfirm;
  const OrderCardWidget(
      {super.key,
      required this.ref,
      required this.index,
      required this.isConfirm});

  @override
  Widget build(BuildContext context) {
    final order = ref.watch(productDataProvider).orders[index];
    return Column(
      children: [
        20.ph,
        Row(
          children: [
            DisplayNetworkImage(
              imageUrl: order.product!.first.storeData.image,
              width: 18.r,
              height: 18.r,
            ),
            4.pw,
            Expanded(
                child: Text( 
              order.product!.first.storeData.title,
              style: context.textStyle.displayMedium!
                  .copyWith(fontWeight: FontWeight.w700),
            ))
          ],
        ),
        20.ph,
        ListView.separated(
          itemBuilder: (context, i) {
            final product = order.product![i];
            return Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: DisplayNetworkImage(
                    imageUrl: product.productImage!,
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
                        product.productName!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyle.displayMedium!
                            .copyWith(fontSize: 16.sp),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GenericTranslateWidget( 
                              "\$${(product.productPrice! * order.orderItems[i].quantity).toStringAsFixed(2)}",
                              style: context.textStyle.displayLarge!
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          GenericTranslateWidget( "Qty: ${order.orderItems[i].quantity}")
                        ],
                      )
                    ],
                  ),
                )
              ],
            );
          },
          separatorBuilder: (context, index) => 10.ph,
          itemCount: order.product!.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
        ),
        20.ph,
        if (order.product!.first.storeData.deliveryOptions != null) ...[
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
              final option = order.product!.first.storeData.deliveryOptions![i];
              return isConfirm
                  ? order.shippingType == option.type
                      ? DeliverOptionSelectionWidget(
                          deliveryTime: " Delivery in ${option.description}",
                          isSelect: order.shippingType == option.type,
                          price: option.price.toString(),
                          title: "${option.type} Delivery",
                          isfinal: isConfirm,
                          onTap: () {
                            ref
                                .read(productDataProvider)
                                .selectDeliveryOption(index, option.type);
                          },
                        )
                      : const SizedBox.shrink()
                  : DeliverOptionSelectionWidget(
                      deliveryTime: " Delivery in ${option.description}",
                      isSelect: order.shippingType == option.type,
                      price: option.price.toString(),
                      title: "${option.type} Delivery",
                      isfinal: isConfirm,
                      onTap: () {
                        ref
                            .read(productDataProvider)
                            .selectDeliveryOption(index, option.type);
                      },
                    );
            },
            separatorBuilder: (context, index) => 10.ph,
            itemCount: order.product!.first.storeData.deliveryOptions!.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ]
      ],
    );
  }
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
    // String countryCode = phone != null ? phone.countryCode : "+1";
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
          child: Form(
            key: formKey,
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
                  keyboardType: TextInputType.name,
                  inputFormatter: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z\s]')), // Only letters and spaces
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Full name is required';
                    }
                    return null;
                  },
                ),

                16.ph,

                // Phone Number Field with Country Code
                IntlPhoneField(
                  disableLengthCheck: false,
                  controller: phoneNumberController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,signed: false
                  ),
                  validator: (value) {
                     if (value!.number.isEmpty) {
                      return 'Phone number is required';
                    }
                    return null;
                  },
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
                  onCountryChanged: (value) {
                    // countryCode = "+${value.dialCode}";
                    initialCountryCode = value.code;
                  },
                  onChanged: (phone) {
                    phoneNumberController.text = phone.number;
                    // countryCode = phone.countryCode;
                  },
                ),

                16.ph,

                CustomButtonWidget(
                    title: "Done",
                    onPressed: () {
                      if(formKey.currentState!.validate() ){
                        try {
                        final isoCode = IsoCode.values.firstWhere(
                          (c) => c.name == initialCountryCode.toUpperCase(),
                          orElse: () => IsoCode.US, // fallback
                        );

                        final parsed = PhoneNumber.parse(
                          phoneNumberController.text,
                          destinationCountry: isoCode,
                        );

                        if (parsed.isValid()) {
                          ref.read(authRepoProvider).setContactInfo(
                              nameController.text, parsed.international);
                          AppRouter.back();
                        } else {
                          Helper.showMessage(
                              "Please enter a valid phone number");
                        }
                      } catch (e) {
                        Helper.showMessage("Phone number format is invalid.");
                      }
                      }
                    })
              ],
            ),
          ),
        );
      },
    );
  }

