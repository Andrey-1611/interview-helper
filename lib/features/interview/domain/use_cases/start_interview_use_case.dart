import 'package:interview_master/core/utils/mobile_ads.dart';
import 'package:interview_master/core/utils/network_info.dart';
import '../../../../core/errors/exceptions.dart';

class StartInterviewUseCase {
  final MobileAds _mobileAds;
  final NetworkInfo _networkInfo;

  StartInterviewUseCase(
    this._networkInfo,
    this._mobileAds,
  );

  Future<bool> call() async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) throw NetworkException();
    return await _mobileAds.showAd();
  }
}
