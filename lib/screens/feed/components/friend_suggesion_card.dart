import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/models/friends/friend_suggession_model.dart';
import 'package:play_pointz/models/get_player_profile.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/player_profile/friend_status_button.dart';

import 'package:play_pointz/screens/shimmers/shimmer_widget.dart';

import '../../../constants/default_router.dart';
import '../../profile/profile.dart';

class FriendSuggesionCard extends StatefulWidget {
  final FriendSuggestionModel friend;
  final Function remove;

  FriendSuggesionCard({
    this.friend,
    this.remove,
    Key key,
  }) : super(key: key);

  @override
  State<FriendSuggesionCard> createState() => _FriendSuggesionCardState();
}

class _FriendSuggesionCardState extends State<FriendSuggesionCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setProfileData();
  }

  BodyOfProfileData player;
  Future<void> setProfileData() async {
    debugPrint("player id is ${widget.friend.id}");
    try {
      if (widget.friend.id != null) {
        GetPlayerProfile getProfile =
            await Api().getPlayersProfle(playerId: widget.friend.id);
        setState(() {
          player = getProfile.body;
          print("------------------------+++++++++++++++++++++++++" +
              player.friendStatus);
        });
        debugPrint("--------- player setted succesfully");
      }
    } catch (e) {
      debugPrint("set profile data failed $e");
    }
  }

  removeFriend() {
    widget.remove;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        DefaultRouter.defaultRouter(
          Profile(id: widget.friend.id, myProfile: false, postId: ""),
          /*  PlayerProfieView(
                          playerId:
                              widget.postModel.post_comments.last.player_id,
                        ), */
          context,
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.width / 2,
        // padding: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width / 2.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.friend.profile_image.toString() ==
                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
                      ? Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width / 3.2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8))),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: widget.friend.full_name[0]
                                                .toUpperCase() ==
                                            "A"
                                        ? Colors.red.withOpacity(0.4)
                                        : widget.friend.full_name[0]
                                                    .toUpperCase() ==
                                                "B"
                                            ? Colors.green.withOpacity(0.4)
                                            : widget.friend.full_name[0]
                                                        .toUpperCase() ==
                                                    "C"
                                                ? Colors.blue.withOpacity(0.4)
                                                : widget.friend.full_name[0]
                                                            .toUpperCase() ==
                                                        "D"
                                                    ? Colors.purple
                                                        .withOpacity(0.4)
                                                    : widget.friend.full_name[0]
                                                                .toUpperCase() ==
                                                            "E"
                                                        ? Colors.orange
                                                            .withOpacity(0.4)
                                                        : widget.friend.full_name[0]
                                                                    .toUpperCase() ==
                                                                "F"
                                                            ? Colors.yellow
                                                                .withOpacity(0.2)
                                                            : widget.friend.full_name[0].toUpperCase() == "G"
                                                                ? Colors.amber.withOpacity(0.4)
                                                                : widget.friend.full_name[0].toUpperCase() == "H"
                                                                    ? Colors.teal.withOpacity(0.4)
                                                                    : widget.friend.full_name[0].toUpperCase() == "I"
                                                                        ? Colors.redAccent.withOpacity(0.4)
                                                                        : widget.friend.full_name[0].toUpperCase() == "J"
                                                                            ? Colors.lime.withOpacity(0.4)
                                                                            : widget.friend.full_name[0].toUpperCase() == "K"
                                                                                ? Colors.cyan.withOpacity(0.4)
                                                                                : widget.friend.full_name[0].toUpperCase() == "L"
                                                                                    ? Colors.indigo.withOpacity(0.4)
                                                                                    : widget.friend.full_name[0].toUpperCase() == "M"
                                                                                        ? Colors.grey.withOpacity(0.4)
                                                                                        : widget.friend.full_name[0].toUpperCase() == "N"
                                                                                            ? Colors.brown.withOpacity(0.4)
                                                                                            : widget.friend.full_name[0].toUpperCase() == "O"
                                                                                                ? Colors.cyanAccent.withOpacity(0.4)
                                                                                                : widget.friend.full_name[0].toUpperCase() == "P"
                                                                                                    ? Colors.lightBlueAccent.withOpacity(0.4)
                                                                                                    : widget.friend.full_name[0].toUpperCase() == "Q"
                                                                                                        ? Colors.lightGreenAccent.withOpacity(0.4)
                                                                                                        : widget.friend.full_name[0].toUpperCase() == "R"
                                                                                                            ? Colors.limeAccent.withOpacity(0.4)
                                                                                                            : widget.friend.full_name[0].toUpperCase() == "S"
                                                                                                                ? Colors.yellowAccent.withOpacity(0.4)
                                                                                                                : widget.friend.full_name[0].toUpperCase() == "T"
                                                                                                                    ? Colors.amberAccent.withOpacity(0.4)
                                                                                                                    : widget.friend.full_name[0].toUpperCase() == "W"
                                                                                                                        ? Colors.orangeAccent.withOpacity(0.4)
                                                                                                                        : widget.friend.full_name[0].toUpperCase() == "X"
                                                                                                                            ? Colors.deepOrangeAccent.withOpacity(0.4)
                                                                                                                            : widget.friend.full_name[0].toUpperCase() == "Y"
                                                                                                                                ? Colors.redAccent.withOpacity(0.4)
                                                                                                                                : Colors.pinkAccent.withOpacity(0.4),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                                child: Center(
                                  child: Text(
                                    widget.friend.full_name.isNotEmpty
                                        ? widget.friend.full_name[0]
                                            .toUpperCase()
                                        : widget.friend.full_name[1]
                                            .toUpperCase(),
                                    style: TextStyle(
                                      color: widget.friend.full_name[0]
                                                  .toUpperCase() ==
                                              "A"
                                          ? Colors.red
                                          : widget.friend.full_name[0]
                                                      .toUpperCase() ==
                                                  "B"
                                              ? Colors.green
                                              : widget.friend.full_name[0]
                                                          .toUpperCase() ==
                                                      "C"
                                                  ? Colors.blue
                                                  : widget.friend.full_name[0]
                                                              .toUpperCase() ==
                                                          "D"
                                                      ? Colors.purple
                                                      : widget.friend
                                                                  .full_name[0]
                                                                  .toUpperCase() ==
                                                              "E"
                                                          ? Colors.orange
                                                          : widget.friend.full_name[0]
                                                                      .toUpperCase() ==
                                                                  "F"
                                                              ? Colors.yellow
                                                              : widget.friend
                                                                          .full_name[0]
                                                                          .toUpperCase() ==
                                                                      "G"
                                                                  ? Colors.amber
                                                                  : widget.friend.full_name[0].toUpperCase() == "H"
                                                                      ? Colors.teal
                                                                      : widget.friend.full_name[0].toUpperCase() == "I"
                                                                          ? Colors.redAccent
                                                                          : widget.friend.full_name[0].toUpperCase() == "J"
                                                                              ? Colors.lime
                                                                              : widget.friend.full_name[0].toUpperCase() == "K"
                                                                                  ? Colors.cyan
                                                                                  : widget.friend.full_name[0].toUpperCase() == "L"
                                                                                      ? Colors.indigo
                                                                                      : widget.friend.full_name[0].toUpperCase() == "M"
                                                                                          ? Colors.grey
                                                                                          : widget.friend.full_name[0].toUpperCase() == "N"
                                                                                              ? Colors.brown
                                                                                              : widget.friend.full_name[0].toUpperCase() == "O"
                                                                                                  ? Colors.cyanAccent
                                                                                                  : widget.friend.full_name[0].toUpperCase() == "P"
                                                                                                      ? Colors.lightBlueAccent
                                                                                                      : widget.friend.full_name[0].toUpperCase() == "Q"
                                                                                                          ? Colors.lightGreenAccent
                                                                                                          : widget.friend.full_name[0].toUpperCase() == "R"
                                                                                                              ? Colors.amber
                                                                                                              : widget.friend.full_name[0].toUpperCase() == "S"
                                                                                                                  ? Colors.orangeAccent
                                                                                                                  : widget.friend.full_name[0].toUpperCase() == "T"
                                                                                                                      ? Colors.amberAccent
                                                                                                                      : widget.friend.full_name[0].toUpperCase() == "W"
                                                                                                                          ? Colors.orangeAccent
                                                                                                                          : widget.friend.full_name[0].toUpperCase() == "X"
                                                                                                                              ? Colors.deepOrangeAccent
                                                                                                                              : widget.friend.full_name[0].toUpperCase() == "Y"
                                                                                                                                  ? Colors.redAccent
                                                                                                                                  : Colors.pinkAccent,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                          child: CachedNetworkImage(
                            cacheManager: CustomCacheManager.instance,
                            alignment: Alignment.center,
                            imageUrl: widget.friend.profile_image,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width / 3.2,
                            fit: BoxFit.cover,
                            placeholder: (a, b) {
                              return ShimmerWidget(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width / 3.2,
                                isCircle: true,
                              );
                            },
                          ),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.friend.full_name.length > 12
                        ? widget.friend.full_name.substring(0, 12) + "."
                        : widget.friend.full_name.length < 10
                            ? widget.friend.full_name + '         '
                            : widget.friend.full_name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                      color: Color.fromARGB(255, 83, 81, 81),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "@${widget.friend.username}",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: AppColors.normalTextColor.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black.withOpacity(0.5)),
                    child: InkWell(
                      onTap: () async {
                        try {
                          var result = await Api()
                              .removeFriendSuggesion(widget.friend.id);
                          if (result['done']) {
                            widget.remove();
                          } else {
                            debugPrint("Cannot remove friend suggestion");
                          }
                        } catch (e) {
                          debugPrint("Cannot remove friend suggestion");
                        }
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: ClipPath(
                clipper: SugestionCliper(),
                child: Container(
                  color: AppColors.scaffoldBackGroundColor,
                  height: MediaQuery.of(context).size.width / 9.5,
                  width: MediaQuery.of(context).size.width / 2.8,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 5,
              child: Center(
                child: Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width / 3,
                  child: player != null
                      ? Center(
                          child: FreiendStatusButton(
                            playerId: player.id ??
                                '', // Use a default value if id is null
                            friendStatus: player.friendStatus,
                            function: setProfileData,
                          ),
                        )
                      : Container(), // or another appropriate widget when player is null
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SugestionCliper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(size.width * -0.0016667, size.height * 0.9971429);
    path_0.lineTo(size.width * 0.0008333, size.height * 0.0028571);
    path_0.quadraticBezierTo(size.width * -0.0143750, size.height * 0.7857143,
        size.width * 0.0841667, size.height * 0.7857143);
    path_0.cubicTo(
        size.width * 0.2802083,
        size.height * 0.7875000,
        size.width * 0.7006250,
        size.height * 0.7835714,
        size.width * 0.9158333,
        size.height * 0.7842857);
    path_0.quadraticBezierTo(size.width * 1.0100000, size.height * 0.7650000,
        size.width * 0.9991667, size.height * 0.0071429);
    path_0.lineTo(size.width * 1.0033333, size.height * 0.9985714);

    path_0.close();
    return path_0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
