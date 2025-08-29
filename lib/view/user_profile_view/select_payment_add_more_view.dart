import 'package:tcm/utils/app_extensions.dart';
import '../../export_all.dart';

// import '../attached_bank_detail_view.dart';

class SelectPaymentAddMoreView extends ConsumerStatefulWidget {
  final bool? isCheckOut;
  const SelectPaymentAddMoreView({super.key, this.isCheckOut});

  @override
  ConsumerState<SelectPaymentAddMoreView> createState() =>
      _SelectPaymentAddMoreViewConsumerState();
}

class _SelectPaymentAddMoreViewConsumerState
    extends ConsumerState<SelectPaymentAddMoreView> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(cardProvider).getCards();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(cardProvider);
    final status = provider.myCardApiResponse.status;
    final cards = status == Status.loading
        ? List.generate(
            4,
            (index) => CardDataModel(
                id: "ss",
                brand: "brand",
                expMonth: "expMonth",
                expYear: "expYear",
                last4: "last4",
                fingerPrint: "type"),
          )
        : provider.cards;
    return CommonScreenTemplateWidget(
        title: "Select Payment",
        leadingWidget: const CustomBackButtonWidget(),
        appBarHeight: 60.h,
        onRefresh: () async {
          ref.read(cardProvider).getCards();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppStyles.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12.h,
            children: [
              GenericTranslateWidget( "Add Card",
                  style: context.textStyle.displayMedium!.copyWith(
                      fontSize: 16.sp,
                      color: AppColors.lightIconColor,
                      fontWeight: FontWeight.w700)),

              CustomListWidget(
                iconPayment: null,
                title: "Card",
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.lightIconColor,
                  size: 16.r,
                ),
                onTap: () {
                  AppRouter.push(AddCardView(
                    isCheckOut: widget.isCheckOut ?? false,
                  ));
                },
              ),

              // GenericTranslateWidget( "Add Bank Details",
              //     style: context.textStyle.displayMedium!.copyWith(
              //         fontSize: 16.sp,
              //         color: AppColors.lightIconColor,
              //         fontWeight: FontWeight.w700)),

              // CustomListWidget(
              //   iconPayment: "Bank",
              //   title: "Attach Bank Details",
              //   trailing: Icon(
              //     Icons.arrow_forward_ios,
              //     color: AppColors.lightIconColor,
              //     size: 16.r,
              //   ),
              //   onTap: () {
              //     // ref.read(cardProvider).attachPaymentMethod();
              //     AppRouter.push(const AttachBankForm());
              //   },
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GenericTranslateWidget( "My Cards",
                      style: context.textStyle.displayMedium!.copyWith(
                          fontSize: 16.sp,
                          color: AppColors.lightIconColor,
                          fontWeight: FontWeight.w700)),
                  // GenericTranslateWidget( "Remove",
                  //     style: context.textStyle.displayMedium!.copyWith(
                  //         fontSize: 16.sp,
                  //         color: AppColors.lightIconColor,
                  //         fontWeight: FontWeight.w600)),
                ],
              ),

              // Container(
              //   height: 60,
              //   decoration: BoxDecoration(
              //     color: Colors.transparent,
              //     borderRadius: BorderRadius.circular(10),
              //     border: Border.all(
              //         width: 1,
              //         color: AppColors.lightIconColor.withValues(alpha: 0.1)),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 10),
              //     child: Row(
              //       children: [
              //         GenericTranslateWidget( "Mastercard  ****8018",
              //             style: context.textStyle.displayMedium!.copyWith(
              //                 fontSize: 14.sp,
              //                 color: AppColors.lightIconColor,
              //                 fontWeight: FontWeight.w600)),
              //         const Spacer(),
              //         Container(
              //           width: 40.r,
              //           height: 40.r,
              //           padding: EdgeInsets.all(8.r),
              //           child: SvgPicture.asset(Assets.masterCard),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // 32.ph,

              Expanded(
                  child: status == Status.error
                      ? CustomErrorWidget(
                          onPressed: () {
                            ref.read(cardProvider).getCards();
                          },
                        )
                      : status == Status.completed && cards.isEmpty
                          ? const ShowEmptyItemDisplayWidget(
                              message: "No cards exists")
                          : Skeletonizer(
                              enabled: status == Status.loading,
                              child: ListView.separated(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    final card = cards[index];
                                    return CustomListWidget(
                                      trailing: IconButton(
                                          visualDensity: const VisualDensity(
                                              horizontal: -4.0, vertical: -4.0),
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
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
                                                          .watch(cardProvider)
                                                          .removeCardApiResponse
                                                          .status;
                                                      return isLoad ==
                                                              Status.loading
                                                          ? const CircularProgressIndicator()
                                                          : TextButton(
                                                              onPressed: () {
                                                                ref
                                                                    .read(
                                                                        cardProvider)
                                                                    .removeCard(
                                                                        id: card
                                                                            .id,
                                                                        index:
                                                                            index);
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
                                                        "Are you sure to delete this card?",
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
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            size: 22.r,
                                            color: Colors.red,
                                          )),
                                      
                                      iconPayment:
                                          Helper.setCardIcon(card.brand),
                                      title: "**** **** **** ${card.last4}",
                                      onTap: () {
                                        // if (!widget.isCheckOut!) {
                                        ref
                                            .read(cardProvider)
                                            .setCard(cards[index]);
                                        AppRouter.back();
                                        // }
                                        // else{
                                        //   ref.read(productDataProvider).setCard(cards[index]);
                                        //    AppRouter.back();
                                        // }

                                        // AppRouter.push(const AddCardView());
                                      },
                                    );
                                    // CustomListWidget(
                                    //     iconPayment: Helper.setCardIcon(
                                    //         cards[index].brand),
                                    //     title:
                                    //         "**** **** **** ${cards[index].last4}",
                                    //     onTap: () {
                                    //       if(!widget.isCheckOut!){
                                    //         ref
                                    //           .read(cardProvider)
                                    //           .setCard(cards[index]);
                                    //       AppRouter.back();
                                    //       }

                                    //       // AppRouter.push(const AddCardView());
                                    //     },
                                    //   );
                                  },
                                  separatorBuilder: (context, index) => 12.ph,
                                  itemCount: cards.length))),
              // CustomListWidget(
              //   iconPayment: Assets.visa,
              //   title: "Visa",
              //   onTap: () {
              //     AppRouter.push(const AddCardView());
              //   },
              // ),
              // 12.ph,
              // CustomListWidget(
              //   iconPayment: Assets.masterCard,
              //   title: "Master card",
              //   onTap: () {
              //     AppRouter.push(const AddCardView());
              //   },
              // ),
              // 12.ph,
              // CustomListWidget(
              //   iconPayment: Assets.paypal,
              //   title: "PayPal",
              //   onTap: () {
              //     AppRouter.push(const AddCardView());
              //   },
              // )
            ],
          ),
        ));
  }
}
