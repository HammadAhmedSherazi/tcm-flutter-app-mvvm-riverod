


import 'package:tcm/utils/app_extensions.dart';

import '../../export_all.dart';

class CustomProfileScreenWidget extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Color? color;

  const CustomProfileScreenWidget({
    super.key,
    required this.icon,
    required this.title,
    this.width,
    this.height,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.h,
        margin: const EdgeInsets.only(bottom: 12),
        padding: title == "Notification"
            ? EdgeInsets.only(left: 12.r)
            : EdgeInsets.symmetric(horizontal: 12.r),
        decoration: BoxDecoration(
          color: AppColors.scaffoldColor1,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
              width: 1, color: AppColors.lightIconColor.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 24.r,
              height: 24.r,
            ),
            12.pw,
            Expanded(
              child: GenericTranslateWidget( 
                title,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: color ?? AppColors.lightIconColor),
              ),
            ),
            title == "Notification"
                ? Consumer(builder: (context, ref, child) {
                    final isCheck = ref.watch(authRepoProvider).isNotification;
                    ApiResponse apiResponse =
                        ref.watch(authRepoProvider).updateApiResponse;

                    return Switch.adaptive(
                      activeColor: context.colors.primary,
                      value: isCheck,
                      onChanged: (s) {
                        if (apiResponse.status != Status.loading) {
                          ref
                              .read(authRepoProvider)
                              .updateProfile({"is_notification": s}, null);
                        }
                        ref.read(authRepoProvider).toggleNotification(s);
                      },
                    );
                  })
                : Icon(
                    Icons.arrow_forward_ios,
                    color: color ?? AppColors.lightIconColor,
                    size: 16.r,
                  ),
          ],
        ),
      ),
    );
  }
}
