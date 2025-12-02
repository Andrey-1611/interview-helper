import 'package:injectable/injectable.dart';
import 'dart:ui' as info;

@lazySingleton
class DeviceInfo {
  Future<bool> getLanguage() async {
    final locale = info.PlatformDispatcher.instance.locale;
    final code = locale.languageCode;
    return Future.value(code == 'ru');
  }
}
