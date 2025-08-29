import '../export_all.dart';

class GenericTranslateWidget extends ConsumerWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDirection? textDirection;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final bool? softWrap;

  const GenericTranslateWidget(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.textDirection,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.locale,
    this.strutStyle,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = ref.watch(languageChangeNotifierProvider).currentLanguage.code;
    final translationState = ref.watch(translationNotifierProvider(Tuple2(text, languageCode)));
  final adjustedStyle = (style ?? DefaultTextStyle.of(context).style).copyWith(
   
      fontSize: (languageCode == 'ar')
          ? (style?.fontSize ?? 16.sp) * 0.9 // Adjust as needed
          : style?.fontSize,
    );
    return translationState.when(
      data: (translatedText) => Text(
        translatedText,
        style: adjustedStyle,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        textDirection: textDirection,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        locale: locale,
        strutStyle: strutStyle,
        softWrap: softWrap,
      ),
      loading: () => Text(
        text,
        style: adjustedStyle,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        textDirection: textDirection,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        locale: locale,
        strutStyle: strutStyle,
        softWrap: softWrap,
      ),
      error: (err, _) => Text(
        '------',
        style: adjustedStyle,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        textDirection: textDirection,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        locale: locale,
        strutStyle: strutStyle,
        softWrap: softWrap,
      ),
    );
  }
}
