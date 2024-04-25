import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:play_pointz/Animations/celebration_popup_ani.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/controllers/coin_balance_controller.dart';
import 'package:play_pointz/models/home/popup_banner.dart';

class DailyRewardService {
  String dailyRewardText(int poins) {
    return "Congratulations ! You won your daily award $poins PTZ";
  }

  String dailyLooseText(int poins) {
    return "Oooops ! You lost $poins PTZ, Please be active in PlayPointz";
  }

  void showPopupu(BuildContext context, bool plus, int points) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(
                  image: AssetImage(
                    "assets/bg/congrats.png",
                  ),
                ),
              ),
              height: kToolbarHeight * 4,
              width: MediaQuery.of(context).size.width / 1.8,
              child: Padding(
                padding: const EdgeInsets.only(top: 100, left: 10, right: 10),
                child: Text(
                  plus ? dailyRewardText(points) : dailyLooseText(points),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void showLostPopup(BuildContext context, bool plus, int points) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(
                  image: AssetImage(
                    "assets/new/lost_popup2.png",
                  ),
                ),
              ),
              alignment: Alignment.center,
              height: kToolbarHeight * 4,
              width: MediaQuery.of(context).size.width / 1.8,
              padding: EdgeInsets.all(16),
              child: Stack(children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: Text(
                      "-$points PTZ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          );
        });
  }

  void dailyRewardController(
    BuildContext context,
    CoinBalanceController coinController,
    final Callback callback,
  ) async {
    Map response = await Api().sendDailyCoingAddinReq();

    if (response.isNotEmpty) {
      Map p = response["body"];
      int points = p["plus_points"] - p["minus_points"];
      if (points == 0) {
        // showLatePopup(context);
        callback();
        return;
      }
      if (points > 0) {
        Future.delayed(Duration(seconds: 1), () {
          CelebrationPopupAni().DailyRewardPopUp(context, true, points, () {
            callback();
          }, coinController);
          final audio = AudioPlayer();
          audio.play(AssetSource("audio/winpopup.mp3"));
        });

        return;
      } else {
        Future.delayed(Duration(seconds: 1), () {
          CelebrationPopupAni().DailyRewardLostPopUp(context, false, points,
              () {
            callback();
          }, coinController);
          final audio = AudioPlayer();
          audio.play(AssetSource("audio/losepopup.wav"));
        });

        return;
      }
    }
  }

  showLatePopup(context) async {
    PopUpData data = await Api().getlatePopUp();
    if (data.done) {
      if (data.body != null) {
        loadPopup(data.body.image_url, data.body.id, context);
      }
    }
  }

  loadPopup(String imgUrl, String id, BuildContext context) {
    var _image = NetworkImage(imgUrl);
    try {
      _image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener(
          (info, call) {
            // do something
            showPopupBanner(imgUrl, id, context);
          },
        ),
      );
    } catch (e) {}
  }

  void showPopupBanner(String imgUrl, String id, BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.only(bottom: 0),
        content: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 36),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/bg/loading2.gif",
                    image: imgUrl,
                  ),
                ),
              ),
              Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 153, 55),
                        shape: BoxShape.circle,
                        // border: Border.all(color: Colors.white, width: 2)
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'X',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        /* child: Icon(
                          Icons.close,
                          size: 22,
                          color: Colors.black,
                        ), */
                      ))),
            ],
          ),
        ),
      ),
    );
    // Api api = Api();
    // api.popupSeen(id);
  }
}

/*


 */