import '../export_all.dart';

class AppColors {
  static const Color scaffoldColor = Colors.white;
  static const Color primaryColor = Color(0xff1E9CD7);
  static const Color bagdeColor = Color(0xffF26327);
  static const Color secondaryColor = Color(0xffF8F8F8);
  static const Color secondaryColor1 = Color(0xffF6F6F6);
  static const Color scaffoldColor1 = Color(0xffF9F9F9);
  static const Color greyColor = Color(0xffEFEDEC);
  static const Color blueColor = Color(0xff168FD6);
  static const Color greenColor50 = Color(0xff4CAF50);
  static const Color greyColor50 = Color(0xffD9D9D9);
  static const Color greyColor70 = Color(0xff747474);

  static const Color unselectTab = Color(0xFF64748B);
  static const Color lightIconColor = Colors.black;
  static const Color darkIconColor = Colors.white;

  static const Color greenColor = Color(0xff008000);

  static const Color deleteButtonColor = Color(0xffFF3D00);

  static final Color borderColor = Colors.black.withValues(alpha: 0.10);
  static const Color secondaryTextColor = Color(0xFF64748B);
  static const Color reactionIconColor = Color(0xffEFEFEF);
  static const Gradient primaryGradinet = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [
      0.0187, // 1.87% => 0.0187 in the range [0.0, 1.0]
      0.3052, // 30.52% => 0.3052
      0.7799, // 77.99% => 0.7799
      0.9886, // 98.86% => 0.9886
    ],
    colors: [
      Color(0xFF006CD4), // #006CD4
      Color(0xFF0675D5), // #0675D5
      Color(0xFF168FD6), // #168FD6
      Color(0xFF1E9CD7), // #1E9CD7
    ],
  );
  static final Paint gradientPaint = Paint()
    ..shader = AppColors.primaryGradinet.createShader(
      const Rect.fromLTWH(
          400.0, 100.0, 0.0, 0.0), // Adjust size based on the text
    );
}
