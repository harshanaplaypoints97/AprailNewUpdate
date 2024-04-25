// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:play_pointz/Animations/celebration_popup_ani.dart';
import 'package:play_pointz/Api/handle_api.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/controllers/coin_balance_controller.dart';
import 'package:play_pointz/controllers/notification_controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/models/firstloginpoints.dart';
import 'package:play_pointz/models/home/UnReadNoti.dart';
import 'package:play_pointz/models/home/popup_banner.dart';
import 'package:play_pointz/screens/Chat/Screens/Main_Chat_Screen.dart';
import 'package:play_pointz/screens/connect/connect.dart';
import 'package:play_pointz/screens/feed/feed_page.dart';
import 'package:play_pointz/screens/home/notifications.dart';
import 'package:play_pointz/screens/new_login/new_login_screen.dart';
import 'package:play_pointz/screens/play/play_new.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:play_pointz/services/daily_reward/daily_reward_service.dart';
import 'package:play_pointz/services/firebase_service.dart';
import 'package:play_pointz/store/store.dart';
import 'package:play_pointz/widgets/common/app_bar.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import '../../Api/Api.dart';
import '../../models/check_plyer_login.dart';
import '../../widgets/common/toast.dart';
import '../profile/settings.dart';

class HomePage extends StatefulWidget {
  final int activeIndex;
  final bool fromRegisterPage;
  const HomePage({Key key, this.fromRegisterPage = false, this.activeIndex})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();
  final facebookAppEvents = FacebookAppEvents();
  String current = "";

  int _selectedIndex = 0;
  String points;
  bool dataLoading = true;
  bool isBannedUser = false;
  TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  //set current user
  final userController = Get.put(UserController());

