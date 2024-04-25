import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/controllers/friends_controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';

import 'package:play_pointz/screens/profile/profile.dart';

class FriendCard extends StatefulWidget {
  final int index;
  final bool isReques;
  bool isLoad;
  FriendCard({
    Key key,
    this.index,
    this.isReques = false,
    this.isLoad = false,
  }) : super(key: key);

  @override
  State<FriendCard> createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  final friendsController = Get.put(FriendsController());
  final userController = Get.put(UserController());
  bool shouldLoad = false;
  String loadId = '';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        String pid = "";

        if (widget.isReques) {
          if (userController.currentUser.value.id ==
              friendsController.friendRequsets[widget.index].friendshipId_1) {
            pid = friendsController.friendRequsets[widget.index].friendshipId_2;
          } else {
            pid = friendsController.friendRequsets[widget.index].friendshipId_1;
          }
        } else {
          if (userController.currentUser.value.id ==
              friendsController.friends[widget.index].friends_id_1) {
            pid = friendsController.friends[widget.index].friends_id_2;
          } else {
            pid = friendsController.friends[widget.index].friends_id_1;
          }
        }
        debugPrint("pid is $pid");
        DefaultRouter.defaultRouter(
            Profile(
              myProfile: false,
              id: pid,
              postId: "",
            ),
            context);
      },
      child: Container(
        padding: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (!widget.isReques &&
                !userController.currentUser.value.is_brand_acc)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [],
              ),
            Stack(
              children: [
                widget.isReques
                    ? friendsController
                                .friendRequsets[widget.index].profileimage
                                .toString() ==
                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width / 2 * 0.8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8))),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: friendsController
                                              .friendRequsets[widget.index]
                                              .fullName[0]
                                              .toUpperCase() ==
                                          "A"
                                      ? Colors.red.withOpacity(0.4)
                                      : friendsController
                                                  .friendRequsets[widget.index]
                                                  .fullName[0]
                                                  .toUpperCase() ==
                                              "B"
                                          ? Colors.green.withOpacity(0.4)
                                          : friendsController.friendRequsets[widget.index].fullName[0]
                                                      .toUpperCase() ==
                                                  "C"
                                              ? Colors.blue.withOpacity(0.4)
                                              : friendsController
                                                          .friendRequsets[
                                                              widget.index]
                                                          .fullName[0]
                                                          .toUpperCase() ==
                                                      "D"
                                                  ? Colors.purple
                                                      .withOpacity(0.4)
                                                  : friendsController
                                                              .friendRequsets[widget.index]
                                                              .fullName[0]
                                                              .toUpperCase() ==
                                                          "E"
                                                      ? Colors.orange.withOpacity(0.4)
                                                      : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "F"
                                                          ? Colors.yellow.withOpacity(0.2)
                                                          : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "G"
                                                              ? Colors.amber.withOpacity(0.4)
                                                              : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "H"
                                                                  ? Colors.teal.withOpacity(0.4)
                                                                  : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "I"
                                                                      ? Colors.redAccent.withOpacity(0.4)
                                                                      : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "J"
                                                                          ? Colors.lime.withOpacity(0.4)
                                                                          : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "K"
                                                                              ? Colors.cyan.withOpacity(0.4)
                                                                              : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "L"
                                                                                  ? Colors.indigo.withOpacity(0.4)
                                                                                  : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "M"
                                                                                      ? Colors.grey.withOpacity(0.4)
                                                                                      : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "N"
                                                                                          ? Colors.brown.withOpacity(0.4)
                                                                                          : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "O"
                                                                                              ? Colors.cyanAccent.withOpacity(0.4)
                                                                                              : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "P"
                                                                                                  ? Colors.lightBlueAccent.withOpacity(0.4)
                                                                                                  : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "Q"
                                                                                                      ? Colors.lightGreenAccent.withOpacity(0.4)
                                                                                                      : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "R"
                                                                                                          ? Colors.limeAccent.withOpacity(0.4)
                                                                                                          : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "S"
                                                                                                              ? Colors.yellowAccent.withOpacity(0.4)
                                                                                                              : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "T"
                                                                                                                  ? Colors.amberAccent.withOpacity(0.4)
                                                                                                                  : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "W"
                                                                                                                      ? Colors.orangeAccent.withOpacity(0.4)
                                                                                                                      : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "X"
                                                                                                                          ? Colors.deepOrangeAccent.withOpacity(0.4)
                                                                                                                          : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "Y"
                                                                                                                              ? Colors.redAccent.withOpacity(0.4)
                                                                                                                              : Colors.pinkAccent.withOpacity(0.4),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                              child: Center(
                                child: Text(
                                  friendsController.friendRequsets[widget.index]
                                          .fullName.isNotEmpty
                                      ? friendsController
                                          .friendRequsets[widget.index]
                                          .fullName[0]
                                          .toUpperCase()
                                      : friendsController
                                          .friendRequsets[widget.index]
                                          .fullName[1]
                                          .toUpperCase(),
                                  style: TextStyle(
                                    color: friendsController
                                                .friendRequsets[widget.index]
                                                .fullName[0]
                                                .toUpperCase() ==
                                            "A"
                                        ? Colors.red
                                        : friendsController.friendRequsets[widget.index].fullName[0]
                                                    .toUpperCase() ==
                                                "B"
                                            ? Colors.green
                                            : friendsController.friendRequsets[widget.index].fullName[0]
                                                        .toUpperCase() ==
                                                    "C"
                                                ? Colors.blue
                                                : friendsController
                                                            .friendRequsets[
                                                                widget.index]
                                                            .fullName[0]
                                                            .toUpperCase() ==
                                                        "D"
                                                    ? Colors.purple
                                                    : friendsController.friendRequsets[widget.index].fullName[0]
                                                                .toUpperCase() ==
                                                            "E"
                                                        ? Colors.orange
                                                        : friendsController
                                                                    .friendRequsets[widget.index]
                                                                    .fullName[0]
                                                                    .toUpperCase() ==
                                                                "F"
                                                            ? Colors.yellow
                                                            : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "G"
                                                                ? Colors.amber
                                                                : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "H"
                                                                    ? Colors.teal
                                                                    : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "I"
                                                                        ? Colors.redAccent
                                                                        : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "J"
                                                                            ? Colors.lime
                                                                            : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "K"
                                                                                ? Colors.cyan
                                                                                : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "L"
                                                                                    ? Colors.indigo
                                                                                    : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "M"
                                                                                        ? Colors.grey
                                                                                        : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "N"
                                                                                            ? Colors.brown
                                                                                            : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "O"
                                                                                                ? Colors.cyanAccent
                                                                                                : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "P"
                                                                                                    ? Colors.lightBlueAccent
                                                                                                    : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "Q"
                                                                                                        ? Colors.lightGreenAccent
                                                                                                        : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "R"
                                                                                                            ? Colors.amber
                                                                                                            : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "S"
                                                                                                                ? Colors.orangeAccent
                                                                                                                : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "T"
                                                                                                                    ? Colors.amberAccent
                                                                                                                    : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "W"
                                                                                                                        ? Colors.orangeAccent
                                                                                                                        : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "X"
                                                                                                                            ? Colors.deepOrangeAccent
                                                                                                                            : friendsController.friendRequsets[widget.index].fullName[0].toUpperCase() == "Y"
                                                                                                                                ? Colors.redAccent
                                                                                                                                : Colors.pinkAccent,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width / 2 * 0.8,
                            // padding: const EdgeInsets.all(4),
                            child: CachedNetworkImage(
                              cacheManager: CustomCacheManager.instance,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width / 5,
                              imageUrl: widget.isReques
                                  ? friendsController
                                      .friendRequsets[widget.index].profileimage
                                  : friendsController
                                      .friends[widget.index].profile_image,
                              fit: BoxFit.cover,
                            ),
                          )
                    : friendsController.friends[widget.index].profile_image
                                .toString() ==
                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width / 2 * 0.8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8))),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: friendsController.friends[widget.index]
                                              .full_name[0]
                                              .toUpperCase() ==
                                          "A"
                                      ? Colors.red.withOpacity(0.4)
                                      : friendsController.friends[widget.index]
                                                  .full_name[0]
                                                  .toUpperCase() ==
                                              "B"
                                          ? Colors.green.withOpacity(0.4)
                                          : friendsController
                                                      .friends[widget.index]
                                                      .full_name[0]
                                                      .toUpperCase() ==
                                                  "C"
                                              ? Colors.blue.withOpacity(0.4)
                                              : friendsController
                                                          .friends[widget.index]
                                                          .full_name[0]
                                                          .toUpperCase() ==
                                                      "D"
                                                  ? Colors.purple
                                                      .withOpacity(0.4)
                                                  : friendsController
                                                              .friends[widget.index]
                                                              .full_name[0]
                                                              .toUpperCase() ==
                                                          "E"
                                                      ? Colors.orange.withOpacity(0.4)
                                                      : friendsController.friends[widget.index].full_name[0].toUpperCase() == "F"
                                                          ? Colors.yellow.withOpacity(0.2)
                                                          : friendsController.friends[widget.index].full_name[0].toUpperCase() == "G"
                                                              ? Colors.amber.withOpacity(0.4)
                                                              : friendsController.friends[widget.index].full_name[0].toUpperCase() == "H"
                                                                  ? Colors.teal.withOpacity(0.4)
                                                                  : friendsController.friends[widget.index].full_name[0].toUpperCase() == "I"
                                                                      ? Colors.redAccent.withOpacity(0.4)
                                                                      : friendsController.friends[widget.index].full_name[0].toUpperCase() == "J"
                                                                          ? Colors.lime.withOpacity(0.4)
                                                                          : friendsController.friends[widget.index].full_name[0].toUpperCase() == "K"
                                                                              ? Colors.cyan.withOpacity(0.4)
                                                                              : friendsController.friends[widget.index].full_name[0].toUpperCase() == "L"
                                                                                  ? Colors.indigo.withOpacity(0.4)
                                                                                  : friendsController.friends[widget.index].full_name[0].toUpperCase() == "M"
                                                                                      ? Colors.grey.withOpacity(0.4)
                                                                                      : friendsController.friends[widget.index].full_name[0].toUpperCase() == "N"
                                                                                          ? Colors.brown.withOpacity(0.4)
                                                                                          : friendsController.friends[widget.index].full_name[0].toUpperCase() == "O"
                                                                                              ? Colors.cyanAccent.withOpacity(0.4)
                                                                                              : friendsController.friends[widget.index].full_name[0].toUpperCase() == "P"
                                                                                                  ? Colors.lightBlueAccent.withOpacity(0.4)
                                                                                                  : friendsController.friends[widget.index].full_name[0].toUpperCase() == "Q"
                                                                                                      ? Colors.lightGreenAccent.withOpacity(0.4)
                                                                                                      : friendsController.friends[widget.index].full_name[0].toUpperCase() == "R"
                                                                                                          ? Colors.limeAccent.withOpacity(0.4)
                                                                                                          : friendsController.friends[widget.index].full_name[0].toUpperCase() == "S"
                                                                                                              ? Colors.yellowAccent.withOpacity(0.4)
                                                                                                              : friendsController.friends[widget.index].full_name[0].toUpperCase() == "T"
                                                                                                                  ? Colors.amberAccent.withOpacity(0.4)
                                                                                                                  : friendsController.friends[widget.index].full_name[0].toUpperCase() == "W"
                                                                                                                      ? Colors.orangeAccent.withOpacity(0.4)
                                                                                                                      : friendsController.friends[widget.index].full_name[0].toUpperCase() == "X"
                                                                                                                          ? Colors.deepOrangeAccent.withOpacity(0.4)
                                                                                                                          : friendsController.friends[widget.index].full_name[0].toUpperCase() == "Y"
                                                                                                                              ? Colors.redAccent.withOpacity(0.4)
                                                                                                                              : Colors.pinkAccent.withOpacity(0.4),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                              child: Center(
                                child: Text(
                                  friendsController.friends[widget.index]
                                          .full_name.isNotEmpty
                                      ? friendsController
                                          .friends[widget.index].full_name[0]
                                          .toUpperCase()
                                      : friendsController
                                          .friends[widget.index].full_name[1]
                                          .toUpperCase(),
                                  style: TextStyle(
                                    color: friendsController
                                                .friends[widget.index]
                                                .full_name[0]
                                                .toUpperCase() ==
                                            "A"
                                        ? Colors.red
                                        : friendsController
                                                    .friends[widget.index]
                                                    .full_name[0]
                                                    .toUpperCase() ==
                                                "B"
                                            ? Colors.green
                                            : friendsController
                                                        .friends[widget.index]
                                                        .full_name[0]
                                                        .toUpperCase() ==
                                                    "C"
                                                ? Colors.blue
                                                : friendsController
                                                            .friends[
                                                                widget.index]
                                                            .full_name[0]
                                                            .toUpperCase() ==
                                                        "D"
                                                    ? Colors.purple
                                                    : friendsController
                                                                .friends[widget.index]
                                                                .full_name[0]
                                                                .toUpperCase() ==
                                                            "E"
                                                        ? Colors.orange
                                                        : friendsController.friends[widget.index].full_name[0].toUpperCase() == "F"
                                                            ? Colors.yellow
                                                            : friendsController.friends[widget.index].full_name[0].toUpperCase() == "G"
                                                                ? Colors.amber
                                                                : friendsController.friends[widget.index].full_name[0].toUpperCase() == "H"
                                                                    ? Colors.teal
                                                                    : friendsController.friends[widget.index].full_name[0].toUpperCase() == "I"
                                                                        ? Colors.redAccent
                                                                        : friendsController.friends[widget.index].full_name[0].toUpperCase() == "J"
                                                                            ? Colors.lime
                                                                            : friendsController.friends[widget.index].full_name[0].toUpperCase() == "K"
                                                                                ? Colors.cyan
                                                                                : friendsController.friends[widget.index].full_name[0].toUpperCase() == "L"
                                                                                    ? Colors.indigo
                                                                                    : friendsController.friends[widget.index].full_name[0].toUpperCase() == "M"
                                                                                        ? Colors.grey
                                                                                        : friendsController.friends[widget.index].full_name[0].toUpperCase() == "N"
                                                                                            ? Colors.brown
                                                                                            : friendsController.friends[widget.index].full_name[0].toUpperCase() == "O"
                                                                                                ? Colors.cyanAccent
                                                                                                : friendsController.friends[widget.index].full_name[0].toUpperCase() == "P"
                                                                                                    ? Colors.lightBlueAccent
                                                                                                    : friendsController.friends[widget.index].full_name[0].toUpperCase() == "Q"
                                                                                                        ? Colors.lightGreenAccent
                                                                                                        : friendsController.friends[widget.index].full_name[0].toUpperCase() == "R"
                                                                                                            ? Colors.amber
                                                                                                            : friendsController.friends[widget.index].full_name[0].toUpperCase() == "S"
                                                                                                                ? Colors.orangeAccent
                                                                                                                : friendsController.friends[widget.index].full_name[0].toUpperCase() == "T"
                                                                                                                    ? Colors.amberAccent
                                                                                                                    : friendsController.friends[widget.index].full_name[0].toUpperCase() == "W"
                                                                                                                        ? Colors.orangeAccent
                                                                                                                        : friendsController.friends[widget.index].full_name[0].toUpperCase() == "X"
                                                                                                                            ? Colors.deepOrangeAccent
                                                                                                                            : friendsController.friends[widget.index].full_name[0].toUpperCase() == "Y"
                                                                                                                                ? Colors.redAccent
                                                                                                                                : Colors.pinkAccent,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width / 2 * 0.8,
                            // padding: const EdgeInsets.all(4),
                            child: CachedNetworkImage(
                              cacheManager: CustomCacheManager.instance,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width / 5,
                              imageUrl: widget.isReques
                                  ? friendsController
                                      .friendRequsets[widget.index].profileimage
                                  : friendsController
                                      .friends[widget.index].profile_image,
                              fit: BoxFit.cover,
                            ),
                          ),
                Positioned(
                  right: 0,
                  child: PopupMenuButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.white, // Change the color of the icon
                      ),
                      padding: EdgeInsets.all(0),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            height: kToolbarHeight / 1.5,
                            onTap: () {
                              Future.delayed(const Duration(milliseconds: 200))
                                  .then((value) {
                                Get.dialog(AlertDialog(
                                  title: Text(
                                      "Do you want to unfriend ${friendsController.friends[widget.index].full_name} ?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        String id = userController
                                                    .currentUser.value.id ==
                                                friendsController
                                                    .friends[widget.index]
                                                    .friends_id_1
                                            ? friendsController
                                                .friends[widget.index]
                                                .friends_id_2
                                            : friendsController
                                                .friends[widget.index]
                                                .friends_id_1;
                                        await Api().removeFriend(id);
                                        Get.snackbar("",
                                            "${friendsController.friends[widget.index].full_name} unfriend succesfully");
                                        friendsController
                                            .unfriend(widget.index);
                                        Get.back();
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Yes"),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text("No"))
                                  ],
                                ));
                              });
                            },
                            child: Text("Unfriend"),
                          ),
                        ];
                      }),
                )
              ],
            ),
            Text(
              !widget.isReques
                  ? friendsController.friends[widget.index].full_name.length >
                          15
                      ? friendsController.friends[widget.index].full_name
                              .substring(0, 15) +
                          '...'
                      : friendsController.friends[widget.index].full_name
                  : friendsController
                              .friendRequsets[widget.index].fullName.length >
                          15
                      ? friendsController.friendRequsets[widget.index].fullName
                          .substring(0, 15)
                      : friendsController.friendRequsets[widget.index].fullName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Text(
              !widget.isReques
                  ? "@${friendsController.friends[widget.index].username}"
                  : "@${friendsController.friendRequsets[widget.index].username}",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
            if (widget.isReques)
              widget.isLoad
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.PRIMARY_COLOR,
                      ),
                    )
                  : MaterialButton(
                      elevation: 0,
                      color: AppColors.PRIMARY_COLOR,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      onPressed: () async {
                        setState(() {
                          widget.isLoad = true;
                        });
                        final UserController userController =
                            Get.put(UserController());

                        if (userController.currentUser.value == null) {
                          await userController.setCurrentUser();
                        }
                        String id = userController.currentUser.value.id ==
                                friendsController
                                    .friendRequsets[widget.index].friendshipId_2
                            ? friendsController
                                .friendRequsets[widget.index].friendshipId_1
                            : friendsController
                                .friendRequsets[widget.index].friendshipId_2;

                        await Api().friendRequestUpdate(id, true);
                        friendsController.confirmOrReject(widget.index,
                            accepted: true);
                      },
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height / 55,
                        ),
                      )),
          ],
        ),
      ),
    );
  }
}
