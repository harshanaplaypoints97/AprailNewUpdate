import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Shared%20Pref/player_pref.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/style.dart';
import 'package:play_pointz/controllers/coin_balance_controller.dart';
import 'package:play_pointz/models/getAds.dart';
import 'package:play_pointz/models/get_reffaral_points.dart';
import 'package:play_pointz/models/home/popup_banner.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/google_ads/inline_adaptive_banner_ads.dart';
import 'package:play_pointz/screens/google_ads/store_banner_ad.dart';
import 'package:play_pointz/widgets/common/popup.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../shimmers/shimmer_widget.dart';

class ConnectPage extends StatefulWidget {
  final Function homeFeed;
  const ConnectPage({Key key, this.homeFeed}) : super(key: key);

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

  List<BodyOfGetAds> bannerAds = [];
  // GetAds banner;

  bool sharing = false;
  bool havePoints = false;

  String myRef = "";
  int ads = 0;
  String refPoint = '0';
  String refarrallink = "";
  var data;
  bool loadingdata = false;
  String get shareText =>
      "Engage in an exciting e-commerce app experience with PlayPointz.Join with the link to play, earn, and redeem. $refarrallink";
  String get shareTextWithoutLink =>
      "Engage in an exciting e-commerce app experience with PlayPointz.Join with the link to play, earn, and redeem.";
  CoinBalanceController coinBalanceController;
  Random random = Random();
  Widget randomAdWidget;

  String current = '';

  share() async {}

  getRefarralLink() async {
    setState(() {
      loadingdata = true;
    });
    data = await getPlayerPref(key: "playerProfileDetails");

    setState(() {
      refarrallink = "$baseUrl/invite/${data['invite_token']}";

      loadingdata = false;
    });
  }

  getRefPointz() async {
    GetRefarralPoints result = await Api().getRefPoints(context);
    if (result.done) {
      if (result.body.joinPoints > 0) {
        setState(() {
          refPoint = result.body.joinPoints.toString();
          havePoints = true;
        });
      }
    }
  }

  showLatePopup() async {
    PopUpData data = await Api().getlatePopUp();
    if (data.done) {
      if (data.body != null) {
        loadPopup(data.body.image_url, data.body.id);
      }
    }
  }

