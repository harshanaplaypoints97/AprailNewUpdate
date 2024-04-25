import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/screens/google_ads/inline_adaptive_banner_ads.dart';

class StoreBannerAD extends StatefulWidget {
  final AdSize adSize;
  final String unitId;

  const StoreBannerAD({Key key, this.adSize, this.unitId}) : super(key: key);

  @override
  _StoreBannerADState createState() => _StoreBannerADState();
}

class _StoreBannerADState extends State<StoreBannerAD> {
  AdManagerBannerAd banner;
  NativeAd bannerNew;

  var size;
  String bannerAdUnitId = wideBannerAdUnitId;

  bool _adStatus;
  String _err = '';

  int _width;
  int _height;

  double _bannerHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    size = MediaQuery.of(context).size;
    _width = MediaQuery.of(context).size.width.round() - 24;
    _height =
        ((MediaQuery.of(context).size.width.round() - 24).round() * 9 / 21)
            .round();
    _bannerHeight = ((MediaQuery.of(context).size.width.round() - 24) * 9 / 21)
        .round()
        .toDouble();

    setState(() {
      if (bannerAdUnitId != null) {
        banner = AdManagerBannerAd(
            sizes: [AdSize(width: 360, height: 141), AdSize.fluid],
            adUnitId: wideBannerAdUnitId,
            listener: AdManagerBannerAdListener(
              onAdLoaded: (Ad ad) {
                debugPrint('Ad loaded.');
                setState(() {
                  _adStatus = true;
                  _err = '';
                  _bannerHeight = 141;
                });
              },
              onAdFailedToLoad: (Ad ad, LoadAdError error) {
                debugPrint('Ad failed to load: $error');
                setState(() {
                  _adStatus = false;
                  _err = error.message;
                  _bannerHeight = 0;
                });
                ad?.dispose();
              },
              onAdOpened: (Ad ad) => debugPrint('Ad opened.'),
              onAdClosed: (Ad ad) => debugPrint('Ad closed.'),
              onAdImpression: (Ad ad) => debugPrint('Ad impression.'),
            ),
            request: AdManagerAdRequest(nonPersonalizedAds: true))
          ..load();
      }
    });
    // });
  }

  @override
  void dispose() {
    banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (banner == null) {
      return Container();
    } else if (_adStatus == null) {
      return Container();
    } else if (_adStatus) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: _adStatus
                ? const EdgeInsets.symmetric(horizontal: 12, vertical: 6)
                : const EdgeInsets.all(0),
            color: _adStatus ? Colors.transparent : Colors.transparent,
            width: _adStatus
                ? size.width.toDouble() - 24
                : size.width.toDouble() - 24,
            height: _adStatus ? _bannerHeight : 0,
            child: _adStatus
                ? AdWidget(
                    ad: banner,
                  )
                : Container(
                    color: Colors.transparent,
                    height: 0,
                  ),
          ),
        ],
      );
    } else if (!_adStatus) {
      return InlineAdaptiveBannerAds(
        bannerWidth: 320,
        bannerHeight: 100,
      );
    } else {
      return Container();
    }
  }
}
