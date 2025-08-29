

import 'package:intl/intl.dart';

import '../export_all.dart';

extension Spacing on num {
  SizedBox get ph => SizedBox(height: toDouble().h);

  SizedBox get pw => SizedBox(width: toDouble().w);
}

extension TimeConversion on String {
  String convertTo12HourFormat() {
    // Split the time string into hours and minutes
    List<String> parts = split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    // Determine AM or PM
    String period = hours >= 12 ? 'PM' : 'AM';

    // Convert hours to 12-hour format
    hours = hours % 12;
    if (hours == 0) hours = 12; // 12 AM/PM should be represented as 12, not 0

    // Return the formatted time
    return '$hours:${minutes.toString().padLeft(2, '0')} $period';
  }
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => theme.colorScheme;

  TextTheme get textStyle => theme.textTheme;

  InputDecorationTheme get inputTheme => theme.inputDecorationTheme;

  BottomNavigationBarThemeData get bottomAppStyle =>
      theme.bottomNavigationBarTheme;

  double get screenwidth => MediaQuery.of(this).size.width;
  double get screenheight => MediaQuery.of(this).size.height;
}

String maskEmail(String email) {
  // Split the email into local and domain parts
  final parts = email.split('@');
  if (parts.length != 2) {
    // Invalid email format
    return email;
  }

  final localPart = parts[0];
  final domainPart = '@${parts[1]}';

  if (localPart.length <= 2) {
    // If the local part is too short to mask, return it unchanged
    return email;
  }

  // Mask the local part, keeping the first and last characters
  final maskedLocalPart =
      '${localPart[0]}${'*' * (localPart.length - 2)}${localPart[localPart.length - 1]}';

  // Combine the masked local part with the domain part
  return '$maskedLocalPart$domainPart';
}

bool validateEmail(String? value) {
  // const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
  //     r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
  //     r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
  //     r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
  //     r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
  //     r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
  //     r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  const pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
  final regex = RegExp(pattern);

  return value!.isEmpty || !regex.hasMatch(value);
}

bool nameValidator(String value) {
  const pattern = r"^[a-zA-Z-' ]+$";
  final regex = RegExp(pattern);
  return value.isEmpty || !regex.hasMatch(value);
}

bool validatePassword(String? value) {
  const pattern = r"^(?=.*[a-zA-Z])(?=.*[!@#$%^&*])(?=.*\d).+$";
  final regex = RegExp(pattern);
  return value!.isEmpty || !regex.hasMatch(value);
}

bool dateOfBirthValidator(DateTime birthDate, int years) {
  DateTime currentDate = DateTime.now();
  DateTime eighteenYearsAgo = currentDate.subtract(
      Duration(days: years * 365)); // assuming 365 days per year for simplicity

  // Compare birthDate with eighteenYearsAgo
  return birthDate.isAfter(eighteenYearsAgo);
}



String removeSpecialCharacters(String input) {
  return input
      .replaceAll(RegExp(r'[^a-zA-Z]'),
          '') // Replace multiple spaces with a single space
      .trim();
}

String? formatExpiryDate(String? expiryDateString) {
  // Parse the date string
  if (expiryDateString != null &&
      !(expiryDateString.contains('Expired') ||
          expiryDateString.contains('Until Expiry') ||
          expiryDateString.contains('Remaining') ||
          expiryDateString.contains('expiry'))) {
    DateTime expiryDate = DateTime.parse(expiryDateString);
    DateTime now = DateTime.now().toUtc();

    // Check if the expiry date is today
    if (expiryDate.year <= now.year &&
        expiryDate.month <= now.month &&
        expiryDate.day <= now.day) {
      // Calculate hours remaining
      Duration difference = expiryDate.difference(now);
      if (difference.inHours > 0) {
        return '${difference.inHours} Hour${difference.inHours == 1 ? '' : 's'} Remaining';
      } else {
        return 'Expired';
      }
    } else {
      // Calculate days until expiry
      Duration difference = expiryDate.difference(now);

      return difference.inDays > 0
          ? '${difference.inDays} Day${difference.inDays == 1 ? '' : 's'} Until Expiry'
          : difference.inHours > 0 ? "${difference.inHours} Hour${difference.inHours == 1 ? '' : 's'} Remaining" : 'Expired'
            ;
    }
  } else if (expiryDateString != null &&
      (expiryDateString.contains('Expired') ||
          expiryDateString.contains('Until Expiry') ||
          expiryDateString.contains('Remaining') ||
          expiryDateString.contains('expiry'))) {
    return expiryDateString;
  } else {
    return null;
  }
}

String getFormattedCreatedDate(DateTime? created) {
  if (created == null) return '';

  final now = DateTime.now();
  final createdDate = DateTime(created.year, created.month, created.day);

  if (createdDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
    return 'Today';
  } else if (createdDate
      .isAtSameMomentAs(now.subtract(const Duration(days: 1)))) {
    return 'Yesterday';
  } else {
    return DateFormat('MM/dd/yyyy').format(created);
  }
}
extension DateTimeFormatting on DateTime {
  // Extension method to format DateTime as "h:mm a"
  String toTimeString() {
    return DateFormat('h:mm a').format(this);
  }
}
