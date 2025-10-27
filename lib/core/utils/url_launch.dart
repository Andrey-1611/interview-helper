import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

@lazySingleton
class UrlLaunch {
  static const _appUrl =
      'https://www.rustore.ru/catalog/app/com.example.interview_master';

  Future<void> openAppInRuStore() async => await launchUrl(Uri.parse(_appUrl));
}
