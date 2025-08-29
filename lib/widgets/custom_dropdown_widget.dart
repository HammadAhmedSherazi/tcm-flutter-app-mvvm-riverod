import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';

class CustomDropDown<T> extends StatelessWidget {
  const CustomDropDown({
    super.key,
    this.options = const [],
    this.value,
    this.expandIcon,
    this.onChanged,
    this.isDense = true,
    this.filled = true,
    this.fillColor,
    this.dropdownColor,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.disabledBorder,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.contentPadding,
    this.placeholderText,
    this.placeholderStyle,
    this.expandIconColor,
    this.error,
  });

  final List<CustomDropDownOption<T>> options;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final Widget? expandIcon;
  final bool? isDense;
  final bool? filled;
  final Color? fillColor;
  final Color? dropdownColor;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final Widget? prefixIcon;
  final BoxConstraints? prefixIconConstraints;
  final InputBorder? disabledBorder;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final EdgeInsetsGeometry? contentPadding;
  final String? placeholderText;
  final TextStyle? placeholderStyle;
  final Color? expandIconColor;
  final Widget? error;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: false,
      dropdownColor: dropdownColor ?? Colors.white,
      borderRadius: BorderRadius.circular(16),
      icon:
          expandIcon ??
          Icon(
            Icons.expand_more,
            color: expandIconColor ?? AppColors.borderColor,
          ),
      hint: GenericTranslateWidget( 
        placeholderText ?? 'Select',
        style:
            placeholderStyle ??
           context.inputTheme.hintStyle!
              .copyWith(color: Colors.black.withValues(alpha: 0.5)),
      ),
      items:
          options.map((option) {
            return DropdownMenuItem(
              value: option.value,
              child: GenericTranslateWidget( 
                option.displayOption,
                style: context.inputTheme.hintStyle
             ,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
      decoration: InputDecoration(
        contentPadding: contentPadding,
        filled: filled,
        fillColor: fillColor ?? context.inputTheme.fillColor,
        suffixIcon: suffixIcon,
        suffixIconConstraints: suffixIconConstraints,
        prefixIcon: prefixIcon,
        prefixIconConstraints: prefixIconConstraints,
        disabledBorder:
            disabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.borderColor)),
        enabledBorder:
            enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.borderColor)),
        focusedBorder:
            focusedBorder ??
           OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.borderColor)),
        errorBorder:
            errorBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.borderColor)),
        focusedErrorBorder:
            focusedErrorBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.borderColor)),
        isDense: isDense,
        error: error,
      ),
      style: context.inputTheme.hintStyle
             ,
      value: value,
      onChanged: onChanged,
    );
  }
}

class CustomDropDownOption<T> {
  final T value;
  final String displayOption;

  const CustomDropDownOption({
    required this.value,
    required this.displayOption,
  });
}
