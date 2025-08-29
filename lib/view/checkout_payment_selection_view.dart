import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';
class CheckoutPaymentSelectionView extends StatefulWidget {
  final ProductDetailDataModel? productData;
  const CheckoutPaymentSelectionView({super.key, this.productData});

  @override
  State<CheckoutPaymentSelectionView> createState() =>
      _CheckoutPaymentSelectionViewState();
}

class _CheckoutPaymentSelectionViewState
    extends State<CheckoutPaymentSelectionView> {
  @override
  Widget build(BuildContext context) {
    return CommonScreenTemplateWidget(
        title: "Select Payment",
        leadingWidget: const CustomBackButtonWidget(),
        appBarHeight: 60.h,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppStyles.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CustomListWidget(
              //   iconPayment: Assets.cashWalletIcon,
              //   title: "Cash",
              //   onTap: () {},
              // ),
              // 12.ph,
              CustomListWidget(
                iconPayment: Assets.visa,
                title: "Visa",
                onTap: () {
                  // AppRouter.push(AddCardView(
                  //   onTap: () {
                  //     AppRouter.back();
                  //     AppRouter.pushReplacement(CheckoutView(
                  //       isDeliveryOptionSet: true,
                  //       isLocationSet: true,
                  //       isPaymentMethodSet: true,
                  //       product: widget.productData,
                  //     ));
                  //   },
                  // ));
                },
              ),
              12.ph,
              CustomListWidget(
                iconPayment: Assets.masterCard,
                title: "Master card",
                onTap: () {
                  // AppRouter.push(AddCardView(
                  //   onTap: () {
                  //     AppRouter.back();
                  //     AppRouter.pushReplacement(CheckoutView(
                  //       isDeliveryOptionSet: true,
                  //       isLocationSet: true,
                  //       isPaymentMethodSet: true,
                  //       product: widget.productData,
                  //     ));
                  //   },
                  // ));
                },
              ),
              12.ph,
              CustomListWidget(
                iconPayment: Assets.paypal,
                title: "PayPal",
                onTap: () {
                  // AppRouter.push(AddCardView(
                  //   onTap: () {
                  //     AppRouter.back();
                  //     AppRouter.pushReplacement(const CheckoutView(
                  //       isDeliveryOptionSet: true,
                  //       isLocationSet: true,
                  //       isPaymentMethodSet: true,
                  //     ));
                  //   },
                  // ));
                },
              )
            ],
          ),
        ));
  }
}
