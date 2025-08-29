import 'package:tcm/utils/app_extensions.dart';
import '../../export_all.dart';


class MoneyDepositView extends StatelessWidget {
  const MoneyDepositView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScreenTemplateWidget(
      title: "Money Deposit",
      appBarHeight: 60.h,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: AppStyles.screenHorizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            250.ph,
            Image.asset(
              Assets.doneIcon,
              width: 70.r,
            ),
            Center(
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    colors: [
                      Color(0xFF006CD4), // #006CD4
                      Color(0xFF0675D5), // #0675D5
                      Color(0xFF168FD6), // #168FD6
                      Color(0xFF1E9CD7), // #1E9
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(
                      Rect.fromLTRB(0, 0, bounds.width, bounds.height));
                },
                child: GenericTranslateWidget( 
                  "\$100.00", // Dollar sign with amount
                  style: context.textStyle.displayMedium!.copyWith(
                    fontSize: 38.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Center(
              child: GenericTranslateWidget( 
                "successfully deposited", // Dollar sign with amount
                style: context.textStyle.displayMedium!.copyWith(
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.lightIconColor,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CustomButtonWidget(
                title: "Go Back",
                onPressed: () {
                  AppRouter.back();
                  AppRouter.back();
                  AppRouter.back();
                  AppRouter.back();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
