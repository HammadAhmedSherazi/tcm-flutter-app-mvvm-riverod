
import '../export_all.dart';



class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(SharedPreferenceManager.sharedInstance.isDarkTheme() ? AppTheme.darkTheme :  AppTheme.lightTheme); // Set default theme to darkTheme

  void toggleTheme() {
    state = state.brightness == Brightness.dark ? AppTheme.lightTheme : AppTheme.darkTheme;
  }
  // void themeSetLight() {
  //   state = lightTheme;
  // }
}

final themeProvider = StateNotifierProvider.autoDispose<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});


