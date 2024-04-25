import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:play_pointz/config.dart';

class InlineAdaptiveBannerAds extends StatefulWidget {
  final int bannerHeight;
  final int bannerWidth;
  InlineAdaptiveBannerAds({
    this.bannerHeight,
    this.bannerWidth,
    Key key,
  }) : super(key: key);

  @override
  State<InlineAdaptiveBannerAds> createState() =>
      _InlineAdaptiveBannerAdsState();
}

class _InlineAdaptiveBannerAdsState extends State<InlineAdaptiveBannerAds> {
  static const _insets = 16.0;
  BannerAd _inlineAdaptiveAd;
  bool _isLoaded = false;
  AdSize _adSize;
  Orientation _currentOrientation;

  double get _adWidth =>
      MediaQuery.of(context).size.width /* - (2 * _insets) */;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
    _loadAd();
  }

  void _loadAd() async {
    await _inlineAdaptiveAd?.dispose();
    setState(() {
      _inlineAdaptiveAd = null;
      _isLoaded = false;
    });

    /*  AdSize size = AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(
        _adWidth.truncate()); */

    _inlineAdaptiveAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? googleBannerAdUnitIdAndroid
          : googleBannerAdUnitIdIos,
      size: AdSize(width: widget.bannerWidth, height: widget.bannerHeight),
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) async {
          print('Inline adaptive banner loaded: ${ad.responseInfo}');

          BannerAd bannerAd = (ad as BannerAd);
          final AdSize size = await bannerAd.getPlatformAdSize();
          if (size == null) {
            print('Error: getPlatformAdSize() returned null for $bannerAd');
            return;
          }

          setState(() {
            _inlineAdaptiveAd = bannerAd;
            _isLoaded = true;
            _adSize = size;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Inline adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    await _inlineAdaptiveAd.load();
  }

  Widget _getAdWidget() {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_currentOrientation == orientation &&
            _inlineAdaptiveAd != null &&
            _isLoaded &&
            _adSize != null) {
          return Align(
              child: Container(
            width: _adWidth,
            height: _adSize.height.toDouble(),
            child: AdWidget(
              ad: _inlineAdaptiveAd,
            ),
          ));
        }
        // Reload the ad if the orientation changes.
        if (_currentOrientation != orientation) {
          _currentOrientation = orientation;
          _loadAd();
        }
        return Container();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _inlineAdaptiveAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _getAdWidget();
  }
}
