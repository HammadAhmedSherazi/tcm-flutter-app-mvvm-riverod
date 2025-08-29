import '../export_all.dart';


final translationServiceProvider = Provider((ref) => TranslationService());

final translationNotifierProvider = StateNotifierProvider.family<
    TranslationNotifier, AsyncValue<String>, Tuple2<String, String>>((ref, args) {
  final service = ref.watch(translationServiceProvider);
  final text = args.item1;
  final langCode = args.item2;
  return TranslationNotifier(service, text, langCode);
});

class TranslationNotifier extends StateNotifier<AsyncValue<String>> {
  final TranslationService _service;
  final String _text;
  final String _toLang;

  TranslationNotifier(this._service, this._text, this._toLang) : super(const AsyncValue.loading()) {
    _translate(); // Automatically trigger on init
  }

  Future<void> _translate() async {
    final result = await _service.translate(
        text: _text,
        toLanguageCode: _toLang, // Replace with configurable param if needed
      );
      state = AsyncValue.
      data(result);
  }
}
