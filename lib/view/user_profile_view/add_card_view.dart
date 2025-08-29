
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:tcm/utils/app_extensions.dart';
import '../../export_all.dart';

class AddCardView extends StatefulWidget {
  // final VoidCallback? onTap;
  final bool isCheckOut;
  const AddCardView({super.key, required this.isCheckOut});

  @override
  State<AddCardView> createState() => _AddCardViewState();
}

class _AddCardViewState extends State<AddCardView> {
  final CardFormEditController cardEditController = CardFormEditController();

  @override
  Widget build(BuildContext context) {
    return CommonScreenTemplateWidget(
      title: "Add Card",
      leadingWidget: const CustomBackButtonWidget(),
      appBarHeight: 60.h,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: AppStyles.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   children: [
            //     Container(
            //       height: 50.h,
            //       width: 50.w,
            //       decoration: BoxDecoration(
            //         color: AppColors.secondaryColor1,
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       padding: EdgeInsets.all(8.r),
            //       child: SvgPicture.asset(Assets.masterCard),
            //     ),
            //     8.pw,
            //     GenericTranslateWidget( "Master Card",
            //         style: context.textStyle.displayMedium!.copyWith(
            //             fontSize: 16.sp,
            //             color: AppColors.lightIconColor,
            //             fontWeight: FontWeight.w600)),
            //   ],
            // ),
            // 16.ph,
            // GenericTranslateWidget( "Card Number",
            //     style: context.textStyle.displayMedium!.copyWith(
            //         fontSize: 16.sp,
            //         color: AppColors.lightIconColor,
            //         fontWeight: FontWeight.w300)),
            // const TextFieldUnderGround(
            //   hintText: "0000 0000 0000 ",
            //   keyboardType: TextInputType.number,
            // ),
            // 24.ph,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     // Expiry Field
            //     Expanded(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           GenericTranslateWidget( 
            //             "Expiry",
            //             style: context.textStyle.displayMedium!.copyWith(
            //               fontSize: 16.sp,
            //               color: AppColors.lightIconColor,
            //               fontWeight: FontWeight.w300,
            //             ),
            //           ),
            //           8.ph, // Space between label and field
            //           const TextFieldUnderGround(
            //             hintText: "MM/YY",
            //             keyboardType: TextInputType.number,
            //           ),
            //         ],
            //       ),
            //     ),

            //     16.pw, // Space between fields

            //     // CVV Field
            //     Expanded(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           GenericTranslateWidget( 
            //             "CVV",
            //             style: context.textStyle.displayMedium!.copyWith(
            //               fontSize: 16.sp,
            //               color: AppColors.lightIconColor,
            //               fontWeight: FontWeight.w300,
            //             ),
            //           ),
            //           8.ph, // Space between label and field
            //           const TextFieldUnderGround(
            //             hintText: "MM/YY",
            //             keyboardType: TextInputType.number,
            //           ),
            //         ],
            //       ),
            //     ),

            //     16.pw, // Space between fields

            //     // Postcode Field
            //     Expanded(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           GenericTranslateWidget( 
            //             "Postcode",
            //             style: context.textStyle.displayMedium!.copyWith(
            //               fontSize: 16.sp,
            //               color: AppColors.lightIconColor,
            //               fontWeight: FontWeight.w300,
            //             ),
            //           ),
            //           8.ph, // Space between label and field
            //           const TextFieldUnderGround(
            //             hintText: "MM/YY",
            //             keyboardType: TextInputType.number,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            Theme(
              data: ThemeData(
                inputDecorationTheme: const InputDecorationTheme(
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              child: CardFormField(
                controller: cardEditController,
                style: CardFormStyle(
                  placeholderColor: Colors.grey,
                  textColor: Colors.black,
                  borderColor: AppColors.borderColor,
                  borderRadius: 4,
                  borderWidth: 1,
                  cursorColor: context.colors.primary,
                  backgroundColor: Platform.isIOS ?Colors.black : Colors.white,
                ),
              ),
            ),
            // CardFormField(
            //   controller: cardEditController,
            //   // enablePostalCode: false,

            //   style: CardFormStyle(

            //       placeholderColor: Colors.grey,
            //       textColor: Colors.black,
            //       borderColor: AppColors.borderColor,
            //       borderRadius: 4,
            //       borderWidth: 1,
            //       cursorColor: context.colors.primary,
            //       backgroundColor: Colors.white),
            // ),

            const Spacer(),
            if (widget.isCheckOut)
              Row(
                children: [
                  GenericTranslateWidget( 
                    "Save Card",
                    style: context.textStyle.displayMedium!
                        .copyWith(fontSize: 18.sp),
                  ),
                  const Spacer(),
                  Consumer(
                    builder: (_, WidgetRef ref, __) {
                      final isCheck = ref.watch(cardProvider).saveCard;
                      return GestureDetector(
                        onTap: () {
                          ref.read(cardProvider).checkSaveCard();
                        },
                        child: Container(
                          width: 22.r,
                          height: 22.r,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient:
                                  isCheck ? AppColors.primaryGradinet : null,
                              border: !isCheck
                                  ? Border.all(color: Colors.black)
                                  : null),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 17.r,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: AppStyles.screenHorizontalPadding),
              child: Consumer(
                builder: (_, WidgetRef ref, __) {
                  final isLoad =
                      ref.watch(cardProvider).addCardApiResponse.status ==
                          Status.loading;
                  return CustomButtonWidget(
                      title: "Add Card",
                      isLoad: isLoad,
                      onPressed: () {
                        ref.read(cardProvider).addCard(widget.isCheckOut);
                      });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class TextFieldUnderGround extends StatelessWidget {
//   const TextFieldUnderGround(
//       {super.key,
//       this.keyboardType,
//       this.validator,
//       this.hintText,
//       this.text,
//       this.title,
//       this.hasIcon,
//       this.labelText,
//       this.controller});

//   final String? hintText;
//   final String? text;
//   final String? title;
//   final bool? alignLabelWithHint;
//   final bool? hasIcon;
//   final String? labelText;
//   final TextInputType? keyboardType;
//   final String? Function(String?)? validator;
//   final TextEditingController? controller;

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       textAlign: TextAlign.left,
//       validator: validator,
//       decoration: InputDecoration(
//         labelText: labelText,
//         labelStyle: ,
//         alignLabelWithHint: alignLabelWithHint ,

//         contentPadding:
//             const EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
//         fillColor: Colors.transparent,
//         hintText: hintText ?? "Enter",
//         suffixIcon: title == "Password"
//             ? GenericTranslateWidget( 
//                 "Change",
//                 style: context.textStyle.displayMedium?.copyWith(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w500,
//                   color: AppColors.primaryColor,
//                   decoration: TextDecoration.underline,
//                 ),
//               )
//             : (hasIcon == true
//                 ? Container(
//                     width: 10.r,
//                     height: 10.r,
//                     padding: EdgeInsets.all(16.r),
//                     child: SvgPicture.asset(Assets.editProfile),
//                   )
//                 : null),
//         // Display icon if hasIcon is true
//         hintStyle: context.textStyle.displayMedium?.copyWith(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             color: AppColors.greyColor70.withValues(alpha: 0.4)),

//         enabledBorder: UnderlineInputBorder(
//           borderSide: BorderSide(
//               color: AppColors.lightIconColor.withValues(alpha: 0.05)),
//         ),
//         focusedBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue, width: 2.0),
//         ),
//         errorBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.red, width: 2.0),
//         ),
//       ),
//     );
//   }
// }
