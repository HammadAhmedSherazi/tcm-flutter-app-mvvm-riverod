

import 'package:translator/translator.dart';

class TranslationService {
  // Private constructor
  TranslationService._internal();

  // Static instance
  static final TranslationService _instance = TranslationService._internal();

  // Factory constructor to return the same instance
  factory TranslationService() => _instance;

  final GoogleTranslator _translator = GoogleTranslator();

  Future<String> translate({
    required String text,
    required String toLanguageCode,
  }) async {
    try {
      final translation = await _translator.translate(text, to: toLanguageCode);
      // return _convertDigits(translation.text, toLanguageCode);
      return translation.text;
    } catch (e) {
      return text; // Fallback to original if translation fails
    }
  }
  // String _convertDigits(String input, String lang) {
  //   final digitMaps = {
  //     'ar': ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'], // Arabic
  //     // 'zh-cn': ['〇', '一', '二', '三', '四', '五', '六', '七', '八', '九'],  // Chinese full-width
  //     // Add more as needed
  //   };

  //   final digits = digitMaps[lang];
  //   if (digits == null) return input;

  //   return input.replaceAllMapped(RegExp(r'\d'), (match) {
  //     return digits[int.parse(match.group(0)!)];
  //   });
  // }
}
