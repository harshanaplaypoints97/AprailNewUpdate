// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io' as Io;
import 'dart:math';
import 'dart:typed_data';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Api/handle_api.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/constants/style.dart';
import 'package:play_pointz/controllers/feed_controller.dart';
import 'package:play_pointz/controllers/profile_controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/models/get_player_profile.dart';
import 'package:play_pointz/models/update_acc_images.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/feed/components/anouncement.dart';
import 'package:play_pointz/screens/feed/components/postcard/post_card.dart';
import 'package:play_pointz/screens/friends/friends_screen.dart';
import 'package:play_pointz/screens/player_profile/follow_status_button.dart';
import 'package:play_pointz/screens/player_profile/friend_status_button.dart';
import 'package:play_pointz/screens/profile/edit_profile.dart';
import 'package:play_pointz/screens/orders/my_orders.dart';
import 'package:play_pointz/screens/profile/profile_settings.dart';
import 'package:play_pointz/screens/shimmers/shimmer_profile_view.dart';
import 'package:play_pointz/screens/shimmers/shimmer_widget.dart';
import 'package:play_pointz/services/image_cropper/image_cropper.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:play_pointz/widgets/profile/profile_name.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_colors.dart';
import '../Chat/Provider/Chat_provider.dart';
import '../friends/friends_search_results_screen.dart';
import '../home/notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Edit Profile Sections/Main_edit_profile.dart';

class Profile extends StatefulWidget {
  final String id;
  final bool myProfile;
  final String postId;
  const Profile({Key key, this.id, this.myProfile, this.postId})
      : super(key: key);
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // var profileData;
  String base64Image;
  PickedFile profilImage;
  PickedFile coverImage;
  Uint8List bytes;
  Io.File image;
  bool loadingdata = false;
  bool isLoading;
  bool seeMore = false;
  int allpostcount = 0;
  // List<PostModel> data = [];
  var temp = [];
  BodyOfProfileData player = BodyOfProfileData();
  bool playerDataLoading = false;
  bool isFinished = false;
  int limit = 10;
  int postoffset = 0;
  final postScrollController = ScrollController();
  final feedcontroller = Get.put(FeedController());

  UserController userController = Get.put(UserController());
  final profileController = Get.put(ProfileController());
  // ProfileController profileController;

  @override
  void initState() {
    profileController.GetProfileFeed(
        offset: profileController.profileFeed.length ?? 0, userId: widget.id);
    setProfileData();
    //  profileController = Get.put(ProfileController(widget.id));
    //getpost();
    postScrollController.addListener(postScrollListner);
    if (userController.currentUser.value == null) {
      userController.setCurrentUser().then((value) => setState(() {}));
    }

    super.initState();
  }

  @override
  void dispose() {
    profileController.dispose();

    super.dispose();
  }

  getShortForm(int number) {
    var shortForm = "";
    if (number != null) {
      if (number < 1000) {
        shortForm = number.toString();
      } else if (number >= 1000 && number < 1000000) {
        shortForm = (number / 1000).toStringAsFixed(1) + "K";
      } else if (number >= 1000000 && number < 1000000000) {
        shortForm = (number / 1000000).toStringAsFixed(1) + "M";
      } else if (number >= 1000000000 && number < 1000000000000) {
        shortForm = (number / 1000000000).toStringAsFixed(1) + "B";
      }
    }
    return shortForm;
  }

  void postScrollListner() {
    if (!profileController.dataloading.value) {
      if (postScrollController.offset >
          postScrollController.position.maxScrollExtent - 10) {
        if (profileController.allPostsCount >
            profileController.profileFeed.length) {
          profileController.GetProfileFeed(
              offset: profileController.profileFeed.length ?? 0,
              userId: widget.id);
        }
      }
    }
  }

  void stateChanger() {
    setState(() {});
  }

  Future<void> setProfileData() async {
    try {
      if (widget.id != null) {
        setState(() {
          playerDataLoading = true;
        });
        GetPlayerProfile getProfile =
            await Api().getPlayersProfle(playerId: widget.id);
        setState(() {
          player = getProfile.body;

          playerDataLoading = false;
        });
      }
    } catch (e) {}
  }

  bool shouldLoad = false;

