import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';


class CustomButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final double? height, width;
  final Color? color;
  final Color? textColor;
  final Widget? child;
  final bool isLoad;
  final BoxBorder? border;
  final bool? isElevated;
  final bool? isEnabled;

  const CustomButtonWidget(
      {super.key,
      required this.title,
      required this.onPressed,
      this.height,
      this.isElevated = false,
      this.isEnabled = true,
      this.color,
      this.textColor,
      this.child,
      this.isLoad = false,
      this.border,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        border: border,
          gradient:  color == null ? AppColors.primaryGradinet : null,
          borderRadius: BorderRadius.circular(32.r)),
      height: height ?? 54.h,
      child: ElevatedButton(
          style: ButtonStyle(
            elevation: isElevated!? null : const WidgetStatePropertyAll(0.0),
            alignment: Alignment.center,
            backgroundColor:
                WidgetStatePropertyAll(color ?? Colors.transparent),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.r))),
          ),
          onPressed: !isLoad ? onPressed : () {},
          child: !isLoad
              ? child ??
                  (!isLoad
                      ? GenericTranslateWidget( 
                          title,
                          style: context.textStyle.displayMedium!.copyWith(
                              color: textColor ?? Colors.white,
                              fontSize: 16.sp),
                        )
                      : CircularProgressIndicator.adaptive(
                          valueColor:
                              AlwaysStoppedAnimation(textColor ?? Colors.white),
                        )) :
                  CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation(textColor ?? Colors.white),
                )),
    );
  }
}

class CustomOutlineButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double? height, width;
  final Color? color;
  final Color? textColor;
  final Widget? child;
  final Color? outlineColor;
  final bool isLoad;

  const CustomOutlineButtonWidget(
      {super.key,
      required this.title,
      required this.onPressed,
      this.height,
      this.color,
      this.textColor,
      this.child,
      this.outlineColor,
      this.isLoad = false,
      this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 51.h,
      child: OutlinedButton(
          style: ButtonStyle(
              elevation: const WidgetStatePropertyAll(0.0),
              alignment: Alignment.center,
              side: WidgetStatePropertyAll(
                  BorderSide(color: outlineColor ?? context.colors.secondary)),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.r))),
              backgroundColor:
                  WidgetStatePropertyAll(color ?? Colors.transparent)),
          onPressed: !isLoad ? onPressed : null,
          child: !isLoad
              ? child ??
                  (!isLoad
                      ? GenericTranslateWidget( 
                          title,
                          style: context.textStyle.bodyMedium!.copyWith(
                              color: textColor ?? Colors.white,
                              fontSize: 16.sp),
                        )
                      : CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation(
                              outlineColor ?? Colors.white),
                        ))
              : CircularProgressIndicator.adaptive(
                  valueColor:
                      AlwaysStoppedAnimation(outlineColor ?? Colors.white),
                )),
    );
  }
}