  loadPopup(String imgUrl, String id) {
    try {
      var _image = NetworkImage(imgUrl);

      _image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener(
          (info, call) {
            showPopupBanner(imgUrl, id, context);
          },
        ),
      );
    } catch (e) {}
  }

  getOrders() async {
    setState(() {
      loadingdata = true;
    });
    GetAds result = await Api().getAds(type: 'Banner', placement: 'Feed');
    if (result.done != null) {
      if (result.done) {
        bannerAds = result.body;

        setState(() {
          ads = bannerAds.length;
          loadingdata = false;
        });
      } else {
        setState(() {
          loadingdata = false;
        });
      }
    } else {
      setState(() {
        loadingdata = false;
      });
    }
  }

  getLink() async {
    var token = await getPlayerPref(key: "ref_token");

    String refToken = token == null || token == "" ? "" : token["ref_token"];
    setState(() {
      myRef = refToken.toString();
    });
  }

  @override
  void initState() {
    getRefPointz();
    coinBalanceController = Get.put(CoinBalanceController(callback: () {
      debugPrint(
          "+++++++++++++++++++++++++ controller from paly widget called");
      setState(() {});
    }));
    getRefarralLink();
    getOrders();
    getLink();
    super.initState();
    getcurrent();
    showLatePopup();
    randomAdWidget = getRandomBannerAds();
  }

  getcurrent() async {
    const oneSec = Duration(seconds: 3);
    Timer.periodic(
        oneSec,
        (Timer t) => setState(() {
              current = '';
            }));
  }

  Widget getRandomBannerAds() {
    int randomNumber = random.nextInt(2);
    return randomNumber == 0
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: InlineAdaptiveBannerAds(
              bannerWidth: 300,
              bannerHeight: 100,
            ),
          )
        : StoreBannerAD();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 0),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(child: randomAdWidget),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Image.asset("assets/connect_assets/text.png"),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    userController.currentUser.value != null &&
                            !userController.currentUser.value.is_brand_acc
                        ? havePoints
                            ? Container(
                                width: size.width,
                                margin: EdgeInsets.all(12),
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Color(0xffDBDBDB)),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  children: [
                                    Text(
                                      "Referral Pointz",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff52616B)),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Text(
                                      'invite Friends to earn referral pointz',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: Image(
                                            image: AssetImage(
                                                "assets/logos/z.png"),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        Text(
                                          refPoint.toString(),
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff52616B)),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Text(
                                      'Invite More. Earn More.',
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Shimmer.fromColors(
                                baseColor: Colors.grey[400],
                                highlightColor: Colors.grey[300],
                                child: Container(
                                  width: size.width,
                                  height: size.height * 0.2,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.rectangle,
                                  ),
                                ),
                              )
                        : Container(),
                    const SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: Text(
                        "Referral link",
                        style: AppStyles.title,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: kToolbarHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              alignment: Alignment.center,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: refarrallink.length,
                                itemBuilder: (contex, index) => Center(
                                  child: Text(
                                    refarrallink[index],
                                    style: TextStyle(
                                        color: Colors.grey.withOpacity(0.5)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.width * 0.08,
                              child: InkWell(
                                  onTap: () async {
                                    /* SocialShare.copyToClipboard(
                                        text: 'shareText'); */
                                    await Clipboard.setData(
                                        ClipboardData(text: shareText));
                                    messageToastGreen(
                                        "Referral link copied to clipboard");
                                  },
                                  child: Image.asset(
                                      "assets/connect_assets/copy.png")),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.08,
                          width: MediaQuery.of(context).size.width * 0.08,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.08,
                          child: InkWell(
                              onTap: () => shareToSocialMedia(0),
                              child: Container(child: shareImage(0))),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.08,
                          child: InkWell(
                              onTap: () => shareToSocialMedia(1),
                              child: Container(child: shareImage(1))),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.08,
                          child: InkWell(
                              onTap: () => shareToSocialMedia(2),
                              child: Container(child: shareImage(2))),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.08,
                          child: InkWell(
                              onTap: () => shareToSocialMedia(3),
                              child: Container(child: shareImage(3))),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.08,
                          width: MediaQuery.of(context).size.width * 0.08,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

/*
    0 -whatsapp, 1 -text 2 -clipboard 3 -telegram 4 -instagram 5 -twitter 6-reddit
*/
  Future<void> shareToSocialMedia(int index) async {
    debugPrint("index is $index");
    switch (index) {
      case 0:
        Share.share(
            "Engage in an exciting e-commerce app experience with PlayPointz.Join with the link $refarrallink to play, earn, and redeem.");

        return;
      case 1:
        SocialShare.shareWhatsapp(shareText);
        return;

      // case 1:
      //   SocialShare.copyToClipboard(shareText);
      //   messageToastGreen("Refferal link copied to clipboard");
      //   return;
      case 2:
        SocialShare.shareTelegram(shareText);
        return;
      case 3:
        SocialShare.shareTwitter(
          shareTextWithoutLink,
          hashtags: ["fun", "ecommerce", "playpointz"],
          url: refarrallink,
        );
        return;
      case 4:
        SocialShare.shareSms(shareTextWithoutLink, url: refarrallink);
        return;
      default:
        return;
    }
  }

  Image shareImage(int index) {
    switch (index) {
      case 0:
        return Image.asset("assets/connect_assets/share_1.png");
        break;
      case 1:
        return Image.asset("assets/connect_assets/whatsapp.png");
        break;
      case 2:
        return Image.asset("assets/connect_assets/telegram.png");
        break;
      case 3:
        return Image.asset("assets/connect_assets/twitter.png");
        break;
    }
  }

  Widget banner(BuildContext context, String redirectUrl, String media) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap:
          redirectUrl == '' || redirectUrl == null || redirectUrl == 'undefined'
              ? () {}
              : () async {
                  String url = redirectUrl.contains("http")
                      ? redirectUrl
                      : "https://$redirectUrl";
                  Uri uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {}
                },
      child: Container(
        width: size.width,
        height: size.width * 0.8 / 21 * 9,
        decoration: BoxDecoration(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
            cacheManager: CustomCacheManager.instance,
            imageUrl: media,
            errorWidget: (context, url, error) => SizedBox(),
            placeholder: (context, a) {
              return ShimmerWidget(
                isCircle: false,
                width: MediaQuery.of(context).size.width / 1.2,
                height: 240.h,
              );
            },
          ),
        ),
      ),
    );
  }
}
