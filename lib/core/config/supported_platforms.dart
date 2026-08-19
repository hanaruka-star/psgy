import 'package:flutter/foundation.dart';

/// ParkingLink targets **iOS and Android only** (no Web, Desktop, Linux).
abstract final class SupportedPlatforms {
  static const supported = {TargetPlatform.iOS, TargetPlatform.android};

  static bool get isMobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  static void ensureMobile() {
    if (kIsWeb) {
      throw UnsupportedError(
        'ParkingLink does not support Web. Use iOS or Android builds only.',
      );
    }
    if (!supported.contains(defaultTargetPlatform)) {
      throw UnsupportedError(
        'ParkingLink supports iOS and Android only. '
        'Current platform: $defaultTargetPlatform',
      );
    }
  }
}
