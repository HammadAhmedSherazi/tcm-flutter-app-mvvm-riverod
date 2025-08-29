import '../export_all.dart';

class AppStyles {
  static BoxDecoration customBackgroundDecoration = BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
        const Color(0xff1994E0)
            .withValues(alpha: 0.50), // rgba(140, 149, 29, 0.21)

        const Color(0xff1994E0)
            .withValues(alpha: 0.50), // rgba(255, 36, 36, 0.10)

        // rgba(51, 18, 255, 0.30)
      ],
          stops: const [
        0.0318,
        1.0
      ] // Gradient stops

          ));
  
  static BoxDecoration appBarStyle = const BoxDecoration(
      color: AppColors.secondaryColor,
      border: Border(
        bottom: BorderSide(
          width: 1,
          color: Color.fromRGBO(0, 0, 0, 0.10)
        )
      )
    
  );

  static double screenHorizontalPadding = 20.r;
  static final ThemeData datePickerTheme = ThemeData(
                            colorScheme: const ColorScheme.light(
                              primary: AppColors.primaryColor
                                  , // Action button & selection color
                              onPrimary:
                                  Colors.white, // Text color for primary color
                              secondary:
                                  AppColors.primaryColor, // Selection color
                              onSecondary: Colors
                                  .white, // Text color for selection color
                            ),
                            buttonTheme: const ButtonThemeData(
                              textTheme: ButtonTextTheme
                                  .primary, // Ensure button text is white
                            ),
                            // Customize the date picker theme
                            datePickerTheme: DatePickerThemeData(
                              backgroundColor: Colors.white,
                              // Background color
                              headerBackgroundColor:
                                  Colors.white, // Header background color
                              headerHeadlineStyle: const TextStyle(
                                  color: Colors.black), // Title color
                              // Day of week text color
                              dayStyle: const TextStyle(
                                  color: Colors.black), // Date text color
                              // Selected day text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Rounded corners for the dialog
                              ),
                            ),
                            appBarTheme: const AppBarTheme(
                              titleTextStyle: TextStyle(
                                  color: Colors.black), // AppBar title color
                            ),
                          );

static final ThemeData timePickerStyle = ThemeData(
                              colorScheme: const ColorScheme.light(
                                primary: AppColors.primaryColor
                                    , // Action button & selection color
                                onPrimary: Colors
                                    .white, // Text color for primary color
                                secondary:
                                    AppColors.primaryColor, // Selection color
                                onSecondary: Colors
                                    .white, // Text color for selection color
                              ),
                              buttonTheme: const ButtonThemeData(
                                textTheme: ButtonTextTheme
                                    .primary, // Ensure button text is white
                              ),
                              timePickerTheme: TimePickerThemeData(
                                dialHandColor:  AppColors.primaryColor
                                    , // Dial hand color (selection indicator)
                                dialTextColor: Colors
                                    .black, // Time text color (hour/minute)
                                hourMinuteTextColor:
                                    Colors.black, // Hour and minute text color
                                backgroundColor:
                                    Colors.white, // Background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      12), // Optional: round the corners
                                ),
                              ));
                       
}
