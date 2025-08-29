import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';

class DeliverOptionSelectionWidget extends StatelessWidget {
  final bool isSelect;
  final String title;
  final String deliveryTime;
  final String price;
  final VoidCallback onTap;
  final bool isfinal;
  const DeliverOptionSelectionWidget(
      {super.key,
      required this.title,
      required this.deliveryTime,
      required this.isSelect,
      required this.price,
      this.isfinal = false,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 74.h,
        padding: isfinal
            ? EdgeInsets.symmetric(horizontal: 10.r, vertical: 8.r)
            : null,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: isfinal
                ? Border.all(color: AppColors.borderColor)
                : Border(
                    top: BorderSide(
                      color: AppColors.borderColor,
                    ),
                    right: BorderSide(
                      color: AppColors.borderColor,
                    ),
                    bottom: BorderSide(
                      color: AppColors.borderColor,
                    ))),
        child: isfinal
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GenericTranslateWidget( 
                        title,
                        style: context.textStyle.displayMedium,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(4.r),
                            decoration: BoxDecoration(
                                color: isSelect
                                    ? const Color(0xffFFFF00)
                                    : const Color(0xffDADADA),
                                shape: BoxShape.circle),
                            child: SvgPicture.asset(Assets.deliveryVanIcon),
                          ),
                          GenericTranslateWidget( 
                            deliveryTime,
                            style: context.textStyle.bodySmall,
                          )
                        ],
                      )
                    ],
                  ),
                  GenericTranslateWidget( 
                    "\$$price",
                    style: context.textStyle.bodyMedium!
                        .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  )
                ],
              )
            : Row(
                children: [
                  Container(
                    width: 38.w,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        gradient: isSelect ? AppColors.primaryGradinet : null,
                        color: !isSelect
                            ? AppColors.borderColor
                            : const Color(0xffDADADA),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            bottomLeft: Radius.circular(10.r))),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18.r,
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.r, vertical: 8.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GenericTranslateWidget( 
                              title,
                              style: context.textStyle.displayMedium,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4.r),
                                  decoration: BoxDecoration(
                                      color: isSelect
                                          ? const Color(0xffFFFF00)
                                          : const Color(0xffDADADA),
                                      shape: BoxShape.circle),
                                  child:
                                      SvgPicture.asset(Assets.deliveryVanIcon),
                                ),
                                GenericTranslateWidget( 
                                  deliveryTime,
                                  style: context.textStyle.bodySmall,
                                )
                              ],
                            )
                          ],
                        ),
                        GenericTranslateWidget( 
                          "\$$price",
                          style: context.textStyle.bodyMedium!.copyWith(
                              fontSize: 16.sp, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ))
                ],
              ),
      ),
    );
  }
}
