import 'dart:io';

extension PlatformExtension on Platform {
  static T when<T>({
    required T Function() cupertino,
    required T Function() material,
  }) {
    if (Platform.isIOS || Platform.isMacOS) {
      return cupertino();
    }
    return material();
  }
}
