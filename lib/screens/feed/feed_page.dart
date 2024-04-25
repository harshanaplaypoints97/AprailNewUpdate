import 'dart:async';
import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:logger/logger.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Api/handle_api.dart';
import 'package:play_pointz/Shared%20Pref/player_pref.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/constants/style.dart';
import 'package:play_pointz/controllers/feed_controller.dart';
import 'package:play_pointz/controllers/profiler_controller.dart';
import 'package:play_pointz/controllers/story%20_controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/models/feed/create_post.dart';
import 'package:play_pointz/models/friends/friend_suggession_model.dart';
import 'package:play_pointz/models/get_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:play_pointz/screens/feed/components/active_item.dart';
import 'package:play_pointz/screens/feed/components/friend_suggesion_card.dart';
import 'package:play_pointz/screens/feed/components/postcard/post_card.dart';
import 'package:play_pointz/screens/friends/friends_search_results_screen.dart';
import 'package:play_pointz/screens/google_ads/feed_banner_ad.dart';
import 'package:play_pointz/screens/google_ads/inline_adaptive_banner_ads.dart';
import 'package:play_pointz/screens/shimmers/shimmer_post_list.dart';
import 'package:play_pointz/services/image_cropper/image_cropper.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import "dart:math";
import '../../controllers/coin_balance_controller.dart';
// import '../../widgets/play/quiz_card.dart';
import '../profile/profile.dart';
import '../story/mainstory.dart';
import 'CustomCacheManager.dart';
import 'components/anouncement.dart';

class FeedPage extends StatefulWidget {
  final ScrollController scrollController;

