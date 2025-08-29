import 'dart:developer';

import 'package:flutter/foundation.dart';


appPrint(message) {
  if (kDebugMode) {
    print("🐒👀 => $message");
  }
}

appLog(message) {
  if (kDebugMode) {
    log("🐒👀 => $message");
  }
}
