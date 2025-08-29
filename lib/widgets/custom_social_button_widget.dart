import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';
class CustomSocialButtonWidget extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;
  final bool? isLoad;
  const CustomSocialButtonWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap,
      this.isLoad = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 3),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: context.colors.secondary,
            borderRadius: BorderRadius.circular(500.r)),
        child: isLoad!
            ? const CircularProgressIndicator.adaptive()
            : Row(
                children: [
                  Container(
                    width: context.screenwidth * 0.22,
                    alignment: Alignment.centerLeft,
                    child: SvgPicture.asset(
                      icon,
                    ),
                  ),
                  // const Spacer(),
                  GenericTranslateWidget( 
                    title,
                    style: context.textStyle.labelMedium!
                        .copyWith(fontSize: 16.sp),
                  ),
                  // 20.pw,
                  const Spacer(),
                ],
              ),
      ),
    );
  }
}
