import 'package:injectable/injectable.dart';
import 'package:interview_master/core/constants/app_data.dart';
import 'package:url_launcher/url_launcher.dart';

@lazySingleton
class UrlLaunch {
  Future<void> openAppInRuStore() async =>
      await launchUrl(Uri.parse(AppData.url));
}