  Future<void> _showChoiceDialog(
    BuildContext context,
    String type,
    bool isProfilePicure,
  ) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ValueListenableBuilder(
              valueListenable: uploading,
              builder: (context, bool value, _) {
                return AlertDialog(
                  title: value
                      ? Text("Uploading")
                      : const Text(
                          "Choose option",
                          style: TextStyle(color: Colors.blue),
                        ),
                  content: value
                      ? SizedBox(
                          height: kToolbarHeight * 1.8,
                          child: const Center(
                              child: CircularProgressIndicator(
                            color: AppColors.PRIMARY_COLOR,
                          )),
                        )
                      : SingleChildScrollView(
                          child: ListBody(
                            children: [
                              const Divider(
                                height: 1,
                                color: Colors.blue,
                              ),
                              ListTile(
                                onTap: () {
                                  _openGallery(context, type, isProfilePicure);
                                },
                                title: const Text("Gallery"),
                                leading: const Icon(
                                  Icons.account_box,
                                  color: Colors.blue,
                                ),
                              ),
                              const Divider(
                                height: 1,
                                color: Colors.blue,
                              ),
                              ListTile(
                                onTap: () {
                                  _openCamera(context, type, isProfilePicure);
                                },
                                title: Text("Camera"),
                                leading: const Icon(
                                  Icons.camera,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final profileController = Get.put(ProfileController(widget.id));
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackGroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFFD1D1D1), size: 28),
        elevation: 0,
        centerTitle: true,
        leading: BackButton(),
        backgroundColor: AppColors.SCREEN_BACKGROUND_COLOR,
        title: Text(""),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_sharp,
              size: 35,
              color: Color(0xff536471),
            ),
            onPressed: () {
              showSearch<dynamic>(
                context: context,
                delegate: MySearchDelegate(),
              );
            },
          ),
          ///////////////////////////////////////////////////////////////////Profile Setings //////////////////////////////////////////////////////////
          // !userController.currentUser.value.is_brand_acc
          //     ? ElevatedButton(
          //         onPressed: () {
          //           DefaultRouter.defaultRouter(ProfileSettings(
          //             callback: () {
          //               setState(() {});
          //             },
          //           ), context);
          //         },
          //         child: Image.asset(
          //           "assets/connect_assets/config.png",
          //           height: 25,
          //           width: 25,
          //         ),
          //         style: ElevatedButton.styleFrom(
          //             shape: CircleBorder(),
          //             padding: EdgeInsets.all(5),
          //             backgroundColor: Colors.grey.shade300, // <-- Button color
          //             foregroundColor: Colors.grey, // <-- Splash color
          //             minimumSize: Size(20, 20),
          //             maximumSize: Size(35, 35)))
          //     : Container(),
          SizedBox(
            width: 7,
          ),
        ],
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: SingleChildScrollView(
            controller: postScrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 8),
                widget.myProfile
                    ? Container(
                        margin:
                            const EdgeInsets.only(left: 0, right: 0, top: 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            const Radius.circular(30),
                          ),
                        ),
                        // color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30)),
                              height: size.width * 10 / 20,
                              child: Stack(
                                children: [
                                  Center(
                                    child: CachedNetworkImage(
                                      cacheManager: CustomCacheManager.instance,
                                      placeholder: (context, url) => Image(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.2,
                                          image: AssetImage(
                                              "assets/bg/defaultcover.png")),
                                      imageUrl: userController.currentUser.value
                                                      .coverImage /* profileData['cover_image'] */ ==
                                                  '' ||
                                              userController.currentUser.value
                                                      .coverImage ==
                                                  null
                                          ? '$baseUrl/assets/images/no_cover.png'
                                          : userController
                                              .currentUser.value.coverImage,
                                      imageBuilder: (context, imageProvider) =>
                                          Stack(
                                        children: [
                                          Container(
                                            height: size.width / 2,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                              color: Colors.white,
                                              // borderRadius: BorderRadius.only(
                                              //     topLeft:
                                              //         const Radius.circular(30),
                                              //     topRight:
                                              //         const Radius.circular(
                                              //             30)),
                                            ),
                                          ),
                                          Positioned(
                                              bottom: 5,
                                              right: 5,
                                              child: InkWell(
                                                onTap: () {
                                                  print("cover is    =  " +
                                                      userController.currentUser
                                                          .value.coverImage
                                                          .toString());
                                                  _showChoiceDialog(
                                                      context, 'cover', false);
                                                },
                                                child: Container(
                                                  height: 32,
                                                  width: 32,
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(0xFFD9D9D9)),
                                                  child: Icon(
                                                    Icons.camera_alt_outlined,
                                                    size: 18,
                                                    color: Color(0xFF615F5F),
                                                  ),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 90.h, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        //Profile Image Photo
                                        Container(
                                          height: size.width / 3,
                                          width: size.width / 3,
                                          child: CachedNetworkImage(
                                            cacheManager:
                                                CustomCacheManager.instance,
                                            imageUrl: /* profileData[
                                                'profile_image'] */
                                                userController.currentUser.value
                                                        .profileImage ??
                                                    '$baseUrl/assets/images/no_profile.png',
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Stack(
                                              children: [
                                                Container(
                                                  height: size.width / 3,
                                                  width: size.width / 3,
                                                  decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                    border: Border.all(
                                                        color: Colors.orange,
                                                        width: 2),
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: imageProvider ??
                                                            AssetImage(
                                                                "assets/dp/blank-profile-picture-png.png"),
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                Positioned(
                                                    bottom: 0,
                                                    right: 10,
                                                    child: InkWell(
                                                      onTap: (() {
                                                        _showChoiceDialog(
                                                            context,
                                                            'profile',
                                                            true);
                                                      }),
                                                      child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Color(
                                                                    0xFFD9D9D9)),
                                                        child: Icon(
                                                          Icons
                                                              .camera_alt_outlined,
                                                          size: 18,
                                                          color:
                                                              Color(0xFF615F5F),
                                                        ),
                                                      ),
                                                    ))
                                              ],
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white, width: 3),
                                            shape: BoxShape.circle,
                                            // color: Colors.green
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: const Radius.circular(10),
                                      bottomRight: const Radius.circular(10))),
                              child: Column(
                                children: [
                                  !userController.currentUser.value.is_brand_acc
                                      ? profileName(
                                          name: userController
                                                  .currentUser.value.fullName ??
                                              "")
                                      : pageName(
                                          name: userController
                                                  .currentUser.value.fullName ??
                                              "",
                                          size: MediaQuery.of(context).size,
                                          verified: userController
                                              .currentUser.value.page_verified),

                                  // SizedBox(
                                  //   height: 5,
                                  // ),
                                  userController.currentUser.value.username ==
                                          null
                                      ? Container()
                                      : userLocation(
                                          name:
                                              "@${userController.currentUser.value.username}"),
                                  SizedBox(height: 2),

                                  //aditionaly adding filed................................................................................................

                                  SizedBox(
                                    height: 10,
                                  ),

                                  bioname(
                                    name: userController.currentUser.value
                                                .description ==
                                            ""
                                        ? "On a first-time visit to New Orleans, there's so much to see and do."
                                        : userController
                                            .currentUser.value.description,
                                    size: MediaQuery.of(context).size,
                                  ),

                                  ///////////////////////////////////////////////////Edit Button //////////////////////////////////////////////////////////

                                  SizedBox(height: 23),
                                  !userController.currentUser.value.is_brand_acc
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  profileBtns(
                                                      title: 'Orders',
                                                      icon:
                                                          FontAwesomeIcons.gift,
                                                      function: () {
                                                        DefaultRouter
                                                            .defaultRouter(
                                                                MyOrders(
                                                                    fromProfile:
                                                                        true,
                                                                    onPostCreate:
                                                                        () {}),
                                                                context);
                                                      }),
                                                  profileBtns(
                                                      title: 'Friends',
                                                      icon: FontAwesomeIcons
                                                          .users,
                                                      function: () {
                                                        DefaultRouter
                                                            .defaultRouter(
                                                                FriendsScreen(
                                                                    activeIndex:
                                                                        0),
                                                                context);
                                                      }),
                                                  profileBtns(
                                                      title: 'Notifications',
                                                      icon: FontAwesomeIcons
                                                          .solidBell,
                                                      function: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (cntx) =>
                                                                  Notifications()),
                                                        );
                                                      }),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 15),

                                            ///ANOTHER Row
                                            !userController.currentUser.value
                                                    .is_brand_acc
                                                ? SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        profileBtn(
                                                            title: 'Posts',
                                                            count:
                                                                profileController
                                                                    .allPostsCount
                                                                    .toString(),
                                                            function: () {}),
                                                        profileBtn(
                                                            title: 'Friends',
                                                            count: userController
                                                                .currentUser
                                                                .value
                                                                .totalFriends
                                                                .toString(),
                                                            function: () {
                                                              DefaultRouter.defaultRouter(
                                                                  FriendsScreen(
                                                                      activeIndex:
                                                                          0),
                                                                  context);
                                                            }),
                                                        profileBtn(
                                                            title: 'Pointz',
                                                            count:
                                                                userController
                                                                    .currentUser
                                                                    .value
                                                                    .points
                                                                    .toString(),
                                                            function: () {
                                                              // DefaultRouter.defaultRouter(
                                                              //     FriendsScreen(
                                                              //         activeIndex:
                                                              //             0),
                                                              //     context);
                                                            }),
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox()
                                          ],
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      DefaultRouter.defaultRouter(
                                        EditProfile(
                                          callback: () {
                                            setState(() {});
                                          },
                                        ),
                                        context,
                                      );
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 30,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            const Radius.circular(8.0)),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFFF530D),
                                            Color(0xFFFF960C),
                                            Color(0xFFFF960C)
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Edit',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.005,
                            )
                          ],
                        ),
                      )

                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    : playerDataLoading
                        ? ShimmerProfile()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // padding: EdgeInsets.all(16),
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height / 2.60 -
                                        (userController
                                                .currentUser.value.is_brand_acc
                                            ? 32
                                            : 0),
                                //  color: Colors.red,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            left: 0,
                                            child: CachedNetworkImage(
                                              cacheManager:
                                                  CustomCacheManager.instance,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 160.h,
                                              imageUrl: player.coverImage,
                                              fit: BoxFit.fitWidth,
                                              placeholder: (context, url) =>
                                                  ShimmerWidget(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                isCircle: false,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.6,
                                              ),
                                              errorWidget: (a, b, c) {
                                                return Container(
                                                    decoration: BoxDecoration(),
                                                    child: Image.asset(
                                                      'assets/bg/cover.png',
                                                      fit: BoxFit.fill,
                                                    ));
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            top: 100,
                                            bottom: 0,
                                            right: 0,
                                            left: 0,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors
                                                        .scaffoldBackGroundColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Hero(
                                                      tag: widget.postId ??
                                                          "asdsad${Random().nextInt(15000)}",
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: AppColors
                                                                .PRIMARY_COLOR,
                                                            width: 3,
                                                          ),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          child:
                                                              CachedNetworkImage(
                                                            cacheManager:
                                                                CustomCacheManager
                                                                    .instance,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                4,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                4,
                                                            imageUrl: player
                                                                .profileImage,
                                                            fit: BoxFit.fill,
                                                            errorWidget:
                                                                (a, b, c) {
                                                              return Column(
                                                                children: [
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        4,
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        4,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(8),
                                                                            topRight: Radius.circular(8))),
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          color: player.fullName[0].toUpperCase() == "A"
                                                                              ? Colors.red.withOpacity(0.4)
                                                                              : player.fullName[0].toUpperCase() == "B"
                                                                                  ? Colors.green.withOpacity(0.4)
                                                                                  : player.fullName[0].toUpperCase() == "C"
                                                                                      ? Colors.blue.withOpacity(0.4)
                                                                                      : player.fullName[0].toUpperCase() == "D"
                                                                                          ? Colors.purple.withOpacity(0.4)
                                                                                          : player.fullName[0].toUpperCase() == "E"
                                                                                              ? Colors.orange.withOpacity(0.4)
                                                                                              : player.fullName[0].toUpperCase() == "F"
                                                                                                  ? Colors.yellow.withOpacity(0.2)
                                                                                                  : player.fullName[0].toUpperCase() == "G"
                                                                                                      ? Colors.amber.withOpacity(0.4)
                                                                                                      : player.fullName[0].toUpperCase() == "H"
                                                                                                          ? Colors.teal.withOpacity(0.4)
                                                                                                          : player.fullName[0].toUpperCase() == "I"
                                                                                                              ? Colors.redAccent.withOpacity(0.4)
                                                                                                              : player.fullName[0].toUpperCase() == "J"
                                                                                                                  ? Colors.lime.withOpacity(0.4)
                                                                                                                  : player.fullName[0].toUpperCase() == "K"
                                                                                                                      ? Colors.cyan.withOpacity(0.4)
                                                                                                                      : player.fullName[0].toUpperCase() == "L"
                                                                                                                          ? Colors.indigo.withOpacity(0.4)
                                                                                                                          : player.fullName[0].toUpperCase() == "M"
                                                                                                                              ? Colors.grey.withOpacity(0.4)
                                                                                                                              : player.fullName[0].toUpperCase() == "N"
                                                                                                                                  ? Colors.brown.withOpacity(0.4)
                                                                                                                                  : player.fullName[0].toUpperCase() == "O"
                                                                                                                                      ? Colors.cyanAccent.withOpacity(0.4)
                                                                                                                                      : player.fullName[0].toUpperCase() == "P"
                                                                                                                                          ? Colors.lightBlueAccent.withOpacity(0.4)
                                                                                                                                          : player.fullName[0].toUpperCase() == "Q"
                                                                                                                                              ? Colors.lightGreenAccent.withOpacity(0.4)
                                                                                                                                              : player.fullName[0].toUpperCase() == "R"
                                                                                                                                                  ? Colors.limeAccent.withOpacity(0.4)
                                                                                                                                                  : player.fullName[0].toUpperCase() == "S"
                                                                                                                                                      ? Colors.yellowAccent.withOpacity(0.4)
                                                                                                                                                      : player.fullName[0].toUpperCase() == "T"
                                                                                                                                                          ? Colors.amberAccent.withOpacity(0.4)
                                                                                                                                                          : player.fullName[0].toUpperCase() == "W"
                                                                                                                                                              ? Colors.orangeAccent.withOpacity(0.4)
                                                                                                                                                              : player.fullName[0].toUpperCase() == "X"
                                                                                                                                                                  ? Colors.deepOrangeAccent.withOpacity(0.4)
                                                                                                                                                                  : player.fullName[0].toUpperCase() == "Y"
                                                                                                                                                                      ? Colors.redAccent.withOpacity(0.4)
                                                                                                                                                                      : Colors.pinkAccent.withOpacity(0.4),
                                                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          player.fullName.isEmpty
                                                                              ? player.fullName[0].toUpperCase()
                                                                              : player.fullName[0].toUpperCase(),
                                                                          style:
                                                                              TextStyle(
                                                                            color: player.fullName[0].toUpperCase() == "A"
                                                                                ? Colors.red
                                                                                : player.fullName[0].toUpperCase() == "B"
                                                                                    ? Colors.green
                                                                                    : player.fullName[0].toUpperCase() == "C"
                                                                                        ? Colors.blue
                                                                                        : player.fullName[0].toUpperCase() == "D"
                                                                                            ? Colors.purple
                                                                                            : player.fullName[0].toUpperCase() == "E"
                                                                                                ? Colors.orange
                                                                                                : player.fullName[0].toUpperCase() == "F"
                                                                                                    ? Colors.yellow
                                                                                                    : player.fullName[0].toUpperCase() == "G"
                                                                                                        ? Colors.amber
                                                                                                        : player.fullName[0].toUpperCase() == "H"
                                                                                                            ? Colors.teal
                                                                                                            : player.fullName[0].toUpperCase() == "I"
                                                                                                                ? Colors.redAccent
                                                                                                                : player.fullName[0].toUpperCase() == "J"
                                                                                                                    ? Colors.lime
                                                                                                                    : player.fullName[0].toUpperCase() == "K"
                                                                                                                        ? Colors.cyan
                                                                                                                        : player.fullName[0].toUpperCase() == "L"
                                                                                                                            ? Colors.indigo
                                                                                                                            : player.fullName[0].toUpperCase() == "M"
                                                                                                                                ? Colors.grey
                                                                                                                                : player.fullName[0].toUpperCase() == "N"
                                                                                                                                    ? Colors.brown
                                                                                                                                    : player.fullName[0].toUpperCase() == "O"
                                                                                                                                        ? Colors.cyanAccent
                                                                                                                                        : player.fullName[0].toUpperCase() == "P"
                                                                                                                                            ? Colors.lightBlueAccent
                                                                                                                                            : player.fullName[0].toUpperCase() == "Q"
                                                                                                                                                ? Colors.lightGreenAccent
                                                                                                                                                : player.fullName[0].toUpperCase() == "R"
                                                                                                                                                    ? Colors.amber
                                                                                                                                                    : player.fullName[0].toUpperCase() == "S"
                                                                                                                                                        ? Colors.orangeAccent
                                                                                                                                                        : player.fullName[0].toUpperCase() == "T"
                                                                                                                                                            ? Colors.amberAccent
                                                                                                                                                            : player.fullName[0].toUpperCase() == "W"
                                                                                                                                                                ? Colors.orangeAccent
                                                                                                                                                                : player.fullName[0].toUpperCase() == "X"
                                                                                                                                                                    ? Colors.deepOrangeAccent
                                                                                                                                                                    : player.fullName[0].toUpperCase() == "Y"
                                                                                                                                                                        ? Colors.redAccent
                                                                                                                                                                        : Colors.pinkAccent,
                                                                            fontStyle:
                                                                                FontStyle.normal,
                                                                            fontSize:
                                                                                40,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            !player.is_brand_acc
                                                ? profileName(
                                                    name: player.fullName)
                                                : pageName(
                                                    name: player.fullName,
                                                    size: MediaQuery.of(context)
                                                        .size,
                                                    verified:
                                                        player.page_verified),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            userLocation(
                                                name: "@${player.username}" +
                                                    (player.is_brand_acc &&
                                                            player.page_category !=
                                                                null
                                                        ? " (${player.page_category})"
                                                        : '')),
                                            const SizedBox(
                                              height: 8,
                                            ),

                                            bioname(
                                              name:
                                                  //       // String url = player.web
                                                  player.description ??
                                                      "On a first-time visit to New Orleans, there's so much to see and do.",
                                              size: MediaQuery.of(context).size,
                                            ),

                                            // FreiendStatusButton(
                                            //   playerId: player.id,
                                            //   friendStatus: player.friendStatus,
                                            //   function: setProfileData,
                                            // ),

                                            // : Text('follow')
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              !player.is_brand_acc
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          profileBtn(
                                              title: 'Posts',
                                              count:
                                                  player.totalPosts.toString(),
                                              function: () {}),
                                          profileBtn(
                                              title: 'Friends',
                                              count: player.totalFriends
                                                  .toString(),
                                              function: () {}),
                                          profileBtn(
                                              title: 'Pointz',
                                              count: player.show_point_count
                                                  ? player.points.toString() ==
                                                          'null'
                                                      ? '0'
                                                      : getShortForm(
                                                          player.points)
                                                  : '##',
                                              function: () {}),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.width /
                                                12,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: FreiendStatusButton(
                                          playerId: player.id,
                                          friendStatus: player.friendStatus,
                                          function: setProfileData,
                                        ),
                                      ),
                                    ),
                                  ),
                                  player.friendStatus.toString() == "Friend"
                                      ? Consumer<ChatProvider>(
                                          builder: (context, value, child) =>
                                              TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.green,

                                              padding: EdgeInsets.all(
                                                  8), // Remove default padding
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                            ),
                                            onPressed: () {
                                              value.statrCreateConvercation(
                                                  context,
                                                  userController
                                                      .currentUser.value.id,
                                                  player.id,
                                                  1,
                                                  player.profileImage,
                                                  player.fullName,
                                                  userController.currentUser
                                                      .value.profileImage,
                                                  userController.currentUser
                                                      .value.fullName,
                                                  "");
                                            },
                                            child: value.loadingindex == 1
                                                ? CircularPercentIndicator()
                                                : Text(
                                                    "Chat",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                              player.is_brand_acc
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          player.web == null &&
                                                  player.contact_no == null
                                              ? Container()
                                              : Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 16),
                                                  child: Wrap(
                                                    spacing: 12,
                                                    runSpacing: 12,
                                                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    alignment:
                                                        WrapAlignment.center,
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    runAlignment:
                                                        WrapAlignment.center,
                                                    children: [
                                                      if (player.contact_no !=
                                                          null)
                                                        InkWell(
                                                          onTap: () => launch(
                                                              "tel://${player.contact_no}"),
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                              children: [
                                                                WidgetSpan(
                                                                  alignment:
                                                                      PlaceholderAlignment
                                                                          .middle,
                                                                  child: Icon(
                                                                    Icons.phone,
                                                                    size: 24.sp,
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                    text: ' '),
                                                                TextSpan(
                                                                    text: player
                                                                        .contact_no,
                                                                    style: TextStyle(
                                                                        color: Colors.grey[
                                                                            600],
                                                                        fontSize:
                                                                            14))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      if (player.web != null)
                                                        InkWell(
                                                          onTap: () async {
                                                            String url = player
                                                                    .web
                                                                    .contains(
                                                                        "http")
                                                                ? player.web
                                                                : "https://${player.web}";
                                                            Uri uri =
                                                                Uri.parse(url);
                                                            if (await canLaunchUrl(
                                                                uri)) {
                                                              await launchUrl(
                                                                  uri);
                                                            } else {
                                                              messageToastGreen(
                                                                  'Could not launch ${player.web}');
                                                            }
                                                          },
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                              children: [
                                                                WidgetSpan(
                                                                  alignment:
                                                                      PlaceholderAlignment
                                                                          .middle,
                                                                  child: Icon(
                                                                    FontAwesomeIcons
                                                                        .globe,
                                                                    size: 22.sp,
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                    text: ' '),
                                                                TextSpan(
                                                                    text: player
                                                                        .web,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                      fontSize:
                                                                          14,
                                                                      // decoration: TextDecoration.underline
                                                                    ))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      if (player.address !=
                                                              null &&
                                                          player.address != '')
                                                        RichText(
                                                          textAlign:
                                                              TextAlign.center,
                                                          text: TextSpan(
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                            children: [
                                                              WidgetSpan(
                                                                alignment:
                                                                    PlaceholderAlignment
                                                                        .middle,
                                                                child: Icon(
                                                                  Icons
                                                                      .location_on_outlined,
                                                                  size: 24.sp,
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                  text: ' '),
                                                              TextSpan(
                                                                  text: player
                                                                      .address,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                      fontSize:
                                                                          14))
                                                            ],
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                )
                                        ],
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(children: [
                                        // SizedBox(
                                        //   height: 20.h,
                                        //   child: Row(
                                        //     children: [
                                        //       Icon(
                                        //         Icons.image_outlined,
                                        //         color:
                                        //             AppColors.normalTextColor,
                                        //       ),
                                        //       const SizedBox(
                                        //         width: 8,
                                        //       ),
                                        //       Text(
                                        //         player.totalPosts == null
                                        //             ? "0 Posts"
                                        //             : player.totalPosts
                                        //                     .toString() +
                                        //                 // myFeed.length.toString() +
                                        //                 ' Posts',
                                        //         style: AppStyles
                                        //             .profilePageTextSty01,
                                        //       )
                                        //     ],
                                        //   ),
                                        // ),
                                        // player.show_answer_count
                                        //     ? Container(
                                        //         margin: const EdgeInsets.only(
                                        //             top: 12),
                                        //         height: 20.h,
                                        //         child: Row(
                                        //           children: [
                                        //             Icon(
                                        //               Icons.done_all,
                                        //               color: AppColors
                                        //                   .normalTextColor,
                                        //               size: 24,
                                        //             ),
                                        //             const SizedBox(
                                        //               width: 8,
                                        //             ),
                                        //             Text(
                                        //               "${player.correctAnswers} Correct Answers",
                                        //               style: AppStyles
                                        //                   .profilePageTextSty01,
                                        //             )
                                        //           ],
                                        //         ),
                                        //       )
                                        //     : Container(
                                        //         height: 0,
                                        //       ),
                                      ]),
                                    ),
                              player.is_private &&
                                      player.friendStatus != 'Friend'
                                  ? Card(
                                      margin: const EdgeInsets.all(10),
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        child: Row(
                                          children: [
                                            Icon(FontAwesomeIcons.userShield,
                                                color: AppColors
                                                    .PRIMARY_COLOR_LIGHT),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  player.username +
                                                      ' locked ' +
                                                      (player.gender == 'male'
                                                          ? 'his'
                                                          : 'her') +
                                                      ' Profile.',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            105,
                                                    child: Text('Only ' +
                                                        (player.gender == 'male'
                                                            ? 'his'
                                                            : 'her') +
                                                        ' friends can see what ' +
                                                        (player.gender == 'male'
                                                            ? 'he'
                                                            : 'she') +
                                                        ' shares on ' +
                                                        (player.gender == 'male'
                                                            ? 'his'
                                                            : 'her') +
                                                        ' profile.')),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(8.0),
                                      margin: const EdgeInsets.only(bottom: 0),
                                      child: Text(
                                        player.is_brand_acc ? "" : "",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                SizedBox(
                  height: size.width * 0.01,
                ),
                Divider(
                    color: Color(0xFF929191).withOpacity(0.1),
                    indent: 1,
                    thickness: 1),
                // Container(
                //     alignment: Alignment.centerLeft,
                //     width: size.width * 0.95,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(6),
                //       color: Colors.white,
                //     ),
                //     child: Padding(
                //       padding: const EdgeInsets.all(10),
                //       child: Text("Recent posts",
                //           style: GoogleFonts.lato(
                //               textStyle: TextStyle(
                //             color: AppColors.normalTextColor.withOpacity(0.8),
                //             fontSize: 20,
                //             fontWeight: FontWeight.w700,
                //           ))),
                //     )),
                profileController.profileFeed != null
                    ? profileController.profileFeed.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 32),
                            child: Text("No posts Available"),
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            primary: false,
                            shrinkWrap: true,
                            itemCount: profileController.profileFeed.length,
                            itemBuilder: (context, index) {
                              return profileController.profileFeed[index]
                                          ["type"] ==
                                      'post'
                                  ? PostCard(
                                      fromNotification: false,
                                      postModel: profileController
                                          .profileFeed[index]["model"],
                                      index: index,
                                      callbackAction: () {
                                        setState(() {});
                                      },
                                      isFromFeed: false,
                                      profileController: profileController,
                                      updatePost: () {
                                        // profileController.profileFeed.clear();
                                        profileController.GetProfileFeed(
                                            offset: 0, userId: widget.id);
                                      })
                                  : profileController.profileFeed[index]
                                              ["type"] ==
                                          'announcement'
                                      ? Anouncement(
                                          animating: false,
                                          animatingCongrats: false,
                                          index: index,
                                          isFromFeed: false,
                                          //profileController: profileController,
                                          anounce: profileController
                                              .profileFeed[index]["model"],
                                        )
                                      : Container();
                            })
                    : LinearProgressIndicator()
              ],
            ),
          ),
        );
      }),
    );
  }

  ValueNotifier<bool> uploading = ValueNotifier(false);
  void _openGallery(
      BuildContext context, String type, bool isProfilePicure) async {
    final pickedFile = await ImageCropperService.pickMedia(
      cropImage: ImageCropperService.cropSquareImage,
      isGallery: true,
      isProfilePicure: isProfilePicure,
    );
    bytes = await Io.File(pickedFile.path).readAsBytes();
    String base64Encode(List<int> bytes) => base64.encode(bytes);
    base64Image = base64Encode(bytes);

    if (type == 'profile') {
      setState(() {
        uploading.value = true;
      });
      UpdateAccImages result =
          await Api().setProfileImages(type, base64Image.toString());

      if (result.done != null && result.done) {
        setState(() {
          profilImage = PickedFile(pickedFile.path);
          /*  profileData['profile_image'] */ userController
              .currentUser.value.profileImage = result.body.url;
          HandleApi().getPlayerProfileDetails();
        });
      }
    } else if (type == 'cover') {
      setState(() {
        uploading.value = true;
      });
      UpdateAccImages result =
          await Api().setCoverImages(type, base64Image.toString());
      if (result.done != null && result.done) {
        setState(() {
          coverImage = PickedFile(pickedFile.path);
          userController.currentUser.value.coverImage = result.body.url;
          HandleApi().getPlayerProfileDetails();
        });
      }
    } else {
      coverImage = coverImage;
    }
    setState(() {
      uploading.value = false;
    });
    Navigator.pop(context);
    //Navigator.pop(context);
  }

  void _openCamera(
      BuildContext context, String type, bool isProfilePicure) async {
    final pickedFile = await ImageCropperService.pickMedia(
      cropImage: ImageCropperService.cropSquareImage,
      isGallery: false,
      isProfilePicure: isProfilePicure,
    );
    bytes = await Io.File(pickedFile.path).readAsBytes();
    String base64Encode(List<int> bytes) => base64.encode(bytes);
    base64Image = base64Encode(bytes);
    if (type == 'profile') {
      setState(() {
        uploading.value = true;
      });
      UpdateAccImages result = await Api().setProfileImages(type, base64Image);

      if (result.done != null && result.done) {
        setState(() {
          profilImage = PickedFile(pickedFile.path);
          userController.currentUser.value.profileImage = result.body.url;
          HandleApi().getPlayerProfileDetails();
        });
      }
    } else if (type == 'cover') {
      setState(() {
        uploading.value = true;
      });
      UpdateAccImages result = await Api().setCoverImages(type, base64Image);
      if (result.done != null && result.done) {
        setState(() {
          coverImage = PickedFile(pickedFile.path);
          userController.currentUser.value.coverImage = result.body.url;
          HandleApi().getPlayerProfileDetails();
        });
      }
    } else {
      coverImage = coverImage;
    }
    setState(() {
      uploading.value = false;
    });
    Navigator.pop(context);
  }
}

class MySearchDelegate extends SearchDelegate {
  @override
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
          // filled: true,
          // fillColor: Color(0xffC4C4C4),
          hintStyle: TextStyle(
              color: Color(
                0xff474747,
              ),
              fontSize: 18),
          labelStyle: TextStyle(color: Colors.red),
        ),
        primaryColor: Colors.grey[50],
        appBarTheme: theme.appBarTheme.copyWith(
          elevation: 0, // Set your desired elevation here
          color: AppColors.scaffoldBackGroundColor,
          // Set your desired color here
        ),
        textTheme: TextTheme(
            headline6: TextStyle(
                color: Color(
                  0xff474747,
                ),
                fontSize: 18)));
  }

  final userController = Get.put(UserController());
  List get names => userController.search.map((post) {
        return post;
      }).toList();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query == "" ? close(context, null) : query = "";
        },
        icon: const Icon(
          Icons.clear,
        ),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        } else {
          query = "";
        }
      },
      icon: const Icon(
        Icons.arrow_back,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Set elevation to 0.0 to remove shadow
    return FriendsSearchResults(
      query: query.toLowerCase(),
    );
  }

  Widget buildSearchBar(BuildContext context) {
    // Customizing the search text field style with a border, input text color, and size
    return TextField(
      style: TextStyle(
          color: Colors.blue,
          fontSize: 16.0), // Set your desired text color and size
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.red, // Set your desired border color
            width: 2.0, // Set your desired border width
          ),
        ),
        hintText: 'Search...',
        hintStyle: TextStyle(color: Colors.red),
        filled: true,
        fillColor: Color(0xffC4C4C4),
      ),
      onChanged: (value) {
        query = value;
        // Implement any additional logic based on search query changes
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List n = names
        .where((name) =>
            name.toString().toLowerCase().contains(query.toLowerCase()))
        .toList();
    // Set elevation to 0.0 to remove shadow
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(10.0), // Set your desired border radius here
        color: Colors.grey[200], // Set your desired background color here
      ),
      child: ListView(
        children: n.map((e) {
          if (e != "") {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  if (n.indexOf(e) ==
                      0) // Display "Recent" only for the first item
                    Text(
                      "Recent",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Color(0xff808080)),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      query = e;
                      showResults(context);
                    },
                    child: Container(
                      color: Color(0xffF5F5F5),
                      height: 25,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time_outlined,
                              color: Color(0xffABABAB),
                              size: 20,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              e,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: Color(0xffABABAB)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return SizedBox(
              width: 0,
              height: 0,
            );
          }
        }).toList(),
      ),
    );
  }
}
