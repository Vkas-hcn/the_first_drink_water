import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../utils/LocalStorage.dart';

enum AdWhere {
  OPEN,
  SAVE,
  BACK,
  Next
}

class GgUtils {
  static final GgUtils _instance = GgUtils._internal();
  static const String openId = "ca-app-pub-3940256099942544/9257395921";
  static const String saveId = "ca-app-pub-3940256099942544/8691691433";
  static const String backId = "ca-app-pub-3940256099942544/8691691433";
  static const String nextId = "ca-app-pub-3940256099942544/8691691433";

  factory GgUtils() {
    return _instance;
  }

  GgUtils._internal();

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoading = false;
  AppOpenAd? _appOpenAd;
  bool _isAppOpenAdLoading = false;
  bool isFistOpen = false;
  int adLoadTimes = 0;

  void loadAd(AdWhere adPosition) async {
    if (_isAppOpenAdLoading || _isInterstitialAdLoading) {
      print("$adPosition广告加载中");
      return;
    }
    if (canMoreAd(adPosition)) {
      print("广告缓存已过期");
      clearAdCache();
    }
    if (canShowAd(adPosition)) {
      print("已有$adPosition广告缓存,不再加载");
      return;
    }
    bool colckState = await blacklistBlocking();
    if (adPosition != AdWhere.OPEN && colckState) {
      print("$adPosition广告黑名单屏蔽");
      return;
    }

    switch (adPosition) {
      case AdWhere.OPEN:
        _loadAppOpenAdWithRetry();
        break;
      case AdWhere.SAVE:
      case AdWhere.BACK:
      case AdWhere.Next:
        _loadInterstitialAdWithRetry(adPosition);
        break;
    }
  }

  void _loadAppOpenAdWithRetry() {
    _isAppOpenAdLoading = true;
    print("加载open广告 id=$openId");
    AppOpenAd.load(
      adUnitId: openId,
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          print("open广告加载成功");
          adLoadTimes = DateTime.now().millisecondsSinceEpoch;
          _appOpenAd = ad;
          _isAppOpenAdLoading = false;
          isFistOpen = false;
        },
        onAdFailedToLoad: (error) {
          print('open广告加载失败: $error');
          _isAppOpenAdLoading = false;
          _appOpenAd = null;
          if (!isFistOpen) {
            isFistOpen = true;
            _loadAppOpenAdWithRetry();
          }
        },
      ),
      orientation: AppOpenAd.orientationPortrait,
    );
  }

  void _loadInterstitialAdWithRetry(AdWhere adPosition) {
    _isInterstitialAdLoading = true;
    String intId = "";
    if (adPosition == AdWhere.SAVE) {
      intId = saveId;
    } else if(adPosition == AdWhere.BACK){
      intId = backId;
    }else{
      intId = nextId;

    }
    print("加载$adPosition广告 id=${intId}");
    InterstitialAd.load(
      adUnitId: intId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          print("加载${adPosition}广告加载成功");
          adLoadTimes = DateTime.now().millisecondsSinceEpoch;
          _interstitialAd = ad;
          _isInterstitialAdLoading = false;
        },
        onAdFailedToLoad: (error) {
          print("加载${adPosition}广告加载失败：${error}");
          _isInterstitialAdLoading = false;
          _appOpenAd = null;
        },
      ),
    );
  }

  bool canMoreAd(AdWhere adWhere) {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (adWhere == AdWhere.OPEN) {
      return _appOpenAd != null && now - adLoadTimes > 4 * 60 * 60 * 1000;
    } else {
      return _interstitialAd != null && now - adLoadTimes > 50 * 60 * 1000;
    }
  }

  //清除广告缓存
  void clearAdCache() {
    _appOpenAd = null;
    _interstitialAd = null;
    _isInterstitialAdLoading = false;
    _isAppOpenAdLoading = false;
  }

  void showAd(
      BuildContext context, AdWhere adPosition, Function() cloneWindow) async {
    if (LocalStorage.isInBack) {
      print("后台不展示广告");
      return;
    }
    adCall(adPosition, cloneWindow);
    if (adPosition == AdWhere.OPEN && _appOpenAd != null) {
      _appOpenAd!.show();
    } else if ((adPosition != AdWhere.OPEN) &&
        _interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      print('No ad available to show');
    }
  }

  bool canShowAd(AdWhere adWhere) {
    switch (adWhere) {
      case AdWhere.OPEN:
        return _appOpenAd != null;
      case AdWhere.SAVE:
      case AdWhere.BACK:
      case AdWhere.Next:
        return _interstitialAd != null;
    }
  }

  void closeAppOpenAd() {
    if (_appOpenAd != null) {
      print("主动关闭广告");
      _appOpenAd!.fullScreenContentCallback!
          .onAdDismissedFullScreenContent!(_appOpenAd!);
    }
  }

  void adCall(AdWhere adPosition, Function() cloneWindow) {
    if (_appOpenAd != null) {
      _appOpenAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (AppOpenAd ad) {
          print("关闭open广告");
          LocalStorage.int_ad_show = false;
          LocalStorage.clone_ad = true;
          cloneWindow();
          ad.dispose();
        },
        onAdWillDismissFullScreenContent: (AppOpenAd ad) {
          print("即将关闭open广告");
        },
        onAdShowedFullScreenContent: (AppOpenAd ad) {
          LocalStorage.int_ad_show = true;
          _appOpenAd = null;
          print("展示open广告");
        },
        onAdClicked: (AppOpenAd ad) {
          print("点击open广告");
          ad.dispose();
        },
      );
    }
    if (_interstitialAd != null) {
      _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          print("关闭$adPosition插屏广告");
          LocalStorage.clone_ad = true;
          ad.dispose();
          loadAd(adPosition);
          cloneWindow();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
        },
        onAdShowedFullScreenContent: (InterstitialAd ad) {
          _interstitialAd = null;
          print("展示$adPosition插屏广告");
        },
        onAdClicked: (InterstitialAd ad) {
          print("点击$adPosition广告");
          ad.dispose();
        },
      );
    }
  }

  static Future<bool> blacklistBlocking() async {
    String? data = LocalStorage().getValue(LocalStorage.clockData);

    if (data != "basaltic") {
      return true;
    }
    return true;
  }
}
