import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/models/NewModelsV2/feed/campings_models.dart';
import 'package:play_pointz/screens/google_ads/inline_adaptive_banner_ads.dart';
import 'package:play_pointz/screens/shimmers/shimmer_widget.dart';

class FeedBannerAD extends StatefulWidget {
  final AdSize adSize;
  final String unitId;
  final CampaignsModel ad;

  const FeedBannerAD({Key key, this.adSize, this.unitId, this.ad})
      : super(key: key);

  @override
  _FeedBannerADState createState() => _FeedBannerADState();
}

class _FeedBannerADState extends State<FeedBannerAD> {
  // BannerAd banner;
  AdManagerBannerAd banner;
  NativeAd bannerNew;

  String bannerAdUnitId = oneByOneAdUnitId;
  var size;
  bool noAds = false;
  bool _adStatus;
  String _err = '';

  int _width;
  int _height;

  double _bannerHeight;

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    _width = MediaQuery.of(context).size.width.round() - 24;
    _height = MediaQuery.of(context).size.width.round() - 24;
    _bannerHeight = (MediaQuery.of(context).size.width.round() - 24).toDouble();

    loadOriginal();
    super.didChangeDependencies();
  }

  void loadOriginal() {
    setState(() {
      banner = AdManagerBannerAd(
          sizes: [
            AdSize(
                width: MediaQuery.of(context).size.width.round() - 24,
                height: MediaQuery.of(context).size.width.round() - 24),
            AdSize.fluid
          ],
          adUnitId: oneByOneAdUnitId,
          listener: AdManagerBannerAdListener(
            onAdLoaded: (Ad ad) {
              debugPrint('360 Banner Ad loaded.');
              setState(() {
                noAds = false;
                _adStatus = true;
                _err = '';
                _bannerHeight = size.width - 24;
              });
            },
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
              debugPrint('original Ad failed to load: $error');
              setState(() {
                _adStatus = false;
                _err = error.message;
                _bannerHeight = 0;
              });
            },
            onAdOpened: (Ad ad) => debugPrint('Banner Ad opened.'),
            onAdClosed: (Ad ad) {
              debugPrint('Banner Ad closed.');
              ad.dispose();
            },
            onAdImpression: (Ad ad) => debugPrint('Banner Ad impression.'),
          ),
          request: AdManagerAdRequest(nonPersonalizedAds: true))
        ..load();
    });
  }

  /* void load360() {
    setState(() {
      banner = AdManagerBannerAd(
          sizes: [AdSize(width: 336, height: 336)],
          adUnitId: "/22963169719/002",
          /*   adUnitId: widget.ad.sponsorName != 'google'
              ? "/22963169719/002"
              : "/22963169719/google_ads", */
          listener: AdManagerBannerAdListener(
            onAdLoaded: (Ad ad) {
              debugPrint('360 Banner Ad loaded.');
              setState(() {
                noAds = false;
                _adStatus = true;
                _err = '';
                _bannerHeight = 336;
              });
            },
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
              debugPrint('360 Ad failed to load: $error');
              setState(() {
                noAds = true;
                _adStatus = false;
                _err = error.message;
                _bannerHeight = 0;
              });
            },
            onAdOpened: (Ad ad) => debugPrint('Banner Ad opened.'),
            onAdClosed: (Ad ad) {
              debugPrint('Banner Ad closed.');
              ad.dispose();
            },
            onAdImpression: (Ad ad) => debugPrint('Banner Ad impression.'),
          ),
          request: AdManagerAdRequest(nonPersonalizedAds: true))
        ..load();
    });
  } */

  @override
  void dispose() {
    /* setState(() {
      banner = null;
    }); */
    banner.dispose();
    //bannerNew.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (banner == null) {
      return const SizedBox();
    } else if (_adStatus == null) {
      return Container();
    } else {
      return Container(
        color: Colors.white,
        padding: _adStatus
            ? const EdgeInsets.only(top: 6, bottom: 6)
            : const EdgeInsets.all(0),
        margin: _adStatus
            ? const EdgeInsets.only(bottom: 6)
            : const EdgeInsets.all(0),
        child: Column(
          children: [
            _adStatus
                ? Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              width: 24.0,
                              height: 24.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage("assets/logos/flash.png"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /* SizedBox(
                              width: MediaQuery.of(context).size.width - 70,
                              child: Text(
                                widget.ad.sponsorName,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ), */
                            Text(
                              // timeago.format(DateTime.parse(widget.campaing.dateCreated)),
                              'Sponsored',
                              style: TextStyle(
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  )
                : Container(),
            _adStatus
                ? Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    color: _adStatus ? Colors.transparent : Colors.transparent,
                    width: _adStatus
                        ? size.width.toDouble() - 24
                        : size.width.toDouble() - 24,
                    height: _adStatus ? _bannerHeight : 0,
                    child: _adStatus
                        ? AdWidget(
                            ad: banner,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ShimmerWidget(
                              isCircle: false,
                              height: MediaQuery.of(context).size.width,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ), /* Container(
                      color: Colors.transparent,
                      height: 0,
                    ), */
                  )
                : InlineAdaptiveBannerAds(
                    bannerHeight: 250,
                    bannerWidth: 300,
                  ),
          ],
        ),
      );
    }
  }
}
