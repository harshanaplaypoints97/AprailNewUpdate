import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/screens/google_ads/inline_adaptive_banner_ads.dart';

class BannerAD extends StatefulWidget {
  final AdSize adSize;
  final String unitId;

  const BannerAD({Key key, this.adSize, this.unitId}) : super(key: key);

  @override
  _BannerADState createState() => _BannerADState();
}

class _BannerADState extends State<BannerAD> {
  // BannerAd banner;
  AdManagerBannerAd banner;
  NativeAd bannerNew;

  var size;

  String bannerAdUnitId = oneByOneAdUnitId;

  bool _adStatus = false;
  String _err = '';

  int _width;
  int _height;

  double _bannerHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // adState.initialization.then((value) async {
    // Assigning the size of adaptive banner ad after adState initialization.
    size = MediaQuery.of(context).size;
    _width = MediaQuery.of(context).size.width.round() - 24;
    _height = MediaQuery.of(context).size.width.round() - 24;
    _bannerHeight = (MediaQuery.of(context).size.width.round() - 24).toDouble();

    setState(() {
      if (bannerAdUnitId != null) {
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
                debugPrint('Ad loaded.');
                setState(() {
                  _adStatus = true;
                  _err = '';
                  _bannerHeight =
                      (MediaQuery.of(context).size.width.round() - 24)
                          .toDouble();
                });
              },
              onAdFailedToLoad: (Ad ad, LoadAdError error) {
                debugPrint('Ad failed to load: $error');
                if (_width > 360) {
                  setState(() {
                    _adStatus = false;
                    _err = error.message;
                    _bannerHeight = 0;
                  });
                  ad.dispose();

                  load360();
                } else {
                  ad.dispose();
                  debugPrint('Ad failed to load: $error');
                  _adStatus = false;
                  _err = error.message;
                }
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

  void load360() {
    setState(() {
      banner = AdManagerBannerAd(
          sizes: [AdSize(width: 336, height: 336)],
          adUnitId: oneByOneAdUnitId,
          listener: AdManagerBannerAdListener(
            onAdLoaded: (Ad ad) {
              debugPrint('360 Banner Ad loaded.');
              setState(() {
                _adStatus = true;
                _err = '';
                _bannerHeight = 336;
              });
            },
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
              debugPrint('360 Ad failed to load: $error');
              setState(() {
                _adStatus = false;
                _err = error.message;
                _bannerHeight = 0;
              });
            },
            onAdOpened: (Ad ad) => debugPrint('Banner Ad opened.'),
            onAdClosed: (Ad ad) => debugPrint('Banner Ad closed.'),
            onAdImpression: (Ad ad) => debugPrint('Banner Ad impression.'),
          ),
          request: AdManagerAdRequest(nonPersonalizedAds: true))
        ..load();
    });
  }

  @override
  void dispose() {
    banner.dispose();
    // bannerNew.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (banner == null) {
      return const SizedBox();
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        margin: _adStatus
            ? EdgeInsets.symmetric(vertical: 6)
            : const EdgeInsets.symmetric(vertical: 0),
        padding: _adStatus ? EdgeInsets.only(top: 6) : const EdgeInsets.all(0),
        child: Column(
          children: [
            _adStatus
                ? /* Row(children: [
              Spacer(),
            Text('Sponsored'),
            SizedBox(width: 12,)
            ],) */
                Container(
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
                        width: MediaQuery.of(context).size.width-70,
                        child: Text(
                          widget.campaing.sponsorName,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ), */
                            Row(
                              children: [
                                Text(
                                  // timeago.format(DateTime.parse(widget.campaing.dateCreated)),
                                  'Sponsored',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InlineAdaptiveBannerAds(
                      bannerHeight: 250,
                      bannerWidth: 300,
                    ),
                  ),

            /* Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ShimmerWidget(
                      isCircle: false,
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ), */
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
        ),
      );
    }
  }
}
