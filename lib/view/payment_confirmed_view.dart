import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';

class PaymentConfirmedView extends StatelessWidget {
  final ProductDetailDataModel? product;
  const PaymentConfirmedView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return CommonScreenTemplateWidget(
        title: "Checkout",
        leadingWidget: const CustomBackButtonWidget(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppStyles.screenHorizontalPadding),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        UserProfileWidget(
                            radius: 15.r,
                            imageUrl: product?.productOwner?.picture ?? ""),
                        10.pw,
                        GenericTranslateWidget( 
                          "${product?.productOwner?.fname} ${product?.productOwner?.lname}",
                          style: context.textStyle.displayMedium,
                        )
                      ],
                    ),
                    20.ph,
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: DisplayNetworkImage(
                            imageUrl: product?.productImage ?? "",
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
                                product?.productName ??
                                    "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: context.textStyle.displayMedium!
                                    .copyWith(fontSize: 16.sp),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GenericTranslateWidget( 
                                    "\$${product?.productPrice ?? 12.00}",
                                    style: context.textStyle.displayLarge!
                                        .copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    20.ph,
                    Row(
                      children: [
                        Expanded(
                          child: GenericTranslateWidget( 
                            "Payment Method",
                            style: context.textStyle.displayMedium!
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        
                      ],
                    ),
                    12.ph,
                    Consumer(
                      builder: (_, WidgetRef ref, __) {
                        final provider = ref.watch(cardProvider);
                        final card = provider.selectCard;
                        return Container(
                          height: 44.h,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 12.r),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: AppColors.borderColor)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: GenericTranslateWidget( 
                                  "${Helper.capitalize(card!.brand)} ****${card.last4}",
                                  style: context.textStyle.displayMedium!,
                                ),
                              ),
                              SvgPicture.asset(Helper.setCardIcon(card.brand))
                            ],
                          ),
                        );
                      },
                    ),
                    30.ph,
                    const TitleHeadingWidget(title: "Details"),
                  ProductDetailTitleWidget(
                      description: Helper.setCheckInFormat(
                                                    Helper.formatDateTime(DateTime.now())),
                      title: "Purchase Date",
                    ),
                     ProductDetailTitleWidget(
                      description: Helper.setCheckInFormat(
                                                    product!.checkIn!),
                      title: "Check-In",
                    ),
                    ProductDetailTitleWidget(
                      description: Helper.setCheckInFormat(
                                                    product!.checkOut!),
                      title: "Check-Out",
                    )
                  ],
                ),
              ),
            )),
            Container(
              padding: EdgeInsets.all(AppStyles.screenHorizontalPadding),
              decoration: BoxDecoration(
                  color: AppColors.secondaryColor1,
                  border:
                      Border(top: BorderSide(color: AppColors.borderColor))),
              child: Column(
                children: [
                  Row(
                    children: [
                      GenericTranslateWidget( 
                        "Payment Confirmed",
                        style: context.textStyle.displayMedium!.copyWith(
                            fontSize: 20.sp, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      GenericTranslateWidget( 
                        "\$${product!.productPrice! + product!.applicationFee!}",
                        style: context.textStyle.displayMedium!.copyWith(
                            fontSize: 20.sp, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  15.ph,
                  Row(
                    children: [
                      Expanded(
                          child: CustomButtonWidget(
                        title: "Go Back",
                        onPressed: () {
                          AppRouter.pushAndRemoveUntil(const NavigationView());
                        },
                        border: Border.all(color: AppColors.borderColor),
                        textColor: Colors.black,
                        color: const Color(0xffEFEDEC),
                      )),
                      9.pw,
                      Expanded(
                          child: CustomButtonWidget(
                              title: "Chat",
                              onPressed: () {
                                AppRouter.push(
                                  ChattingView(
                                    user: product?.productOwner,
                                    chatId: product?.chatId,
                                    ad: product,
                                    isPaid: true,
                                  ),
                                );
                               
                              }))
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
