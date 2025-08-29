 



import 'package:intl/intl.dart';
import 'package:html/parser.dart' as html_parser;



import '../export_all.dart';


// import '../config/app_colors.dart';

class Helper {
  // static String customDateFormatter(DateTime? date, BuildContext context) {
  //   return  DateFormat('dd MMM yyyy', context.locale.languageCode).format(date ?? DateTime.now());
  // }

  static showMessage(String? text)async {
    
    if (text != null && text != "") {
      final translated = await Helper.getTranslatedText(text);
      Fluttertoast.showToast(
          msg:  translated,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.primaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  static showDisplayImage(double height, Widget? child) {
    Skeleton.ignore(
        // baseColor: Colors.grey, highlightColor: Colors.blueGrey,
        child: Container(
      height: height,
    ));
  }

  static List errorHandler(String val) {
    List<String> results = [];
    List<String> resultConcator = [];
    String output;

    val.toString().substring(0, 2);
    results.add(val.toString().substring(0, 3));

    Map<String, dynamic> errors =
        json.decode(val.toString().substring(3, val.toString().length))['data'];

    if (errors.values.length > 1) {
      for (var value in errors['errors'].values) {
        resultConcator.add(value[0]);
      }
      resultConcator.join();

      output = resultConcator.join('\n');

      results.add(output);
    } else {
      results.add(errors['error']);
    }

    return results;
  }

  static List genericErrorHandler(String val) {
    if (val.contains("TimeoutException")) {
      return [408, "Request Timeout"];
    }
    List<String> results = [];

    results.add(val.toString().substring(0, 3));
    if (results[0] == "500") {
      results.add("Something went wrong. Please try again later.");
      return results;
    }
    Map<String, dynamic> errors =
        json.decode(val.toString().substring(3, val.toString().length));
    if (errors.containsKey('data')) {
      if (errors['data'].containsKey('error')) {
        results.add(errors['data']['error']);
      }
      if (errors['data'].containsKey('message')) {
        results.add(errors['data']['message']);
      }
    } else {
      if (errors.containsKey('error')) {
        results.add(errors['error']);
      }
      if (errors.containsKey('message')) {
        results.add(errors['message']);
      }
    }

    return results;
  }

  static String convertToHtml(String input) {
    if (input.trim().isEmpty) return "";

    // Splitting text into lines
    List<String> lines = input.split('\n');
    StringBuffer htmlBuffer = StringBuffer();

    htmlBuffer.writeln("<h3>${lines.first.trim()}</h3>");

    for (int i = 1; i < lines.length; i++) {
      String line = lines[i].trim();

      if (line.isEmpty) continue;

      // Detect bullet points (e.g., "- Example" or "* Example")
      if (line.startsWith('-') || line.startsWith('*')) {
        htmlBuffer.writeln("<ul><li>${line.substring(1).trim()}</li></ul>");
      }
      // Handle subheadings
      else if (line.contains("Options") ||
          line.contains("Concepts") ||
          line.contains("References") ||
          line.contains("Topic")) {
        htmlBuffer.writeln("<h4>$line</h4>");
      }
      // Regular paragraph text
      else {
        htmlBuffer.writeln("<p>$line</p>");
      }
    }

    return htmlBuffer.toString();
  }

  static String formatDateTime(DateTime date) {
    // Format to "yyyy-MM-ddTHH:mm:ss.SSSZ" (without UTC conversion)
    String formattedString =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(date);

    return formattedString;
  }

  static String convertHtmlToFormat(String? htmlContent) {
    // Parse the HTML content
    if (htmlContent == null) return "";
    var document = html_parser.parse(htmlContent);

    // Extract the plain text from the parsed document
    String plainText = document.body?.text ?? '';

    return plainText.trim();
  }

  static String timeLeft(String dateString) {
    if (dateString.isEmpty) return "";
    DateTime now = DateTime.now();

    DateTime parsedDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(dateString).toLocal();
    String formattedTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(now);

    DateTime currentDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(formattedTime);

    // print("Formatted Time: $formattedTime");

    Duration difference = parsedDate.difference(currentDate);

    if (difference.inSeconds < 0) {
      return "Not Available";
    } else if (difference.inMinutes < 1) {
      return "Less than a minute left";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes left";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours left";
    } else {
      return "${(difference.inHours / 24).ceil()} days left";
    }
  }

  static String formatDateTime2(String dateString) {
    if (dateString.isEmpty) return "";
    // Format to "yyyy-MM-ddTHH:mm:ss.SSSZ" (without UTC conversion)
    DateTime parsedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        .parseUtc(dateString)
        .toLocal();

    return DateFormat("d MMM yy").format(parsedDate);
  }

  static Future<void> openMap(double latitude, double longitude) async {
    final String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final Uri uri = Uri.parse(googleUrl);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not open the map.';
    }
  }

  static setCheckInFormat(String date) {
    if (date == "") {
      return "";
    }
    String formattedDate =
        DateFormat("d MMM yyyy, h:mm a").format(DateTime.parse(date).toLocal());
    return formattedDate;
  }

  static String setTime(String time) {
    if (time == "") return "";
    DateTime parsedDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parseUTC(time).toLocal();

    // Format into 12-hour format with AM/PM
    String formattedTime = DateFormat("hh:mm a").format(parsedDate);
    return formattedTime;
  }

  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    if (DateFormat('yyyy-MM-dd').format(date) ==
        DateFormat('yyyy-MM-dd').format(now)) {
      return "Today";
    } else if (DateFormat('yyyy-MM-dd').format(date) ==
        DateFormat('yyyy-MM-dd').format(yesterday)) {
      return "Yesterday";
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  static bool isSameDay(String dateString) {
    try {
      // Parse the string as a UTC DateTime
      DateTime parsedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .parse(dateString)
          .toLocal();

      // Get the current date
      DateTime now = DateTime.now();

      // Compare only the date part (ignoring time)
      return parsedDate.year == now.year &&
          parsedDate.month == now.month &&
          parsedDate.day == now.day;
    } catch (e) {
      return false;
    }
  }

//   static Future<File?> compressImage(File file) async {
//   Directory dir = await getTemporaryDirectory();
//   String targetPath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

//   final compressedFile = await FlutterImageCompress.compressAndGetFile(
//     file.absolute.path,
//     targetPath,
//     format: CompressFormat.jpeg,
//     quality: 60,
//     minWidth: 1080,
//     minHeight: 1080,
//   );

//   if (compressedFile != null) {
//     final sizeInMB = await compressedFile.length() / (1024 * 1024);
//     appLog('Compressed image size: ${sizeInMB.toStringAsFixed(2)} MB');
//   }

//   return compressedFile != null ? File(compressedFile.path) : null;
// }
static Future<File?> compressImage(File file) async {
  final dir = await getTemporaryDirectory();
  final targetPath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

  final result = await FlutterImageCompress.compressAndGetFile(
    file.path,
    targetPath,
    format: CompressFormat.jpeg,
    quality: 60,
    minWidth: 1080,
    minHeight: 1080,
  );

  return result != null ? File(result.path) : null;
}

  static String getFileExtension(String filePath) {
    return filePath.split('.').last;
  }

  static String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  static setCardIcon(String type) {
    switch (type.toLowerCase()) {
      case "visa":
        return Assets.visa;
      case "mastercard":
      case "master":
        return Assets.masterCard;
      case "paypal":
        return Assets.paypal;

      default:
        return "";
    }
  }

  static String getReadableDateHeader(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final noteDate = DateTime(date.year, date.month, date.day);
  final difference = today.difference(noteDate).inDays;

  if (difference == 0) {
    return "Today";
  } else if (difference == 1) {
    return "Yesterday";
  } else {
    return DateFormat("MMM dd, yyyy").format(date);
  }
}
static String getEmojiLabel(String? emoji) {
  if (emoji == null || emoji.isEmpty) {
    return 'Like';
  }
  switch (emoji) {
    case '❤️':
      return 'Love';
    case '🥰':
      return 'In Love';
    case '😊':
      return 'Happy';
    case '👍':
      return 'Like';
    case '🤚':
      return 'High Five';
    case '🥳':
      return 'Party';
    case '🤝':
      return 'Handshake';
    default:
      return 'Like';
  }
}
static final List<String> emojiOptions = [
  '❤️',   // :heart:
  '🥰',   // :smiling_face_with_3_hearts:
  '😊',   // :blush:
  '👍',   // :+1:
  '🤚',   // :raised_back_of_hand:
  '🥳',   // :partying_face:
  '🤝',   // :handshake:
];

static bool validateDateDifference({required DateTime startDate, required DateTime endDate}) {
  // Ensure startDate is before endDate
  // if (startDate.isAfter(endDate)) {
  //   Helper.showMessage("Start date cannot be after end date.");
  //   return false;
  // }

  // Calculate the exact time difference in hours
  Duration difference = endDate.difference(startDate);

  // Convert the total difference into hours and check if it exceeds 90 days (2160 hours)
  int totalHours = difference.inHours;

  if (totalHours > 90 * 24) {
    Helper.showMessage("Please select a date range within 90 days.");
    return false; // Invalid duration (exceeds 90 days)
  }

  return true; // Valid duration
}
static double celsiusToFahrenheit(double celsius) {
  return (celsius * 9 / 5) + 32;
}
static num getDeliveryPriceByType(
    List<DeliveryOptionDataModel>? deliveryOptions, String type) {
  if (deliveryOptions == null) return 0;

  final option = deliveryOptions.firstWhere(
    (e) => e.type.toLowerCase() == type.toLowerCase(),
    orElse: () => DeliveryOptionDataModel(type: '', price: 0, description: ''),
  );

  return option.price;
}
static String getCachedTranslation({
  required WidgetRef ref,
  required String text,
}) {
  final languageCode = ref.watch(languageChangeNotifierProvider).currentLanguage.code;
  final translationAsyncValue = ref.watch(translationNotifierProvider(Tuple2(text, languageCode)));

  return translationAsyncValue.maybeWhen(
    data: (value) => value,
    orElse: () => text,
  );
}
static Future<String> getTranslatedText(String text) async {
  // Fetch the translated text using the singleton TranslationService
  final instance = SharedPreferenceManager.sharedInstance;
  final translated = await TranslationService().translate(
    text: text,
    toLanguageCode: instance.getLangCode(),
  );

  

  return translated;
}
 
}
