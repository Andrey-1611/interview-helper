import 'dart:ui' as info;

class DeviceService {
  Future<bool> getLanguage() async {
    final locale = info.PlatformDispatcher.instance.locale;
    final code = locale.languageCode;
    return Future.value(code == 'ru');
  }
}
