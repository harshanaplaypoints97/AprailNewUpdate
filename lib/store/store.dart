import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:lottie/lottie.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Api/MarkertPlaceApi.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/style.dart';
import 'package:play_pointz/controllers/Markert_place_All_Item_Controller.dart';
import 'package:play_pointz/controllers/categor_controller.dart';
import 'package:play_pointz/controllers/coin_balance_controller.dart';
import 'package:play_pointz/controllers/upcomming_items_controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/models/home/popup_banner.dart';
import 'package:play_pointz/screens/Chat/Provider/Chat_provider.dart';
import 'package:play_pointz/screens/Items/item_screen.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';

import 'package:play_pointz/screens/google_ads/inline_adaptive_banner_ads.dart';
import 'package:play_pointz/screens/google_ads/store_banner_ad.dart';
import 'package:play_pointz/screens/home/home_page.dart';
import 'package:play_pointz/screens/shimmers/quiz_card_shimmer.dart';
import 'package:play_pointz/screens/shimmers/upcomming_items_shimmer.dart';
import 'package:play_pointz/store/main%20Store/Markert%20Place/screens/MainMarkertPlace.dart';
import 'package:play_pointz/store/main%20Store/Markert%20Place/screens/MarkertPlaceAddItem.dart';
import 'package:play_pointz/store/main%20Store/Markert%20Place/screens/Market_Place_Item_View.dart';
import 'package:play_pointz/store/main%20Store/Play%20Mart/Controller/PlayMartController.dart';
import 'package:play_pointz/store/main%20Store/Play%20Mart/model/PlayMartModel.dart';
import 'package:play_pointz/store/main%20Store/Play%20Mart/provider/PlayMartProvider.dart';
import 'package:play_pointz/store/recent_winner_container.dart';
import 'package:play_pointz/store/widgets/category_container.dart';
import 'package:play_pointz/store/widgets/rounded_button.dart';
import 'package:play_pointz/store/widgets/waiting_and_old_Items.dart';

import 'package:play_pointz/widgets/common/notification_button.dart';
import 'package:play_pointz/widgets/common/popup.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:provider/provider.dart';

