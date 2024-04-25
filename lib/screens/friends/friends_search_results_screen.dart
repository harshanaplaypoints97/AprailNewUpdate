import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Shared%20Pref/player_pref.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/models/get_player_profile.dart';
import 'package:play_pointz/models/search_players.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/player_profile/friend_status_button.dart';

import 'package:play_pointz/screens/profile/profile.dart';
import 'package:play_pointz/screens/shimmers/shimmer_widget.dart';

class FriendsSearchResults extends StatefulWidget {
  final String query;
  const FriendsSearchResults({
    Key key,
    this.query,
  }) : super(key: key);

  @override
  State<FriendsSearchResults> createState() => _FriendsSearchResultsState();
}

class _FriendsSearchResultsState extends State<FriendsSearchResults> {
  BodyOfProfileData player;
  Future<void> setProfileData(int index) async {}

  bool searching = true;
  int resultCount = 0;
  List<Players> results = [];
  final TextEditingController hh = TextEditingController();
  final _key = GlobalKey<FormState>();

  final userController = Get.put(UserController());
  List<dynamic> searchRes = [];

  Future<void> setSearchResult(String search) async {
    SearchPlayer s = await Api().searchplayer(search);
    setState(() {
      searching = false;
      resultCount = s.body.count;
      results = s.body.players;
    });
  }

  @override
  void initState() {
    setSearchResult(widget.query);
    setSearch();
    super.initState();
  }