  const FeedPage({Key key, this.scrollController}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

String base64Image;
String base64Image2;
PickedFile imageFile;
var bytes;
Io.File image;

class _FeedPageState extends State<FeedPage> {
  IconData icons_unlike = Icons.thumb_up_alt_outlined;
  Color icon_unlike_Clor = AppColors.normalTextColor;
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

  bool loadingdata = false;
  String refarrallink = "";
  var data;
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

  bool isProcessing = false;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController mediaLinkController = TextEditingController();
  int offset = 0;

  bool isLoading = true;
  bool myData = false;
  bool load = false;
  bool search = false;
  bool animating = false;
  bool animatingCongrats = false;
  var profileData;

  List friendSuggestions = [];
  int x = 0;

  String current = '';

  ScrollPhysics physics = ClampingScrollPhysics();

  final Random random = Random();

  GetProfile getCustomerLoginDetails;
  final storycontroller = Get.put(StoryController());
  final userController = Get.put(UserController());
  final feedController = Get.put(FeedController());
  final profileController = ProfileController();
  CoinBalanceController coinBalanceController;
  bool coinThrow = false;
  var controller = ConfettiController();
  bool _showSearchBar = true;
  @override
  void dispose() {
    // storycontroller.dispose();

    // userController.dispose();
    // feedController.dispose();
    // coinBalanceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (userController.currentUser == null) {
      userController.setCurrentUser();
    }
    getFriends();

    super.initState();
    getCurrentTime();

    getPlayerDetails();

    if (feedController.feeds.isEmpty) {
      feedController.feeds.clear();
      getFeedPosts();
    }
    coinBalanceController = Get.put(CoinBalanceController(callback: () {
      setState(() {});
    }));
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.userScrollDirection ==
              ScrollDirection.forward ||
          widget.scrollController.position.isScrollingNotifier == false ||
          widget.scrollController.position.userScrollDirection !=
              ScrollDirection.reverse) {
        setState(() {
          _showSearchBar = true;
        });
      } else {
        setState(() {
          _showSearchBar = false;
        });
      }
    });

    widget.scrollController.addListener(scrollListner);
  }

  getCurrentTime() async {
    const oneSec = Duration(seconds: 3);
    Timer.periodic(
        oneSec,
        (Timer t) => setState(() {
              current = '';
            }));
  }

  void updateCoinBalance(int points) {
    coinBalanceController.updateCoinBalance(
      (coinBalanceController.coinBalance.value + points) / 1.0,
    );
    coinBalanceController.onInit();
    setState(() {});
  }

  void scrollListner() {
    if (!feedController.isFineshed) {
      if (widget.scrollController.offset >
          widget.scrollController.position.maxScrollExtent - 10) {
        if (!load) {
          setState(() {
            load = true;
          });
          feedController.feedReload(offset + 10).then((value) {
            setState(() {
              if (value) {
                offset += 10;
              }
              load = false;
            });
          });
        }
      }
    }
  }

  getPlayerDetails() async {
    await HandleApi().getPlayerProfileDetails();
    profileData = await getPlayerPref(key: "playerProfileDetails");

    setState(() {
      myData = true;
    });
  }

  void callBack() {
    feedController.fetchDataFromApi().then((value) => setState(() {}));
  }

  Future<void> getFeedPosts() async {
    try {
      setState(() {
        isLoading = true;
      });
      feedController.feeds.clear();
      await feedController.fetchDataFromApi();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint("get feed posts failed $e");
    }
  }

  Future<void> getFriends() async {
    try {
      var result = await Api().friendSuggesion(context);
      if (result["done"] != null) {
        if (result["done"]) {
          setState(() {
            friendSuggestions = result["body"]["friends"];
          });
          if (friendSuggestions.length > 10) {
            setState(() {
              x = 10;
            });
          } else {
            setState(() {
              x = friendSuggestions.length;
            });
          }
          print(friendSuggestions);
        } else {
          setState(() {
            // loadingdata = false;
          });
        }
      } else {
        setState(() {
          // loadingdata = false;
        });
      }
    } catch (e) {
      debugPrint("friends in body");
    }
  }

  removeFriendSuggesion(String friendId) async {
    print('removed');
    try {
      // var result = await Api().removeFriendSuggesion(friendId);
      // print(result['done']);
      // friendSuggestions

    } catch (e) {
      debugPrint("Cannot remove friend suggestion");
    }
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              // controller: widget.scrollController,
              child: ListBody(
                children: [
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
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
                      _openCamera(context);
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
  }

  bool creating = false;
  Future<void> createNewPost() async {
    if (descriptionController.text == '' && base64Image == null) {
      setState(() {
        creating = false;
      });
      messageToastRed('Description or Media is required');
    } else {
      Navigator.pop(context);
      setState(() {
        creating = true;
      });
      createPost(context: context);
      CreatePost result = await Api().createPost(
        mediaType: base64Image.toString() != null ? 'Image' : null,
        mediaUrl: base64Image.toString(),
        description: descriptionController.text,
      );

      if (result.done != null) {
        if (result.done) {
          Navigator.of(context, rootNavigator: true).pop();
          setState(() {
            creating = false;
          });
        } else {
          messageToastRed(result.message != '' || result.message != null
              ? result.message
              : 'Please Try again Later');
          Get.back();
          setState(() {
            creating = false;
          });
          // navigate();
        }
      } else {
        messageToastRed(result.message != '' || result.message != null
            ? result.message
            : 'Please Try again Later');
        Get.back();
        setState(() {
          creating = false;
        });
        // navigate();
      }
    }
    feedController.feeds.clear();

    await feedController.fetchDataFromApi();

    setState(() {
      descriptionController.clear();
      imageFile = null;
      base64Image = null;
      base64Image2 = null;
    });
  }

  ValueNotifier<bool> shouldLoad = ValueNotifier(false);
  createPost({BuildContext context}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          color: Color(0xFF536471).withOpacity(0.5),
                          iconSize: 30,
                          onPressed: () {
                            setState(() {
                              descriptionController.clear();
                              imageFile = null;
                              base64Image = null;
                              base64Image2 = null;
                            });
                            navigator.pop();
                          },
                          icon: Icon(Icons.arrow_back_outlined)),
                      Center(
                        child: Text(
                          "Create Post",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF536471)),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                DefaultRouter.defaultRouter(
                                  Profile(
                                    myProfile: true,
                                  ),
                                  context,
                                );
                              },
                              child: CachedNetworkImage(
                                cacheManager: CustomCacheManager.instance,
                                imageUrl: (profileData ??
                                        const {})['profile_image'] ??
                                    '$baseUrl/assets/images/no_profile.png',
                                imageBuilder: (context, imageProvider) => Stack(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        border: Border.all(
                                          color: Color(0xFFF2F3F5),
                                          width: 1,
                                        ),
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider ??
                                              AssetImage(
                                                  "assets/dp/blank-profile-picture-png.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    border: Border.all(
                                      color: Color(0xFFF2F3F5),
                                      width: 1,
                                    ),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/dp/error-placeholder.png"), // Replace with your error placeholder image
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    userController.currentUser.value.fullName ??
                                        "",
                                    style: TextStyle(
                                      color: Color(0xFF0F1419),
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Public",
                                        style: TextStyle(
                                          color: Color(0xFF536471),
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.public,
                                        size: 15,
                                        color: Color(0xFF536471),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 150,
                  child: ListView(
                    physics: ClampingScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        minLines: 1,
                        maxLines: 5,
                        maxLength: 400,
                        decoration: InputDecoration(
                            isDense: true,
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            labelText: "What’s Happening?"),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      if (imageFile != null)
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.file(
                                File(imageFile.path),
                                fit: BoxFit.fitHeight,
                                width: MediaQuery.of(context).size.width / 1.1,
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.width * 0.025,
                                right: MediaQuery.of(context).size.width * 0.05,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        imageFile = null;
                                        base64Image = null;
                                        base64Image2 = null;
                                      });
                                      Navigator.pop(context);
                                      createPost(context: context);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 8,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 32.0,
                              height: 32.0,
                              child: Center(
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    _showChoiceDialog(context);
                                  },
                                  icon: Icon(
                                    Icons.collections_outlined,
                                    size: 24,
                                    color: Color(0xFF536471),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 32,
                              height: 32,
                            ),
                            ///////////////////////////////////////////gift adding///////////////////////////////////////////////////
                            // SizedBox(
                            //   width: 32.0,
                            //   height: 32.0,
                            //   child: Center(
                            //     child: IconButton(
                            //       padding: EdgeInsets.all(0),
                            //       onPressed: () async {
                            //         final gif = await GiphyPicker.pickGif(
                            //           context: context,
                            //           fullScreenDialog: false,
                            //           showPreviewPage: true,
                            //           apiKey:
                            //               'jEy6L3t5Rbm2RREZbKFChQilFd0Gh6VR',
                            //           decorator: GiphyDecorator(
                            //             showAppBar: false,
                            //             searchElevation: 4,
                            //             giphyTheme: ThemeData.dark(),
                            //           ),
                            //         );
                            //         if (gif != null) {
                            //           setState(() async {
                            //             _gif = gif;
                            //             print("gift url is" +
                            //                 _gif.images.original.url);

                            //             await fetchAndConvertGif(
                            //                 _gif.images.original.url);

                            //             Api().createPost(
                            //                 mediaType: 'Image',
                            //                 description:
                            //                     descriptionController.text,
                            //                 mediaUrl: base64Image);

                            //             Navigator.pop(context);
                            //           });
                            //         }
                            //       },
                            //       icon: Icon(
                            //         Icons.gif_box_outlined,
                            //         size: 24,
                            //         color: Color(0xFF536471),
                            //       ),
                            //     ),
                            //   ),
                            // ),

                            //////////////////////////////////////////////////////////////////////////////////////////////////////////////// Stikers Adding Code Part
                            // SizedBox(
                            //   width: 32.0,
                            //   height: 32.0,
                            //   child: Center(
                            //     child: IconButton(
                            //       padding: EdgeInsets.all(0),
                            //       onPressed: () {
                            //         setState(() {
                            //           emojiShowing = !emojiShowing;
                            //         });
                            //       },
                            //       icon: Icon(
                            //         Icons.add_reaction_outlined,
                            //         size: 24,
                            //         color: Color(0xFF536471),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                            Container(
                              width: 32,
                              height: 32,
                            ),
                            Spacer(),
                            Flexible(
                              fit: FlexFit.tight,
                              flex: 1,
                              child: Row(
                                children: [
                                  const Spacer(),
                                  ValueListenableBuilder<bool>(
                                      valueListenable: shouldLoad,
                                      builder: (context, bool snapshot, _) {
                                        return MaterialButton(
                                          minWidth: kToolbarHeight,
                                          elevation: 0,
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: AppColors.PRIMARY_COLOR),
                                            borderRadius:
                                                BorderRadius.circular(28),
                                          ),
                                          onPressed: () async {
                                            if (!snapshot) {
                                              setState(() {
                                                shouldLoad.value = true;
                                              });
                                              await createNewPost();
                                              setState(() {
                                                shouldLoad.value = false;
                                              });
                                              getFeedPosts();
                                            }
                                          },
                                          child: snapshot
                                              ? SizedBox(
                                                  width: 14,
                                                  height: 14,
                                                  child: const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: AppColors
                                                          .PRIMARY_COLOR,
                                                    ),
                                                  ),
                                                )
                                              : Text(
                                                  "Post",
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .PRIMARY_COLOR),
                                                ),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<int> numList = [];

  setNumList() {
    setState(() {
      for (int i = 0; i < feedController.feeds.length ~/ 4; i++) {
        int num = random.nextInt(feedController.feeds.length - 1);
        numList.add(num);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          KeyboardDismisser(
            gestures: [
              GestureType.onTap,
              GestureType.onPanUpdateDownDirection,
              GestureType.onPanUpdateUpDirection
            ],
            /////////////////////////////////////////////////
            ///

            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: RefreshIndicator(
                onRefresh: () async {
                  if (storycontroller.offset <
                      storycontroller.StoryAllitem[0].body.count) {
                    storycontroller.loadMoreData();
                  } else {
                    Logger().e("cant load");
                    storycontroller.clear();
                    storycontroller.fetchProduct(0, 10);
                  }

                  feedController.feeds.clear();
                  await feedController.fetchDataFromApi();
                  setState(() {
                    offset = 0;
                  });
                },
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 0, bottom: 10),
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: widget.scrollController,
                    itemCount: feedController.feeds.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < feedController.feeds.length) {
                        return Column(children: [
                          index == 0
                              ? FutureBuilder(
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // While waiting for the delay, return a placeholder or loading indicator
                                      return Container(
                                        height: 120,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      // After delay, return the result of mystory()
                                      return mystory();
                                    }
                                  },
                                )
                              : Container(),

                          //  mystory() : Container(),
                          index == 0
                              ? Container(
                                  color: Colors.grey[100],
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                        key: Key('1'),
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              createPost(context: context);
                                            },
                                            child: Container(
                                              height: 140,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 0,
                                                    blurRadius: 0,
                                                    offset: Offset(0,
                                                        0), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 15),
                                              width: size.width * 0.95,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      CachedNetworkImage(
                                                        cacheManager:
                                                            CustomCacheManager
                                                                .instance,
                                                        imageUrl: (profileData ??
                                                                    const {})[
                                                                'profile_image'] ??
                                                            '$baseUrl/assets/images/no_profile.png',
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Stack(
                                                          children: [
                                                            Container(
                                                              height: 45,
                                                              width: 45,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    Colors.grey,
                                                                border:
                                                                    Border.all(
                                                                  color: Color(
                                                                      0xFFF2F3F5),
                                                                  width: 1,
                                                                ),
                                                                shape: BoxShape
                                                                    .circle,
                                                                image:
                                                                    DecorationImage(
                                                                  image: imageProvider ??
                                                                      AssetImage(
                                                                          "assets/dp/blank-profile-picture-png.png"),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Container(
                                                          height: 45,
                                                          width: 45,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.grey,
                                                            border: Border.all(
                                                              color: Color(
                                                                  0xFFF2F3F5),
                                                              width: 1,
                                                            ),
                                                            shape:
                                                                BoxShape.circle,
                                                            image:
                                                                DecorationImage(
                                                              image: AssetImage(
                                                                  "assets/dp/error-placeholder.png"), // Replace with your error placeholder image
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10,
                                                                vertical: 10),
                                                        child: Text(
                                                          "What’s Happening?",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Color(
                                                                  0xFF536471)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: size.width * 0.08,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      SizedBox(
                                                        width: 32.0,
                                                        height: 32.0,
                                                        child: Center(
                                                          child: IconButton(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            onPressed: () {
                                                              createPost(
                                                                  context:
                                                                      context);
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .collections_outlined,
                                                              size: 24,
                                                              color: Color(
                                                                  0xFF536471),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            size.width * 0.44,
                                                      ),
                                                      Container(
                                                        child: Center(
                                                          child: Text(
                                                            "Post",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Color(
                                                                    0xFFFF530D)),
                                                          ),
                                                        ),
                                                        width: 74.0,
                                                        height: 32.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: Color(
                                                                0xFFFF530D),
                                                            width: 1.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      28.0),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                )
                              : Container(),
                          feedBodyManager(feedController.feeds[index]["type"],
                              index, numList),
                        ]);
                      } else if (feedController.feeds.isEmpty) {
                        return ShimmerPostList();
                      } else {
                        return !load
                            ? Container()
                            : SpinKitThreeBounce(
                                color: AppColors.PRIMARY_COLOR,
                                size: 25,
                              );
                      }
                    }),
              ),
            ),
          ),
          // Visibility(
          //   visible: _showSearchBar,
          //   maintainAnimation: true,
          //   maintainState: true,
          //   child: AnimatedOpacity(
          //     duration: const Duration(milliseconds: 500),
          //     curve: Curves.fastOutSlowIn,
          //     opacity: _showSearchBar ? 1 : 0,
          //     child: Container(
          //       // color: Colors.transparent,
          //       color: Colors.grey[100],
          //       child: Padding(
          //         padding: const EdgeInsets.symmetric(vertical: 8),
          //         child: Row(
          //             key: Key('1'),
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               InkWell(
          //                 onTap: () {
          //                   createPost(context: context);
          //                 },
          //                 child: Container(
          //                   height: 42,
          //                   decoration: BoxDecoration(
          //                     color: Colors.white,
          //                     borderRadius: BorderRadius.circular(10.0),
          //                     boxShadow: [
          //                       BoxShadow(
          //                         color: Colors.grey.withOpacity(0.5),

          //                         spreadRadius: 1,
          //                         blurRadius: 4,
          //                         offset: Offset(
          //                             0, 3), // changes position of shadow
          //                       ),
          //                     ],
          //                   ),
          //                   padding: const EdgeInsets.symmetric(horizontal: 12),
          //                   width: size.width * 0.8,
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       Text(
          //                         "What is on your mind?",
          //                         style: AppStyles.profileLocationStyle,
          //                       ),
          //                       SizedBox(
          //                         width: 32.0,
          //                         height: 32.0,
          //                         child: Center(
          //                           child: IconButton(
          //                             padding: EdgeInsets.all(0),
          //                             onPressed: () {
          //                               createPost(context: context);
          //                             },
          //                             icon: Icon(
          //                               Icons.collections_outlined,
          //                               size: 24,
          //                               color: Colors.grey,
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //               Container(
          //                 width: 42,
          //                 height: 42,
          //                 decoration: BoxDecoration(
          //                   color: Colors.white,
          //                   borderRadius: BorderRadius.circular(10.0),
          //                   boxShadow: [
          //                     BoxShadow(
          //                       color: Colors.grey.withOpacity(0.5),
          //                       spreadRadius: 1,
          //                       blurRadius: 4,
          //                       offset:
          //                           Offset(0, 3), // changes position of shadow
          //                     ),
          //                   ],
          //                 ),
          //                 child: IconButton(
          //                   icon: Icon(
          //                     Icons.search_sharp,
          //                     size: 24,
          //                     color: Colors.grey,
          //                   ),
          //                   onPressed: () {
          //                     setState(() {
          //                       showSearch<dynamic>(
          //                         context: context,
          //                         delegate: MySearchDelegate(),
          //                       );
          //                     });
          //                   },
          //                 ),
          //               )
          //             ]),
          //       ),
          //     ),
          //   ),
          // ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: 0,
            child: ConfettiWidget(
              blastDirection: pi * 1.75,
              shouldLoop: false,
              confettiController: controller,
              blastDirectionality: BlastDirectionality.directional,
              emissionFrequency: 0,
              numberOfParticles: 30,
              minBlastForce: 1,
              maxBlastForce: 20,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            right: 0,
            child: ConfettiWidget(
              blastDirection: pi * 1.25,
              shouldLoop: false,
              confettiController: controller,
              blastDirectionality: BlastDirectionality.directional,
              emissionFrequency: 0,
              numberOfParticles: 30,
              minBlastForce: 1,
              maxBlastForce: 20,
            ),
          )
        ],
      ),
    );
  }

  Widget feedBodyManager(String type, int index, List<int> numList) {
    switch (type) {
      case announcement:
        return Anouncement(
          animating: animating,
          animatingCongrats: animatingCongrats,
          anounce: feedController.feeds[index]["model"],
          index: index,
          isFromFeed: true,
        );
      case post:
        if (userController.currentUser.value != null &&
            !userController.currentUser.value.is_brand_acc) {
          if (index % 10 == 0 && index != 0) {
            if (friendSuggestions.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Friends Suggestions",
                      style: TextStyle(
                          color: AppColors.normalTextColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          fontSize: 16.sp),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 245.h,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        scrollDirection: Axis.horizontal,
                        reverse: index % 20 == 0 ? true : false,
                        // itemCount: friends.length,
                        children: [
                          for (int i = 0; i < friendSuggestions.length; i++)
                            FriendSuggesionCard(
                              friend: FriendSuggestionModel.fromMap(
                                friendSuggestions[i],
                              ),
                              remove: () async {
                                setState(() {
                                  friendSuggestions.removeAt(i);
                                });
                              },
                            )
                        ]),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  PostCard(
                    postModel: feedController.feeds[index]["model"],
                    callbackAction: () {
                      setState(() {});
                    },
                    index: index,
                    isFromFeed: true,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              );
            }
          }
        }

        return PostCard(
          postModel: feedController.feeds[index]["model"],
          index: index,
          callbackAction: () {
            setState(() {});
          },
          isFromFeed: true,
        );

      case item:
        if (userController.currentUser.value != null &&
            !userController.currentUser.value.is_brand_acc) {
          return ActiveItem(activeItem: feedController.feeds[index]["model"]);
        }
        return Container();

      case googleAd:
        // return getRandomAdWidget(index);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: InlineAdaptiveBannerAds(
            bannerWidth: 320,
            bannerHeight: 250,
          ),
        );

      case normalAd:
        return Container(
          child: FeedBannerAD(
            ad: feedController.feeds[index]["model"],
            unitId: oneByOneAdUnitId,
            adSize: AdSize.fluid,
          ),
        );
      default:
        return Text("");
    }
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImageCropperService.pickMedia(
      cropImage: ImageCropperService.cropFreeSizeImage,
      isGallery: true,
      isProfilePicure: true,
    );
    bytes = await Io.File(pickedFile.path).readAsBytes();
    String base64Encode(List<int> bytes) => base64.encode(bytes);
    base64Image = base64Encode(bytes);

    setState(() {
      imageFile = PickedFile(pickedFile.path);
    });

    Navigator.pop(context);

    Navigator.pop(context);
    createPost(context: context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImageCropperService.pickMedia(
      cropImage: ImageCropperService.cropFreeSizeImage,
      isGallery: false,
      isProfilePicure: true,
    );
    bytes = await Io.File(pickedFile.path).readAsBytes();
    String base64Encode(List<int> bytes) => base64.encode(bytes);
    base64Image = base64Encode(bytes);
    setState(() {
      imageFile = PickedFile(pickedFile.path);
    });
    Navigator.pop(context);
    Navigator.pop(context);
    createPost(context: context);
  }
}

class MySearchDelegate extends SearchDelegate {
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
    return FriendsSearchResults(
      query: query.toLowerCase(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List n = names
        .where((name) =>
            name.toString().toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView(
      children: n.map((e) {
        if (e != "") {
          return ListTile(
            title: Text(e),
            onTap: () {
              query = e;
              showResults(context);
            },
          );
        } else {
          return SizedBox(
            width: 0,
            height: 0,
          );
        }
      }).toList(),
    );
  }
}
