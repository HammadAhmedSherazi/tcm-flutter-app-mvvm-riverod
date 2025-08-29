  import '../export_all.dart';

  class LanguageChangeNotifier extends ChangeNotifier {
  final List<LanguageDataModel> _languages = const [
    LanguageDataModel("English", "en"),
    LanguageDataModel("Spanish", "es"),
    LanguageDataModel("French", "fr"),
    LanguageDataModel("Chinese", "zh-cn"),
    LanguageDataModel("Arabic", "ar"),
  ];

  int _currentIndex = 0;

  LanguageChangeNotifier() {
    _loadSavedLanguage();
  }

  List<LanguageDataModel> get languages => _languages;

  LanguageDataModel get currentLanguage => _languages[_currentIndex];

  int get currentIndex => _currentIndex;

  void _loadSavedLanguage() async {
    final savedIndex = SharedPreferenceManager.sharedInstance.getSavedLanguageIndex();
    if (savedIndex >= 0 && savedIndex < _languages.length) {
      _currentIndex = savedIndex;
      notifyListeners();
    }
  }

  void setLanguageIndex(int index) {
    if (index >= 0 && index < _languages.length) {
      final instance = SharedPreferenceManager.sharedInstance;
      _currentIndex = index;
      instance.savedLanguageIndex(index);
      instance.storeLangCode(_languages[index].code);
      notifyListeners();

      // Delay navigation slightly to allow rebuild
      Future.delayed(const Duration(milliseconds: 100), () {
        if(instance.getToken() != null){
          AppRouter.pushAndRemoveUntil(const NavigationView());
        }
        else{
          AppRouter.back();
        }
        
      });
    }
  }
}

  final languageChangeNotifierProvider =
    ChangeNotifierProvider<LanguageChangeNotifier>((ref) {
  return LanguageChangeNotifier();
});