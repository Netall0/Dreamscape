import 'package:lottie/lottie.dart';
import 'extension/first_where_or_null.dart';


class LottieUtils {
static Future<LottieComposition?> customDecoder(List<int> bytes) => LottieComposition.decodeZip(
    bytes,
    filePicker: (files) => files.firstWhereOrNull(
        (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
      ),
  );
}
