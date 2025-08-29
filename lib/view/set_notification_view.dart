import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';

class SetNotificationView extends StatelessWidget {
  const SetNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.scaffoldColor1,
      bottomSheet: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: AppStyles.screenHorizontalPadding,
            vertical: AppStyles.screenHorizontalPadding),
        child: Consumer(builder: (context, ref, child) {
          return CustomButtonWidget(
              title: "Done",
              onPressed: () {
                ref.read(bottomIndexProvider.notifier).setIndex(0);
                AppRouter.pushAndRemoveUntil(const NavigationView());
              });
        }),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppStyles.screenHorizontalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Assets.notificationSetIcon,
                width: 76.r,
              ),
              12.ph,
              GenericTranslateWidget( 
                "All Set For Notification",
                style: context.textStyle.displayLarge!
                    .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),
              Row(
                children: [
                  Expanded(
                      child: GenericTranslateWidget( 
                    "Your product radar is ON! As soon as it’s available, you’ll be the first to know.",
                    textAlign: TextAlign.center,
                    style:
                        context.textStyle.bodyMedium!.copyWith(fontSize: 16.sp),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
