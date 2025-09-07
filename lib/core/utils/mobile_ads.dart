import 'dart:async';
import 'dart:developer';
import 'package:interview_master/core/secrets/api_key.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
import '../errors/exceptions.dart';

class MobileAds {
  RewardedAd? _ad;

  Future<void> loadAd() async {
    final loader = await RewardedAdLoader.create(onAdLoaded: (ad) => _ad = ad);
    await loader.loadAd(
      adRequestConfiguration: AdRequestConfiguration(
        adUnitId: YANDEX_ADS_BANNER_ID,
      ),
    );
  }

  Future<bool> showAd() async {
    try {
      int attempts = 0;
      while (_ad == null) {
        await loadAd();
        attempts++;
        if (attempts > 5) throw AdsLoadingException();
        await Future.delayed(Duration(seconds: 1));
      }

      Completer<bool>? userReward = Completer<bool>();
      _ad!.setAdEventListener(
        eventListener: RewardedAdEventListener(
          onRewarded: (reward) => userReward.complete(true),
          onAdDismissed: () {
            userReward.complete(false);
            _ad = null;
          },
        ),
      );

      await _ad!.show();
      return await userReward.future;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