import 'main Store/Markert Place/widgets/markertplace.dart';
import 'main Store/Play Mart/widgets/ItemView.dart';
import 'main Store/Play Mart/widgets/Itemcard.dart';
import 'widgets/up_comming_items.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key key}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  int go = 0;
  int pageblock = 0;
  List<Map<String, dynamic>> mediaList = [];
  int visiblenum = 1;
  Color activeColor = Color(0xFFFF530D).withOpacity(0.2);
  Color dectivatecolor = Colors.white;
  bool newItemLoading = false;
  bool upComingItemLoading = false;
  bool loading = false;
  bool itemsLoading = false;
  bool dataLoading = false;
  bool newdatanull = false;
  bool upcomingdatanull = false;

  int offset = 0;
  bool load = false;
  ScrollController storycontroller = ScrollController();

  String currentTime;
  String redeemWait = '';

  bool isBlocked = false;
  String blockDate = '';

  //get controllers
  CategoryController categoryController;
  ItemController itemController;
  final userController = Get.put(UserController());
  CoinBalanceController coinBalanceController;
  final MarkertPlaceAllItemController controller =
      Get.put(MarkertPlaceAllItemController());
  String currentCategory;

  @override
  void initState() {
    coinBalanceController = Get.put(CoinBalanceController(callback: () {
      debugPrint(
          "+++++++++++++++++++++++++ controller from paly widget called");
    }));

    super.initState();
    storycontroller.addListener(scrollListener);

    getCurrentTime();
    getPurchaseBlock();
    if (userController.currentUser == null) {
      userController.setCurrentUser();
    }

    currentCategory = "all";

    setState(() {
      categoryController = Get.put(CategoryController(
        callback: () {
          setState(() {});
        },
      ));
      itemController = Get.put(ItemController(
        callback: () {
          setState(() {});
        },
      ));
    });

    loadItems();

    showLatePopup();
  }

  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  void scrollListener() {
    double maxScroll = storycontroller.position.maxScrollExtent;
    double currentScroll = storycontroller.offset;
    double triggerPoint =
        maxScroll / 4; // Adjust this value based on your requirements

    if (currentScroll > triggerPoint && !itemController.isFinished && !load) {
      setState(() {
        load = true;
      });

      itemController
          .itemReload(offset: offset + 12, category: currentCategory)
          .then((value) {
        print('Offset ' + offset.toString());
        setState(() {
          if (value) {
            offset += 12;
          }
          load = false;
        });
      });
    }
  }

  void loadItems() async {
    setState(() {
      dataLoading = true;
      itemsLoading = true;
    });
    await itemController
        .fethcUpCommingItems(category: currentCategory)
        .then((value) => setState(() {
              // offset=12;
            }));
    itemController.filterItems("all");
    setState(() {
      dataLoading = false;
      itemsLoading = false;
    });
  }

  getCurrentTime() async {
    var result = await Api().getCurrentTime();
    if (result.done) {
      setState(() {
        currentTime = result.body.currentTime;
      });
      // }
    } else {
      setState(() {
        currentTime = null;
      });
    }
    print(currentTime);
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
            print('Networkimage is fully loaded and saved');
            showPopupBanner(imgUrl, id, context);
          },
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  getPurchaseBlock() async {
    var result = await Api().purchaseBlock(context);
    if (result.done) {
      if (result.body != null) {
        if (result.body.isBlocked) {
          if (result.body.blockDate != null) {
            setState(() {
              isBlocked = result.body.isBlocked;
              blockDate = result.body.blockDate;
            });
            DateTime _block = DateTime.parse(blockDate);
            DateTime now = currentTime != null
                ? DateTime.parse(currentTime)
                : DateTime.now();
            var difference = _block.difference(now);
            if (difference.inSeconds < 60) {
              setState(() {
                redeemWait = "few seconds ";
              });
            } else {
              var inDays = difference.inDays > 0
                  ? difference.inDays.toString() + ' Days '
                  : '';
              var inHours = difference.inHours.remainder(24) > 0
                  ? difference.inHours.remainder(24).toString() + ' Hours '
                  : '';
              var inMin = difference.inMinutes.remainder(60) > 0
                  ? difference.inMinutes.remainder(60).toString() + ' Minutes '
                  : '';
              print(inDays + ' ' + inHours + ' ' + inMin);
              setState(() {
                redeemWait = inDays + inHours + inMin;
              });
            }
          } else {
            setState(() {
              isBlocked = result.body.isBlocked;
              redeemWait = 'further notice ';
            });
          }
        } else {
          setState(() {
            isBlocked = false;
          });
        }
      } else {
        setState(() {
          isBlocked = false;
        });
      }
    } else {
      setState(() {
        isBlocked = false;
      });
    }
    // print(currentTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red,
      body: visiblenum == 1
          ? SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              visiblenum = 1;
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.width / 9,
                            width: MediaQuery.of(context).size.width / 3.65,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(
                                      0xFFFF530D), // Change this to your desired border color
                                  width:
                                      1.0, // Change this to your desired border width
                                ),
                                borderRadius: BorderRadius.circular(20),
                                color: visiblenum == 1
                                    ? Color(0xFFFF530D).withOpacity(0.2)
                                    : Colors.white),
                            child: Center(
                              child: Text(
                                "Play Shop",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 253, 118, 3),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        InkWell(
                          onTap: () {
                            controller.clear();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainMarkertPlace(),
                                ));
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.width / 9,
                            width: MediaQuery.of(context).size.width / 3.65,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(
                                      0xFFFF530D), // Change this to your desired border color
                                  width:
                                      1.0, // Change this to your desired border width
                                ),
                                borderRadius: BorderRadius.circular(20),
                                color: visiblenum == 3
                                    ? Color(0xFFFF530D).withOpacity(0.2)
                                    : Colors.white),
                            child: Center(
                              child: Text(
                                "Marketplace",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 253, 118, 3),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  visiblenum == 1
                      ? userController.currentUser.value != null
                          ? !userController.currentUser.value.is_brand_acc
                              ? Container(
                                  margin: EdgeInsets.only(
                                      top: 2, left: 12, right: 12, bottom: 2),
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: RefreshIndicator(
                                    onRefresh: !dataLoading
                                        ? () async {
                                            getPurchaseBlock();
                                            setState(() {
                                              itemsLoading = true;
                                              dataLoading = true;
                                              offset = 0;
                                            });
                                            await getCurrentTime();
                                            categoryController =
                                                Get.put(CategoryController(
                                              callback: () {
                                                setState(() {});
                                              },
                                            ));
                                            itemController =
                                                Get.put(ItemController(
                                              callback: () {
                                                setState(() {});
                                              },
                                            ));
                                            await getCurrentTime();
                                            await itemController
                                                .fethcUpCommingItems(
                                                    category: currentCategory,
                                                    refresh: true)
                                                .then(
                                                    (value) => setState(() {}));
                                            setState(() {
                                              itemsLoading = false;
                                              dataLoading = false;
                                            });
                                          }
                                        : () async {
                                            return;
                                          },

                                    child: ListView(
                                      controller: storycontroller,
                                      scrollDirection: Axis.vertical,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      children: [
                                        Column(
                                          children: [
                                            ProfileDetailsContainer(
                                              loading: true,
                                            ),
                                          ],
                                        ),
                                        isBlocked
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10),
                                                decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 255, 232, 206),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                margin: const EdgeInsets.only(
                                                    bottom: 15, top: 0),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.orange[50],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                      ),
                                                      child: Container(
                                                        height: 25,
                                                        width: 25,
                                                        child: Image.asset(
                                                          'assets/bg/info.png',
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              122,
                                                      child: Text.rich(
                                                        TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  'You have to wait until ',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        253,
                                                                        118,
                                                                        3),
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: redeemWait,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        253,
                                                                        118,
                                                                        3),
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  'for the next redeem!',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        253,
                                                                        118,
                                                                        3),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        Text(
                                          'Recent Winners',
                                          style: AppStyles.storeTitles,
                                        ),
                                        RecentWinnersContainer(),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text('Select Category',
                                            style: AppStyles.storeTitles),
                                        CategoryContainer(
                                          changeable: !dataLoading,
                                          getCurrentTime: () async {
                                            await getCurrentTime();
                                          },
                                          categoryController:
                                              categoryController,
                                          itemController: itemController,
                                          setCurrentCategory: (value) {
                                            setState(() {
                                              currentCategory = value;
                                              itemsLoading = true;
                                              dataLoading = true;
                                            });
                                          },
                                          callback: () {
                                            setState(() {});
                                          },
                                          itemLoading: () {
                                            itemsLoading = false;
                                            dataLoading = false;
                                          },
                                        ),
                                        !itemsLoading
                                            ? itemController
                                                    .otherItems.isNotEmpty
                                                ? Wrap(
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    children: [
                                                      for (int i = 0;
                                                          i <
                                                              itemController
                                                                  .otherItems
                                                                  .length;
                                                          i++)
                                                        itemController
                                                                    .otherItems[
                                                                        i]
                                                                    .type ==
                                                                'item'
                                                            ?

                                                            //Item design
                                                            Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10),
                                                                child:
                                                                    OtherItemWidget(
                                                                  item: itemController
                                                                      .otherItems[i],
                                                                  current:
                                                                      currentTime,
                                                                ),
                                                              )
                                                            : itemController
                                                                        .otherItems[
                                                                            i]
                                                                        .type ==
                                                                    'googleAd'
                                                                ? Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            12,
                                                                        vertical:
                                                                            12),
                                                                    child:
                                                                        InlineAdaptiveBannerAds(
                                                                      bannerWidth:
                                                                          300,
                                                                      bannerHeight:
                                                                          100,
                                                                    ),
                                                                  )
                                                                : itemController
                                                                            .otherItems[
                                                                                i]
                                                                            .type ==
                                                                        'normalAd'
                                                                    ? Container(
                                                                        child:
                                                                            StoreBannerAD(
                                                                        unitId:
                                                                            oneByOneAdUnitId,
                                                                        adSize:
                                                                            AdSize.fluid,
                                                                      ))
                                                                    : Container(),
                                                      load
                                                          ? Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 12,
                                                                      bottom:
                                                                          24),
                                                              child:
                                                                  SpinKitThreeBounce(
                                                                color: AppColors
                                                                    .PRIMARY_COLOR_LIGHT,
                                                                size: 25.0,
                                                              ),
                                                            )
                                                          : Container()
                                                    ],
                                                  )
                                                : Center(
                                                    child: noItems(
                                                        context, "No Items"))
                                            : Center(
                                                child: ActiveItemsShimmer(),
                                              ),
                                        Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                5),
                                      ],
                                    ),
                                    // ),
                                  ))
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 80,
                                      ),
                                      Stack(
                                        clipBehavior: Clip.none,
                                        children: <Widget>[
                                          SizedBox(
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  top: 30,
                                                  right: 20,
                                                  bottom: 20,
                                                  left: 20),
                                              child: Text(
                                                'You don\'t have access for this section',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 253, 118, 3),
                                                    fontSize: 16),
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                      color: Color.fromARGB(
                                                          255, 253, 118, 3),
                                                      width: 1.2)),
                                            ),
                                          ),
                                          Positioned(
                                            child: Container(
                                              height: 40,
                                              width: 20,
                                              child: Image.asset(
                                                'assets/bg/infobg.png',
                                              ),
                                            ),
                                            right: 0,
                                            left: 0,
                                            top: -20,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                          : ListView.builder(
                              itemCount: 8,
                              itemBuilder: (context, index) {
                                return UpCommingItemsShimmer();
                              },
                            )
                      : Container(),
                ],
              ),
            )
          :

          ////////////////////////////////////////////////////////////////////////////////////////////////////Visible Store Items //////////////////////////////////////////////////////////////////////////////////////

          Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            visiblenum = 1;
                          });
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.width / 9,
                          width: MediaQuery.of(context).size.width / 3.65,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(
                                    0xFFFF530D), // Change this to your desired border color
                                width:
                                    1.0, // Change this to your desired border width
                              ),
                              borderRadius: BorderRadius.circular(20),
                              color: visiblenum == 1
                                  ? Color(0xFFFF530D).withOpacity(0.2)
                                  : Colors.white),
                          child: Center(
                            child: Text(
                              "Play Shop",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color.fromARGB(255, 253, 118, 3),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     setState(() {
                      //       visiblenum = 2;
                      //     });
                      //   },
                      //   child: Container(
                      //     height: MediaQuery.of(context).size.width / 9,
                      //     width: MediaQuery.of(context).size.width / 3.65,
                      //     decoration: BoxDecoration(
                      //         border: Border.all(
                      //           color: Color(
                      //               0xFFFF530D), // Change this to your desired border color
                      //           width:
                      //               1.0, // Change this to your desired border width
                      //         ),
                      //         borderRadius: BorderRadius.circular(20),
                      //         color: visiblenum == 2
                      //             ? Color(0xFFFF530D).withOpacity(0.2)
                      //             : Colors.white),
                      //     child: Center(
                      //       child: Text(
                      //         "Play Mart",
                      //         style: TextStyle(
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w700,
                      //           color: Color.fromARGB(255, 253, 118, 3),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            visiblenum = 3;
                          });
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.width / 9,
                          width: MediaQuery.of(context).size.width / 3.65,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(
                                    0xFFFF530D), // Change this to your desired border color
                                width:
                                    1.0, // Change this to your desired border width
                              ),
                              borderRadius: BorderRadius.circular(20),
                              color: visiblenum == 3
                                  ? Color(0xFFFF530D).withOpacity(0.2)
                                  : Colors.white),
                          child: Center(
                            child: Text(
                              "Marketplace",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color.fromARGB(255, 253, 118, 3),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                visiblenum == 1
                    ? userController.currentUser.value != null
                        ? !userController.currentUser.value.is_brand_acc
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: 2, left: 12, right: 12, bottom: 2),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: RefreshIndicator(
                                  onRefresh: !dataLoading
                                      ? () async {
                                          getPurchaseBlock();
                                          setState(() {
                                            itemsLoading = true;
                                            dataLoading = true;
                                            offset = 0;
                                          });
                                          await getCurrentTime();
                                          categoryController =
                                              Get.put(CategoryController(
                                            callback: () {
                                              setState(() {});
                                            },
                                          ));
                                          itemController =
                                              Get.put(ItemController(
                                            callback: () {
                                              setState(() {});
                                            },
                                          ));
                                          await getCurrentTime();
                                          await itemController
                                              .fethcUpCommingItems(
                                                  category: currentCategory,
                                                  refresh: true)
                                              .then((value) => setState(() {}));
                                          setState(() {
                                            itemsLoading = false;
                                            dataLoading = false;
                                          });
                                        }
                                      : () async {
                                          return;
                                        },

                                  child: ListView(
                                    controller: storycontroller,
                                    scrollDirection: Axis.vertical,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    children: [
                                      Column(
                                        children: [
                                          ProfileDetailsContainer(
                                            loading: true,
                                          ),
                                        ],
                                      ),
                                      isBlocked
                                          ? Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 255, 232, 206),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin: const EdgeInsets.only(
                                                  bottom: 15, top: 0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8),
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.orange[50],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                    ),
                                                    child: Container(
                                                      height: 25,
                                                      width: 25,
                                                      child: Image.asset(
                                                        'assets/bg/info.png',
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            122,
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                'You have to wait until ',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      253,
                                                                      118,
                                                                      3),
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: redeemWait,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      253,
                                                                      118,
                                                                      3),
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                'for the next redeem!',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      253,
                                                                      118,
                                                                      3),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      Text(
                                        'Recent Winners',
                                        style: AppStyles.storeTitles,
                                      ),
                                      RecentWinnersContainer(),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text('Select Category',
                                          style: AppStyles.storeTitles),
                                      CategoryContainer(
                                        changeable: !dataLoading,
                                        getCurrentTime: () async {
                                          await getCurrentTime();
                                        },
                                        categoryController: categoryController,
                                        itemController: itemController,
                                        setCurrentCategory: (value) {
                                          setState(() {
                                            currentCategory = value;
                                            itemsLoading = true;
                                            dataLoading = true;
                                          });
                                        },
                                        callback: () {
                                          setState(() {});
                                        },
                                        itemLoading: () {
                                          itemsLoading = false;
                                          dataLoading = false;
                                        },
                                      ),
                                      !itemsLoading
                                          ? itemController.otherItems.isNotEmpty
                                              ? Wrap(
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  children: [
                                                    for (int i = 0;
                                                        i <
                                                            itemController
                                                                .otherItems
                                                                .length;
                                                        i++)
                                                      itemController
                                                                  .otherItems[i]
                                                                  .type ==
                                                              'item'
                                                          ?

                                                          //Item design
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          10),
                                                              child:
                                                                  OtherItemWidget(
                                                                item: itemController
                                                                    .otherItems[i],
                                                                current:
                                                                    currentTime,
                                                              ),
                                                            )
                                                          : itemController
                                                                      .otherItems[
                                                                          i]
                                                                      .type ==
                                                                  'googleAd'
                                                              ? Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          12),
                                                                  child:
                                                                      InlineAdaptiveBannerAds(
                                                                    bannerWidth:
                                                                        300,
                                                                    bannerHeight:
                                                                        100,
                                                                  ),
                                                                )
                                                              : itemController
                                                                          .otherItems[
                                                                              i]
                                                                          .type ==
                                                                      'normalAd'
                                                                  ? Container(
                                                                      child:
                                                                          StoreBannerAD(
                                                                      unitId:
                                                                          oneByOneAdUnitId,
                                                                      adSize: AdSize
                                                                          .fluid,
                                                                    ))
                                                                  : Container(),
                                                    load
                                                        ? Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 12,
                                                                    bottom: 24),
                                                            child:
                                                                SpinKitThreeBounce(
                                                              color: AppColors
                                                                  .PRIMARY_COLOR_LIGHT,
                                                              size: 25.0,
                                                            ),
                                                          )
                                                        : Container()
                                                  ],
                                                )
                                              : Center(
                                                  child: noItems(
                                                      context, "No Items"))
                                          : Center(
                                              child: ActiveItemsShimmer(),
                                            ),
                                      Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1),
                                    ],
                                  ),
                                  // ),
                                ))
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 80,
                                    ),
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: <Widget>[
                                        SizedBox(
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                top: 30,
                                                right: 20,
                                                bottom: 20,
                                                left: 20),
                                            child: Text(
                                              'You don\'t have access for this section',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 253, 118, 3),
                                                  fontSize: 16),
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                100,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    color: Color.fromARGB(
                                                        255, 253, 118, 3),
                                                    width: 1.2)),
                                          ),
                                        ),
                                        Positioned(
                                          child: Container(
                                            height: 40,
                                            width: 20,
                                            child: Image.asset(
                                              'assets/bg/infobg.png',
                                            ),
                                          ),
                                          right: 0,
                                          left: 0,
                                          top: -20,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                        : ListView.builder(
                            itemCount: 8,
                            itemBuilder: (context, index) {
                              return UpCommingItemsShimmer();
                            },
                          )
                    : visiblenum == 2
                        ? Container()
                        : Container()
              ],
            ),
    );
  }

  Widget noItems(BuildContext context, String text) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      height: size.height * 0.12,
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Color(0xffDBDBDB)),
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Column(
          children: [
            Spacer(),
            Text(
              text,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff52616B)),
            ),
            SizedBox(
              height: size.height * 0.008,
            ),
            Text(
              'Please check later',
              style: TextStyle(
                fontSize: 12.sp,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class ItemCtergory extends StatelessWidget {
  String itemname;
  ItemCtergory({
    @required this.itemname,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFff8a00),
              Color(0xfffba700),
              Color.fromARGB(255, 255, 222, 132)
            ],
          ),
        ),
        height: MediaQuery.of(context).size.width / 9,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/bg/Store.svg',
                  height: 15,
                  width: 15,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(itemname,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                        color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileDetailsContainer extends StatelessWidget {
  ProfileDetailsContainer({
    Key key,
    @required this.loading,
  }) : super(key: key);

  final bool loading;

  UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 90.h,
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0, // Set the radius as needed
              backgroundColor: Colors
                  .transparent, // You can set a background color if desired
              child: ClipOval(
                child: Image.network(
                  userController.currentUser.value != null
                      ? userController.currentUser.value.profileImage ??
                          "https://playpointz.com/assets/images/no_profile.png"
                      : "https://playpointz.com/assets/images/no_profile.png",
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    // Handle image loading error, if necessary
                    return Image.asset("$baseUrl/assets/images/no_profile.png");
                  },
                  width: 60.0, // Adjust the width as needed
                  height: 60.0, // Adjust the height as needed
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Play & Earn Your",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.normalTextColor.withOpacity(0.6),
                    letterSpacing: 0.8,
                  ),
                ),
                Text("Dream item!",
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.normalTextColor,
                      letterSpacing: 1.2,
                    )),
              ],
            ),
            SizedBox(
              width: 6.w,
            ),
            SizedBox(
              height: 200.h,
              width: 100.w,
              child: FittedBox(
                child: Lottie.asset(
                  "assets/lottie/gift_loading.json",
                  repeat: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemCtergory2 extends StatelessWidget {
  String itemname;
  ItemCtergory2({
    @required this.itemname,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 52, 141, 80),
              Color.fromARGB(255, 127, 224, 158),
              Color.fromARGB(255, 127, 224, 158),
            ],
          ),
        ),
        height: MediaQuery.of(context).size.width / 9,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/bg/Store.svg',
                  height: 15,
                  width: 15,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(itemname,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                        color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
