import 'package:lottie/lottie.dart';
import 'dart:collection';
import "extension/first_where_or_null.dart";


class LottieUtils {
static Future<LottieComposition?> customDecoder(List<int> bytes) {
  return LottieComposition.decodeZip(
    bytes,
    filePicker: (files) {
      return files.firstWhereOrNull(
        (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
      );
    },
  );
}
}

