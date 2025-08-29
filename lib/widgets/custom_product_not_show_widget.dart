import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';
class CustomProductNoShowMessageWidget extends StatelessWidget {
  final String lottiePath;
  final double? width;
  final String? text;
  const CustomProductNoShowMessageWidget(
      {super.key, required this.lottiePath, this.width, this.text});

  @override
  Widget build(BuildContext context) {
    return text == null
        ? Center(
            child:
                Lottie.asset(lottiePath, repeat: true, width: width ?? 80.r, fit: BoxFit.fill),
          )
        : SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(lottiePath,
                    repeat: true, width: width ?? 80.r, fit: BoxFit.fill),
                5.ph,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 100.r),
                  child: GenericTranslateWidget( 
                    text!,
                    style: context.textStyle.bodyMedium!.copyWith(
                      fontSize: 16.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          );
  }
}