  String messageTitle = "Empty";
  String notificationAlert = "alert";
  String deviceId = '';

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  setHome() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
  }

  setupFlutterNotifications() async {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Platform.isAndroid
          ? Get.snackbar(
              message.notification.title,
              message.notification.body,
              icon: Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  top: 0,
                  right: 4,
                ),
                child: Image.asset(
                  "assets/logos/playpointz_icon_round_corners.png",
                ),
              ),
              duration: Duration(seconds: 7),
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              padding: EdgeInsets.all(8),
              backgroundColor: Colors.white.withOpacity(0.9),
              colorText: Colors.black,
            )
          : null;

      if (message.notification != null) {}
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {});
    });
  }

  getDeviceId() async {
    String devId = await PlatformDeviceId.getDeviceId;
    setState(() {
      deviceId = devId;
    });
  }

  getplayers() async {
    await HandleApi().getPlayerSearch(context);
  }

  void showFirstConWinDialog() async {
    if (widget.fromRegisterPage) {
      SendUser().saveDeviceToken("id");
      FistLoginPoints result = await Api().getfirstloginpoints();
      CelebrationPopupAni()
          .FirstLogin(context, result.body.joinPoints.toString());
      final audio = AudioPlayer();
      audio.play(AssetSource("audio/winpopup.mp3"));
    }
  }

  Future<void> checkplayer() async {
    await getDeviceId();
    String _fcmToken = await _firebaseMessaging.getToken();
    CheckPlayerLogin result = await Api().playerLoginCheck(
        deviceId: deviceId, version: thisVersion, fcm: _fcmToken);
    if (result.done != null) {
      if (result.done) {
        setState(() {
          isBannedUser = result.body.isBlocked;
        });
        // cheking user is banned!
        if (isBannedUser) {
          Get.off(() => NewLoginScreen());
          Get.snackbar("ACCOUNT IS BANNED!!! ", "Your account is Banned",
              icon: Icon(Icons.person, color: Colors.red.shade400),
              colorText: Colors.red,
              backgroundColor: Colors.white);
        }
        // userController.isBandedUser.value = result.body.isBlocked;
      } else {
        debugPrint(
            "--------------------------------- player checking result is false");
      }
    } else {
      messageToastRed(result.message);
      debugPrint(
          "---------------------------------------- player checking result is null");
    }
  }

  bool connecting = false;
  CoinBalanceController coinBalanceController;
  NotificationController notificationController;
  String unreadNotifications = "";

  void updateNotificationSocket() async {
    UnReadNotiCount res = await Api().getUnReadNotificationCount();
    if (res.body.count != null) {}
    setState(() {
      unreadNotifications = res.body.count;
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void initState() {
    setupFlutterNotifications();

    // _notification();
    setState(() {
      _selectedIndex = widget.activeIndex;
    });
    coinBalanceController = Get.put(CoinBalanceController(callback: () {
      debugPrint(
          "+++++++++++++++++++++++++ controller from paly widget called");
      setState(() {});
    }));
    checkplayer();
    showFirstConWinDialog();
    if (coinBalanceController.coinBalance.value == 0) {
      Future.delayed(const Duration(seconds: 4))
          .then((value) => setState(() {}));
      Future.delayed(const Duration(seconds: 3))
          .then((value) => setState(() {}));
      Future.delayed(const Duration(seconds: 2))
          .then((value) => setState(() {}));
      Future.delayed(const Duration(seconds: 1))
          .then((value) => setState(() {}));
    }

    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      initSocket();
      DailyRewardService().dailyRewardController(context, coinBalanceController,
          () {
        setState(() {});
        showLatePopup();
      });
    });
  }

  showLatePopup() async {
    PopUpData data = await Api().getlatePopUp();
    if (data.done) {
      if (data.body != null) {
        loadPopup(data.body.image_url, data.body.id);
      }
    }
  }

  void resetScrollFeed() {
    scrollController.animateTo(0,
        duration: Duration(milliseconds: 1000), curve: Curves.fastOutSlowIn);
  }

  initSocket() {
    try {
      if (!socket.connected) {
        if (!connecting) {
          socket.connect();
          setState(() {
            connecting = true;
          });
          socket.onConnect((_) {
            socket.emit("player-join-room",
                {"id": userController.currentUser.value.id});
            updateNotificationSocket();
          });

          try {
            socket.on('new-popup-banners', (data) {
              var popUpData = BodyOfPopUpData.fromJson(data);
              Future.delayed(const Duration(seconds: 20)).then(
                  (value) => loadPopup(popUpData.image_url, popUpData.id));
            });

            socket.on(
                "new_notification",
                (data) => {
                      socket.emit("notification_ack", {"id": data}),
                      updateNotificationSocket()
                    });
          } catch (e) {}

          socket.onConnectError((err) {});
          socket.onDisconnect((data) {
            socket.connect();
            setState(() {
              connecting = false;
            });
          });

          socket.onError((err) {
            debugPrint(err.toString());
          });
        }
      } else {
        // do nothing
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  loadPopup(String imgUrl, String id) {
    try {
      var _image = NetworkImage(imgUrl);

      _image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener(
          (info, call) {
            // do something
            showPopupBanner(imgUrl, id);
          },
        ),
      );
    } catch (e) {}
  }

  void showPopupBanner(String imgUrl, String id) {
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
                      ))),
            ],
          ),
        ),
      ),
    );
    Api api = Api();
    api.popupSeen(id);
  }

  @override
  Widget build(BuildContext context) {
    List _widgetOptions = [
      FeedPage(
        scrollController: scrollController,
      ),
      PlayPage(),
      StorePage(),
      MainChatScreen(),
      Notifications(),
      Settings(
        unreadNotifications: unreadNotifications,
      )
    ];
    return isBannedUser
        ? Scaffold(
            body: Center(
                child: SizedBox(
                    height: 300.h,
                    width: 200.w,
                    child: FittedBox(
                        child: Lottie.asset(
                      "assets/lottie/loding.json",
                      repeat: true,
                    )))),
          )
        : Scaffold(
            backgroundColor: _selectedIndex == 2
                ? Colors.white
                : AppColors.scaffoldBackGroundColor,
            appBar: MainAppBar(
                context: context,
                userController: userController,
                coinBalanceController: coinBalanceController,
                unreadNotifications: unreadNotifications),
            body: WillPopScope(
              onWillPop: () async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Do you want to exit from this application ? "),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // return true;
                        },
                        child: Text("No"),
                      ),
                      TextButton(
                        onPressed: () {
                          SystemNavigator.pop();
                          // return true;
                        },
                        child: Text("Yes"),
                      ),
                    ],
                  ),
                );
                return false;
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: _widgetOptions[_selectedIndex],
              ),
            ),
            // bottomNavigationBar:

            extendBody: true,
            bottomNavigationBar: BottomNavigationBar(
              elevation: 0,
              selectedItemColor: Color(0xffFF530D),
              unselectedItemColor: Colors.orange,
              backgroundColor: Colors.white,
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: GestureDetector(
                    child: SvgPicture.asset(
                      'assets/bg/home.svg',
                      height: 25,
                      width: 25,
                      color:
                          _selectedIndex == 0 ? Color(0xffFF530D) : Colors.grey,
                    ),
                    onDoubleTap: () {
                      if (_selectedIndex == 0) {
                        resetScrollFeed();
                      }
                    },
                  ),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: SvgPicture.asset(
                      'assets/bg/Game.svg',
                      height: 30,
                      width: 30,
                      color:
                          _selectedIndex == 1 ? Color(0xffFF530D) : Colors.grey,
                    ),
                  ),
                  label: "Play",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/bg/Store.svg',
                    height: 25,
                    width: 25,
                    color:
                        _selectedIndex == 2 ? Color(0xffFF530D) : Colors.grey,
                  ),
                  label: "Store",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/bg/chat.svg',
                    height: 30,
                    width: 30,
                    color:
                        _selectedIndex == 3 ? Color(0xffFF530D) : Colors.grey,
                  ),
                  label: "Chat",
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/bg/Notification.svg',
                        height: 25,
                        width: 25,
                        color: _selectedIndex == 4
                            ? Color(0xffFF530D)
                            : Colors.grey,
                      ),
                      if (unreadNotifications != "" &&
                          unreadNotifications != "0")
                        Positioned(
                          left: 8,
                          top: 4,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.PRIMARY_COLOR,
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Center(
                                    child: Text(
                                  unreadNotifications,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                )),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                  label: "Notification",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/bg/Menu.svg',
                    height: 20,
                    width: 20,
                    color:
                        _selectedIndex == 5 ? Color(0xffFF530D) : Colors.grey,
                  ),
                  label: "Menu",
                ),
              ],
            ));

    //  (TargetPlatform.android ==
    //         defaultTargetPlatform)
    //     ? ConvexAppBar(
    //         backgroundColor: Colors.white,
    //         activeColor: AppColors.PRIMARY_COLOR,
    //         color: AppColors.PRIMARY_COLOR,
    //         items: [
    //           TabItem(
    //               icon: Icons.home,
    //               activeIcon: GestureDetector(
    //                   onDoubleTap: () {
    //                     if (_selectedIndex == 0) {
    //                       resetScrollFeed();
    //                     }
    //                   },
    //                   child: Icon(
    //                     Icons.home,
    //                     size: MediaQuery.of(context).size.width * 0.10,
    //                   )),
    //               title: 'Home'),
    //           TabItem(icon: FontAwesomeIcons.gamepad, title: ' Play'),
    //           TabItem(icon: FontAwesomeIcons.store, title: 'Store'),
    //           TabItem(
    //               icon: Icons.device_hub_outlined, title: 'Connect'),
    //           TabItem(icon: Icons.menu, title: 'Menu'),
    //         ],
    //         initialActiveIndex: _selectedIndex,
    //         onTap: (int i) {
    //           setState(() {
    //             _selectedIndex = i;
    //           });
    //         },
    //       )
    //     : DotNavigationBar(
    //         enablePaddingAnimation: false,
    //         curve: Curves.easeInCirc,
    //         backgroundColor:
    //             _selectedIndex >= 3 ? Colors.white : Colors.grey[200],
    //         currentIndex: _selectedIndex,
    //         onTap: (index) {
    //           setState(() {
    //             _selectedIndex = index;
    //           });
    //         },
    //         items: [
    //           DotNavigationBarItem(
    //             title: "Home",
    //             icon: GestureDetector(
    //                 onDoubleTap: () {
    //                   if (_selectedIndex == 0) {
    //                     resetScrollFeed();
    //                   }
    //                 },
    //                 child: Icon(Icons.home)),
    //             selectedColor: AppColors.PRIMARY_COLOR,
    //           ),
    //           DotNavigationBarItem(
    //             title: " Play",
    //             icon: Container(
    //               margin: const EdgeInsets.only(right: 2),
    //               child: Icon(
    //                 FontAwesomeIcons.gamepad,
    //                 size: 24,
    //               ),
    //             ),
    //             selectedColor: AppColors.PRIMARY_COLOR,
    //           ),
    //           DotNavigationBarItem(
    //             title: "Store",
    //             // icon: Icon(FontAwesomeIcons.storeAlt),
    //             icon: Icon(Icons.storefront),
    //             selectedColor: AppColors.PRIMARY_COLOR,
    //           ),
    //           DotNavigationBarItem(
    //             title: "Connect",
    //             icon: Icon(
    //               Icons.device_hub_outlined,
    //             ),
    //             selectedColor: AppColors.PRIMARY_COLOR,
    //           ),
    //           DotNavigationBarItem(
    //             title: "Menu",
    //             icon: Icon(
    //               Icons.menu,
    //             ),
    //             selectedColor: AppColors.PRIMARY_COLOR,
    //           ),
    //         ],
    //       ),
  }

  List<String> get iconPaths => [
        "assets/bottom_navbar/house-light.png",
        "assets/bottom_navbar/play-light.png",
        "assets/bottom_navbar/store-light.png",
        "assets/bottom_navbar/connect-light.png",
        "assets/bottom_navbar/menu-light.png",
      ];
}
