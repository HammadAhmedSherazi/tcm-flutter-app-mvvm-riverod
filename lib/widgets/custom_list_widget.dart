import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';

class CustomListWidget extends StatelessWidget {
  const CustomListWidget({
    super.key,
    required this.iconPayment,
    required this.title,
    this.width,
    this.height,
    this.color,
    this.onTap,
    this.trailing,
    this.showLeading = true,
    this.leadingWidget,
    this.subtitle
  });

  final String? iconPayment;
  final String title;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Color? color;
  final Widget? trailing;
  final Widget? subtitle;
  final bool? showLeading;
  final Widget ? leadingWidget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              width: 1, color: AppColors.lightIconColor.withValues(alpha: 0.1)),
        ),
        child: ListTile(
          leading: leadingWidget ?? (showLeading!? Container(
            height: 50.h,
            width: 50.w,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor1,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(8.r),
            child: iconPayment == null
                ? const Icon(
                    Icons.add_card,
                    color: Colors.black,
                  )
                : iconPayment == "Bank" ? const Icon(
                    Icons.account_balance,
                    color: Colors.black,
                  ): SvgPicture.asset(iconPayment!),
          ) : null),
          title: GenericTranslateWidget( title,
              
              style: context.textStyle.displayMedium!.copyWith(
                  fontSize: 16.sp,
                  color: AppColors.lightIconColor,
                  fontWeight: FontWeight.w600)),
          subtitle: subtitle,
          subtitleTextStyle: context.textStyle.bodyMedium!,
          trailing: trailing,
        ),
      ),
    );
  }
}
