import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';
class ProductAdLiveNowView extends StatelessWidget {
  const ProductAdLiveNowView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          AppRouter.pushAndRemoveUntil(const NavigationView());
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.scaffoldColor1,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: GenericTranslateWidget( 
            "Your Ad",
            style: context.textStyle.displayMedium!.copyWith(fontSize: 18.sp),
          ),
        ),
        bottomSheet: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppStyles.screenHorizontalPadding,
              vertical: AppStyles.screenHorizontalPadding),
          child: CustomButtonWidget(
              title: "Preview Ad",
              onPressed: () {
                AppRouter.pushReplacement(const AdPreviewView());
              }),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Assets.doneIcon,
                width: 70.r,
              ),
              20.ph,
              GenericTranslateWidget( 
                "Your Ad is now Live!",
                style:
                    context.textStyle.displayLarge!.copyWith(fontSize: 22.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
