import 'dart:developer';

import 'package:flutter/foundation.dart';

class Utils {
  static void console(String message) {
    if (kDebugMode) {
      log(message);
    }
  }
}