  setSearch() async {
    var search1 = await getPlayerPref(key: 'search');

    if (search1 != null && search1 != "") {
      setState(() {
        searchRes = search1["search"];
      });
    } else {
      searchRes = [];
    }

    if (searchRes.contains(widget.query)) {
      //do nothing
    } else {
      searchRes.insert(0, widget.query);
      updatePlayerPref(key: 'searched', data: {'search': searchRes});
      userController.getSearchSuggest();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            searching
                ? Center(
                    child: LinearProgressIndicator(color: Colors.orange),
                  )
                : Container(),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "$resultCount Search Results",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 45,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              primary: false,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 1, mainAxisExtent: 250),
              itemCount: results.length,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {
                      DefaultRouter.defaultRouter(
                          Profile(
                            id: results[index].id,
                            postId: "",
                            myProfile: false,
                          ),
                          context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  results[index].profileImage.toString() ==
                                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
                                      ? Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.2,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          topRight:
                                                              Radius.circular(
                                                                  8))),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: results[index]
                                                                .fullName[0]
                                                                .toUpperCase() ==
                                                            "A"
                                                        ? Colors.red
                                                            .withOpacity(0.4)
                                                        : results[index]
                                                                    .fullName[0]
                                                                    .toUpperCase() ==
                                                                "B"
                                                            ? Colors.green
                                                                .withOpacity(
                                                                    0.4)
                                                            : results[index]
                                                                        .fullName[
                                                                            0]
                                                                        .toUpperCase() ==
                                                                    "C"
                                                                ? Colors.blue
                                                                    .withOpacity(
                                                                        0.4)
                                                                : results[index].fullName[0].toUpperCase() ==
                                                                        "D"
                                                                    ? Colors
                                                                        .purple
                                                                        .withOpacity(
                                                                            0.4)
                                                                    : results[index].fullName[0].toUpperCase() == "E"
                                                                        ? Colors.orange.withOpacity(0.4)
                                                                        : results[index].fullName[0].toUpperCase() == "F"
                                                                            ? Colors.yellow.withOpacity(0.2)
                                                                            : results[index].fullName[0].toUpperCase() == "G"
                                                                                ? Colors.amber.withOpacity(0.4)
                                                                                : results[index].fullName[0].toUpperCase() == "H"
                                                                                    ? Colors.teal.withOpacity(0.4)
                                                                                    : results[index].fullName[0].toUpperCase() == "I"
                                                                                        ? Colors.redAccent.withOpacity(0.4)
                                                                                        : results[index].fullName[0].toUpperCase() == "J"
                                                                                            ? Colors.lime.withOpacity(0.4)
                                                                                            : results[index].fullName[0].toUpperCase() == "K"
                                                                                                ? Colors.cyan.withOpacity(0.4)
                                                                                                : results[index].fullName[0].toUpperCase() == "L"
                                                                                                    ? Colors.indigo.withOpacity(0.4)
                                                                                                    : results[index].fullName[0].toUpperCase() == "M"
                                                                                                        ? Colors.grey.withOpacity(0.4)
                                                                                                        : results[index].fullName[0].toUpperCase() == "N"
                                                                                                            ? Colors.brown.withOpacity(0.4)
                                                                                                            : results[index].fullName[0].toUpperCase() == "O"
                                                                                                                ? Colors.cyanAccent.withOpacity(0.4)
                                                                                                                : results[index].fullName[0].toUpperCase() == "P"
                                                                                                                    ? Colors.lightBlueAccent.withOpacity(0.4)
                                                                                                                    : results[index].fullName[0].toUpperCase() == "Q"
                                                                                                                        ? Colors.lightGreenAccent.withOpacity(0.4)
                                                                                                                        : results[index].fullName[0].toUpperCase() == "R"
                                                                                                                            ? Colors.limeAccent.withOpacity(0.4)
                                                                                                                            : results[index].fullName[0].toUpperCase() == "S"
                                                                                                                                ? Colors.yellowAccent.withOpacity(0.4)
                                                                                                                                : results[index].fullName[0].toUpperCase() == "T"
                                                                                                                                    ? Colors.amberAccent.withOpacity(0.4)
                                                                                                                                    : results[index].fullName[0].toUpperCase() == "W"
                                                                                                                                        ? Colors.orangeAccent.withOpacity(0.4)
                                                                                                                                        : results[index].fullName[0].toUpperCase() == "X"
                                                                                                                                            ? Colors.deepOrangeAccent.withOpacity(0.4)
                                                                                                                                            : results[index].fullName[0].toUpperCase() == "Y"
                                                                                                                                                ? Colors.redAccent.withOpacity(0.4)
                                                                                                                                                : Colors.pinkAccent.withOpacity(0.4),
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                                                child: Center(
                                                  child: Text(
                                                    results[index]
                                                            .fullName
                                                            .isNotEmpty
                                                        ? results[index]
                                                            .fullName[0]
                                                            .toUpperCase()
                                                        : results[index]
                                                            .fullName[0]
                                                            .toUpperCase(),
                                                    style: TextStyle(
                                                      color: results[index]
                                                                  .fullName[0]
                                                                  .toUpperCase() ==
                                                              "A"
                                                          ? Colors.red
                                                          : results[index]
                                                                      .fullName[
                                                                          0]
                                                                      .toUpperCase() ==
                                                                  "B"
                                                              ? Colors.green
                                                              : results[index]
                                                                          .fullName[
                                                                              0]
                                                                          .toUpperCase() ==
                                                                      "C"
                                                                  ? Colors.blue
                                                                  : results[index]
                                                                              .fullName[
                                                                                  0]
                                                                              .toUpperCase() ==
                                                                          "D"
                                                                      ? Colors
                                                                          .purple
                                                                      : results[index].fullName[0].toUpperCase() ==
                                                                              "E"
                                                                          ? Colors
                                                                              .orange
                                                                          : results[index].fullName[0].toUpperCase() == "F"
                                                                              ? Colors.yellow
                                                                              : results[index].fullName[0].toUpperCase() == "G"
                                                                                  ? Colors.amber
                                                                                  : results[index].fullName[0].toUpperCase() == "H"
                                                                                      ? Colors.teal
                                                                                      : results[index].fullName[0].toUpperCase() == "I"
                                                                                          ? Colors.redAccent
                                                                                          : results[index].fullName[0].toUpperCase() == "J"
                                                                                              ? Colors.lime
                                                                                              : results[index].fullName[0].toUpperCase() == "K"
                                                                                                  ? Colors.cyan
                                                                                                  : results[index].fullName[0].toUpperCase() == "L"
                                                                                                      ? Colors.indigo
                                                                                                      : results[index].fullName[0].toUpperCase() == "M"
                                                                                                          ? Colors.grey
                                                                                                          : results[index].fullName[0].toUpperCase() == "N"
                                                                                                              ? Colors.brown
                                                                                                              : results[index].fullName[0].toUpperCase() == "O"
                                                                                                                  ? Colors.cyanAccent
                                                                                                                  : results[index].fullName[0].toUpperCase() == "P"
                                                                                                                      ? Colors.lightBlueAccent
                                                                                                                      : results[index].fullName[0].toUpperCase() == "Q"
                                                                                                                          ? Colors.lightGreenAccent
                                                                                                                          : results[index].fullName[0].toUpperCase() == "R"
                                                                                                                              ? Colors.amber
                                                                                                                              : results[index].fullName[0].toUpperCase() == "S"
                                                                                                                                  ? Colors.orangeAccent
                                                                                                                                  : results[index].fullName[0].toUpperCase() == "T"
                                                                                                                                      ? Colors.amberAccent
                                                                                                                                      : results[index].fullName[0].toUpperCase() == "W"
                                                                                                                                          ? Colors.orangeAccent
                                                                                                                                          : results[index].fullName[0].toUpperCase() == "X"
                                                                                                                                              ? Colors.deepOrangeAccent
                                                                                                                                              : results[index].fullName[0].toUpperCase() == "Y"
                                                                                                                                                  ? Colors.redAccent
                                                                                                                                                  : Colors.pinkAccent,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 40,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                            cacheManager:
                                                CustomCacheManager.instance,
                                            alignment: Alignment.center,
                                            imageUrl:
                                                results[index].profileImage,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.2,
                                            fit: BoxFit.cover,
                                            placeholder: (a, b) {
                                              return ShimmerWidget(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3.2,
                                                isCircle: true,
                                              );
                                            },
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    results[index].fullName.length > 12
                                        ? results[index]
                                                .fullName
                                                .substring(0, 12) +
                                            "."
                                        : results[index].fullName.length < 10
                                            ? results[index].fullName +
                                                '         '
                                            : results[index].fullName,
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
                                    "@${results[index].username}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                        color: AppColors.normalTextColor
                                            .withOpacity(0.7)),
                                  ),
                                ],
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.end,
                            //     children: [
                            //       Container(
                            //         decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(15),
                            //             color: Colors.black.withOpacity(0.5)),
                            //         child: InkWell(
                            //           onTap: () async {
                            //             // try {
                            //             //   var result = await Api()
                            //             //       .removeFriendSuggesion(
                            //             //           results[index].id);
                            //             //   if (result['done']) {
                            //             //     widget.remove();
                            //             //   } else {
                            //             //     debugPrint(
                            //             //         "Cannot remove friend suggestion");
                            //             //   }
                            //             // } catch (e) {
                            //             //   debugPrint(
                            //             //       "Cannot remove friend suggestion");
                            //             // }
                            //           },
                            //           child: Icon(
                            //             Icons.close,
                            //             color: Colors.white,
                            //             size: 20,
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Positioned(
                              bottom: 0,
                              child: ClipPath(
                                clipper: SugestionCliper(),
                                child: Container(
                                  color: AppColors.scaffoldBackGroundColor
                                      .withOpacity(0.9),
                                  height:
                                      MediaQuery.of(context).size.width / 9.5,
                                  width:
                                      MediaQuery.of(context).size.width / 2.1,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: MediaQuery.of(context).size.width / 14,
                              child: Center(
                                child: Container(
                                    height: 30,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: results[index].id != null
                                        ? Center(
                                            child: FreiendStatusButton(
                                              playerId: results[index].id ??
                                                  '', // Use a default value if id is null
                                              friendStatus:
                                                  results[index].friendStatus,
                                              function: () async {
                                                debugPrint(
                                                    "player id is ${results[index].friendStatus}");
                                                try {
                                                  if (results[index].id !=
                                                      null) {
                                                    GetPlayerProfile
                                                        getProfile = await Api()
                                                            .getPlayersProfle(
                                                                playerId:
                                                                    results[index]
                                                                        .id);
                                                    setState(() {
                                                      player = getProfile.body;
                                                      print(
                                                          "------------------------+++++++++++++++++++++++++" +
                                                              player
                                                                  .friendStatus);
                                                    });
                                                    debugPrint(
                                                        "--------- player setted succesfully");
                                                  }
                                                } catch (e) {
                                                  debugPrint(
                                                      "set profile data failed $e");
                                                }
                                              },
                                            ),
                                          )
                                        : Container() // or another appropriate widget when player is null
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));

                //  Container(
                //   padding:
                //       EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                //   margin: const EdgeInsets.all(16),
                //   decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(6)),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       Container(
                //         width: MediaQuery.of(context).size.width / 5,
                //         height: MediaQuery.of(context).size.width / 5,
                //         decoration: BoxDecoration(
                //           shape: BoxShape.circle,
                //           border: Border.all(
                //             width: 2,
                //             color: AppColors.PRIMARY_COLOR,
                //           ),
                //         ),
                //         padding: const EdgeInsets.all(4),
                //         child: ClipOval(
                //           child: CachedNetworkImage(
                //             cacheManager: CustomCacheManager.instance,
                //             width: MediaQuery.of(context).size.width / 5,
                //             height: MediaQuery.of(context).size.width / 5,
                //             imageUrl: results[index].profileImage,
                //             fit: BoxFit.fill,
                //           ),
                //         ),
                //       ),
                //       Text(
                //         results[index].fullName,
                //         textAlign: TextAlign.center,
                //         style: TextStyle(fontSize: 12.sp),
                //       ),
                //       Flexible(
                //         child: FittedBox(
                //           child: Text(
                //             "@${results[index].username}",
                //             style: TextStyle(
                //               fontWeight: FontWeight.w400,
                //               fontSize: 8.sp,
                //             ),
                //           ),
                //         ),
                //       ),
                //       Container(
                //         height: 30,
                //         width: MediaQuery.of(context).size.width / 3,
                //         child: results[index].id != null
                //             ? Center(
                //                 child: FreiendStatusButton(
                //                   playerId: results[index].id ??
                //                       '', // Use a default value if id is null
                //                   friendStatus: results[index].friendStatus,
                //                   function: () async {
                //                     debugPrint(
                //                         "player id is ${results[index].friendStatus}");
                //                     try {
                //                       if (results[index].id != null) {
                //                         GetPlayerProfile getProfile =
                //                             await Api().getPlayersProfle(
                //                                 playerId:
                //                                     results[index].id);
                //                         setState(() {
                //                           player = getProfile.body;
                //                           print(
                //                               "------------------------+++++++++++++++++++++++++" +
                //                                   player.friendStatus);
                //                         });
                //                         debugPrint(
                //                             "--------- player setted succesfully");
                //                       }
                //                     } catch (e) {
                //                       debugPrint(
                //                           "set profile data failed $e");
                //                     }
                //                   },
                //                 ),
                //               )
                //             : Container(), // or another appropriate widget when player is null
                //       ),
                //     ],
                //   ),
                // ));
              },
            )
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
