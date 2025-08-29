import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';

class OrderConfirmationView extends StatelessWidget {
  final bool? isVender;
  final ProductDetailDataModel? product;
  final num productAmounts;
  final num deliveryCharger;
  final num totalAmount;
  OrderConfirmationView({super.key, this.isVender = false, required this.product, required this.productAmounts, required this.deliveryCharger, required this.totalAmount});
  final List<String> safetyInstruction = [
    "Only meet in public / crowded places.",
    "Never go alone to meet a buyer/seller always take someone with you.",
    "Trust your instincts—if something feels off, walk away from the deal.",
    "Check and inspect the product properly"
  ];
  @override
  Widget build(BuildContext context) {
    return CommonScreenTemplateWidget(
        title: "",
        leadingWidget: const CustomBackButtonWidget(),
        bottomWidget: Padding(
          padding: EdgeInsets.all(AppStyles.screenHorizontalPadding),
          child: CustomButtonWidget(
            title: "Done",
            onPressed: () {
              if (isVender ?? false) {
                AppRouter.pushAndRemoveUntil(const NavigationView());
              } else {
                AppRouter.pushReplacement( PaymentConfirmedView(
                  product: product ,
                ));
              }
            },
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
              left: AppStyles.screenHorizontalPadding,
              right: AppStyles.screenHorizontalPadding,
              bottom: !(isVender ?? false) ? 120.r : 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                Assets.confirmOrderIcon,
                width: 200.r,
              ),
              GenericTranslateWidget( 
                "Your order has been confirmed",
                style:
                    context.textStyle.displayMedium!.copyWith(fontSize: 18.sp),
              ),
              20.ph,
              if (!(isVender ?? false)) ...[
                Container(
                  padding: EdgeInsets.only(bottom: 10.r),
                  margin: EdgeInsets.only(top: 10.r),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: AppColors.borderColor))),
                  child: Row(
                    children: [
                      GenericTranslateWidget( 
                        "Product Price",
                        style: context.textStyle.displayMedium!
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      GenericTranslateWidget( 
                        "\$$productAmounts}",
                        style: context.textStyle.displayMedium!
                            .copyWith(fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10.r),
                  margin: EdgeInsets.only(top: 10.r),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: AppColors.borderColor))),
                  child: Row(
                    children: [
                      GenericTranslateWidget( 
                        "Application Fee",
                        style: context.textStyle.displayMedium!
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      GenericTranslateWidget( 
                        "\$$deliveryCharger",
                        style: context.textStyle.displayMedium!
                            .copyWith(fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
              ],
              if (isVender ?? false) ...[
                Container(
                  padding: EdgeInsets.only(bottom: 10.r),
                  margin: EdgeInsets.only(top: 10.r),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: AppColors.borderColor))),
                  child: Row(
                    children: [
                      GenericTranslateWidget( 
                        "Merchandise Subtotal",
                        style: context.textStyle.displayMedium!
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      GenericTranslateWidget( 
                        "\$$productAmounts",
                        style: context.textStyle.displayMedium!
                            .copyWith(fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10.r),
                  margin: EdgeInsets.only(top: 10.r),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: AppColors.borderColor))),
                  child: Row(
                    children: [
                      GenericTranslateWidget( 
                        "Shipping Fee Subtotal",
                        style: context.textStyle.displayMedium!
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      GenericTranslateWidget( 
                        "\$$deliveryCharger",
                        style: context.textStyle.displayMedium!
                            .copyWith(fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
               
                // Container(
                //   padding: EdgeInsets.only(bottom: 10.r),
                //   margin: EdgeInsets.only(top: 10.r),
                //   decoration: BoxDecoration(
                //       border: Border(
                //           bottom: BorderSide(color: AppColors.borderColor))),
                //   child: Row(
                //     children: [
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           GenericTranslateWidget( 
                //             "Fast Delivery",
                //             style: context.textStyle.displayMedium!
                //                 .copyWith(fontWeight: FontWeight.w700),
                //           ),
                //           Row(
                //             children: [
                //               Container(
                //                 padding: EdgeInsets.all(4.r),
                //                 decoration: const BoxDecoration(
                //                     color: Color(0xffFFFF00),
                //                     shape: BoxShape.circle),
                //                 child: SvgPicture.asset(Assets.deliveryVanIcon),
                //               ),
                //               GenericTranslateWidget( 
                //                 "Delivery in 26-43min",
                //                 style: context.textStyle.bodySmall,
                //               )
                //             ],
                //           )
                //         ],
                //       ),
                //       const Spacer(),
                //       GenericTranslateWidget( 
                //         "\$3.00",
                //         style: context.textStyle.displayMedium!
                //             .copyWith(fontWeight: FontWeight.w700),
                //       )
                //     ],
                //   ),
                // ),
              
              ],
              Container(
                  padding: EdgeInsets.only(bottom: 10.r),
                  margin: EdgeInsets.only(top: 10.r),
                  // decoration: BoxDecoration(
                  //     border: Border(
                  //         bottom: BorderSide(color: AppColors.borderColor))),
                  child: Row(
                    children: [
                      GenericTranslateWidget( 
                        "Total",
                        style: context.textStyle.displayMedium!
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      GenericTranslateWidget( 
                        "\$$totalAmount",
                        style: context.textStyle.displayMedium!
                            .copyWith(fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
              if (!(isVender ?? false)) ...[
                const Spacer(),
                Row(
                  children: [
                    GenericTranslateWidget( 
                      "Your safety matters to us!",
                      style: context.textStyle.displayMedium!
                          .copyWith(color: context.colors.primary),
                    ),
                  ],
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
              ]
            ],
          ),
        ));
  }
}
