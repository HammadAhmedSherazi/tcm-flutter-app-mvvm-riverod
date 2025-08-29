import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final int? maxline;
  final int? minLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatter;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool? readOnly;
  final WidgetRef ref;
  const CustomTextFieldWidget(
      {super.key,
      this.hintText,
      this.controller,
      this.maxline,
      this.minLines,
      this.keyboardType,
      this.inputFormatter,
      this.onChanged,
      this.validator,
      this.readOnly,
      required this.ref 
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxline ?? 1,
      minLines:  minLines ?? 1,
      keyboardType: keyboardType,
      inputFormatters: inputFormatter,
      validator: validator,
      
      onChanged: onChanged,
      readOnly: readOnly ?? false,
       onTapOutside: (c){
                            AppRouter.keyboardClose();
                          },
      decoration: InputDecoration(
          // maintainHintHeight: true,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.borderColor)),
          // isCollapsed: true,
          isDense: true,
          contentPadding:
              EdgeInsets.symmetric(vertical: 12.r, horizontal: 14.r),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.borderColor)),
          hintText: Helper.getCachedTranslation(ref: ref, text: hintText ?? ""),
          hintStyle: context.inputTheme.hintStyle!
              .copyWith(color: Colors.black.withValues(alpha: 0.5))),
    );
  }
}
