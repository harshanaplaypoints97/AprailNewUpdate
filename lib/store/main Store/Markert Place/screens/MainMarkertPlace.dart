import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:play_pointz/Api/MarkertPlaceApi.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/controllers/MakertPlace_Profile_Controlller.dart';
import 'package:play_pointz/controllers/Markert_place_All_Item_Controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/store/main%20Store/Markert%20Place/screens/MarkertPlaceAddItem.dart';
import 'package:play_pointz/store/main%20Store/Markert%20Place/screens/MarkertPlaceMyItem.dart';
import 'package:play_pointz/store/main%20Store/Markert%20Place/screens/Market_Place_Item_View.dart';
import 'package:play_pointz/store/main%20Store/Markert%20Place/widgets/markertplace.dart';
import 'package:play_pointz/store/store.dart';
import 'package:play_pointz/widgets/common/app_bar.dart';

import '../../../../Api/Api.dart';
import '../../../../controllers/coin_balance_controller.dart';
import '../../../../models/home/UnReadNoti.dart';

class MainMarkertPlace extends StatefulWidget {
  const MainMarkertPlace({Key key}) : super(key: key);

  @override
  State<MainMarkertPlace> createState() => _MainMarkertPlaceState();
}

class _MainMarkertPlaceState extends State<MainMarkertPlace> {
  bool loder = false;
  String catergrory = "All";
  final ScrollController scrollController = ScrollController();
  final MarkertPlaceAllItemController controller =
      Get.put(MarkertPlaceAllItemController());
  final userController = Get.put(UserController());
  CoinBalanceController coinBalanceController;
  final MarkertPlaceProfileController mycontroller =
      Get.put(MarkertPlaceProfileController());

  String unreadNotifications = "";

  void updateNotificationSocket() async {
    UnReadNotiCount res = await Api().getUnReadNotificationCount();
    if (res.body.count != null) {}
    setState(() {
      unreadNotifications = res.body.count;
    });
  }

  @override
  dispose() {
    controller.dispose();
    mycontroller.dispose();
    super.dispose();
  }

  void initState() {
    // ApiMarkert().GetPlayerMarkertPlaceItem(0, 10);
    controller.fetchProduct(catergrory, 0, 10);
    // _notification();

    coinBalanceController = Get.put(CoinBalanceController(callback: () {
      debugPrint(
          "+++++++++++++++++++++++++ controller from paly widget called");
      setState(() {});
    }));

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

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (loder == false) {
          if (controller.offset <
              controller.markertplaceprofileItemList[0].body.count) {
            controller.loadMoreData(catergrory);
          } else {
            Logger().e("cant load");
          }
        }
        setState(() {
          loder = true;
        });
        loder
            ? Future.delayed(Duration(seconds: 2), () {
                setState(() {
                  loder = false; // Set loading to false after 2 seconds
                });
              })
            : () {};

        // Load more data when reaching the end of the list
      }
    });

    super.initState();
  }

  int visiblenum = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
          context: context,
          userController: userController,
          coinBalanceController: coinBalanceController,
          unreadNotifications: unreadNotifications),
      body: RefreshIndicator(
        onRefresh: () async {
          try {
            // Fetch new data from the server
            controller.clear();
            await controller.fetchProduct(catergrory, 0, 10);
          } catch (e) {
            // Handle any errors that occur during data fetching
            print("Error refreshing data: $e");
            // You can show a snackbar or display an error message to the user

          }
        },
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            UpperSection(visiblenum: visiblenum),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                mycontroller.clear();
                                navigator.push(MaterialPageRoute(
                                  builder: (context) => MarkertPlaceMyITem(),
                                ));
                              },
                              child:
                                  ItemCtergory2(itemname: "Sell Your Item !"),
                            ),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    catergrory = "All";
                                  });
                                  controller.clear();
                                  controller.fetchProduct(catergrory, 0, 10);
                                },
                                child: ItemCtergory(itemname: "All ")),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    catergrory = "Electronics";
                                  });
                                  controller.clear();
                                  controller.fetchProduct(catergrory, 0, 10);
                                },
                                child: ItemCtergory(itemname: "Electronics")),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    catergrory = "Property";
                                  });
                                  controller.clear();
                                  controller.fetchProduct(catergrory, 0, 10);
                                },
                                child: ItemCtergory(itemname: "Property")),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    catergrory = "Vehicles";
                                  });
                                  controller.clear();
                                  controller.fetchProduct(catergrory, 0, 10);
                                },
                                child: ItemCtergory(itemname: "Vehicles")),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    catergrory = "g";
                                  });
                                  controller.clear();
                                  controller.fetchProduct(catergrory, 0, 10);
                                },
                                child: ItemCtergory(itemname: "Home & Garden")),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    catergrory = "f";
                                  });
                                  controller.clear();
                                  controller.fetchProduct(catergrory, 0, 10);
                                },
                                child:
                                    ItemCtergory(itemname: "Fashion & Beauty")),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    catergrory = "Services";
                                  });
                                  controller.clear();
                                  controller.fetchProduct(catergrory, 0, 10);
                                },
                                child: ItemCtergory(itemname: "Services")),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    catergrory = 'b';
                                  });
                                  controller.clear();
                                  controller.fetchProduct(catergrory, 0, 10);
                                },
                                child: ItemCtergory(
                                    itemname: "Business & Industry")),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    catergrory = "Hobby, Sport & Kids";
                                  });
                                  controller.clear();
                                  controller.fetchProduct('h', 0, 10);
                                },
                                child: ItemCtergory(
                                    itemname: "Hobby, Sport & Kids")),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    catergrory = "Animals";
                                  });
                                  controller.clear();
                                  controller.fetchProduct(catergrory, 0, 10);
                                },
                                child: ItemCtergory(itemname: "Animals")),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    catergrory = "Education";
                                  });
                                  controller.clear();
                                  controller.fetchProduct(catergrory, 0, 10);
                                },
                                child: ItemCtergory(itemname: "Education")),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    catergrory = "Essentials";
                                  });
                                  controller.clear();
                                  controller.fetchProduct(catergrory, 0, 10);
                                },
                                child: ItemCtergory(itemname: "Essentials")),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    catergrory = "Work Overseas";
                                  });
                                  controller.clear();
                                  controller.fetchProduct(catergrory, 0, 10);
                                },
                                child: ItemCtergory(itemname: "Work Overseas")),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    catergrory = "Agriculture";
                                  });
                                  controller.clear();
                                  controller.fetchProduct(catergrory, 0, 10);
                                },
                                child: ItemCtergory(itemname: "Agriculture")),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    catergrory = "Other";
                                  });
                                  controller.clear();
                                  controller.fetchProduct(catergrory, 0, 10);
                                },
                                child: ItemCtergory(itemname: "Other")),
                          ],
                        ),
                      )),
                  Obx(
                    () {
                      var marketplaceItems =
                          controller.markertplaceprofileItemList.isEmpty
                              ? []
                              : controller.markertplaceprofileItemList[0].body
                                  .marketplaceItems;
                      if (marketplaceItems.isEmpty) {
                        return Expanded(
                            child: Center(child: Text("No Items ")));
                      } else {
                        return Expanded(
                          flex: 2,
                          child: GridView.builder(
                            controller: scrollController,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            physics: BouncingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 0.65,
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 12,
                            ),
                            itemBuilder: (context, index) {
                              // Logger().i(controller
                              //     .markertplaceprofileItemList[0]
                              //     .body
                              //     .marketplaceItems
                              //     .length);
                              return InkWell(
                                onTap: () {
                                  // controller.fetchProduct('Electronic');
                                  navigator.push(MaterialPageRoute(
                                    builder: (context) => MarkertPlaceItemView(
                                        Playername: controller
                                            .markertplaceprofileItemList[0]
                                            .body
                                            .marketplaceItems[index]
                                            .playerFullName,
                                        PlayerImage: controller
                                            .markertplaceprofileItemList[0]
                                            .body
                                            .marketplaceItems[index]
                                            .playerProfileImage,
                                        imageList: controller
                                            .markertplaceprofileItemList[0]
                                            .body
                                            .marketplaceItems[index]
                                            .marketplaceMedia,
                                        playerid: controller
                                            .markertplaceprofileItemList[0]
                                            .body
                                            .marketplaceItems[index]
                                            .playerId
                                            .toString(),
                                        ItemName: controller
                                            .markertplaceprofileItemList[0]
                                            .body
                                            .marketplaceItems[index]
                                            .itemName,
                                        ItemDescription: controller
                                            .markertplaceprofileItemList[0]
                                            .body
                                            .marketplaceItems[index]
                                            .itemDesc,
                                        ItemImage: controller
                                            .markertplaceprofileItemList[0]
                                            .body
                                            .marketplaceItems[index]
                                            .marketplaceMedia[0]
                                            .imageUrl,
                                        ItemPrice: controller
                                            .markertplaceprofileItemList[0]
                                            .body
                                            .marketplaceItems[index]
                                            .itemPrice
                                            .toString(),
                                        index: index),
                                  ));
                                },
                                child: MarkertplaceItem(
                                  ItemName: controller
                                      .markertplaceprofileItemList[0]
                                      .body
                                      .marketplaceItems[index]
                                      .itemName,
                                  ItemPrice: controller
                                      .markertplaceprofileItemList[0]
                                      .body
                                      .marketplaceItems[index]
                                      .itemPrice
                                      .toString(),
                                  ItemDescriptionList: controller
                                      .markertplaceprofileItemList[0]
                                      .body
                                      .marketplaceItems[index]
                                      .itemDesc,
                                  ItemImage: controller
                                      .markertplaceprofileItemList[0]
                                      .body
                                      .marketplaceItems[index]
                                      .marketplaceMedia[0]
                                      .imageUrl,
                                ),
                              );
                            },
                            itemCount: controller.markertplaceprofileItemList[0]
                                .body.marketplaceItems.length,
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
            loder
                ? SpinKitThreeBounce(
                    size: 25,
                    color: AppColors.PRIMARY_COLOR,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

class UpperSection extends StatelessWidget {
  const UpperSection({
    Key key,
    @required this.visiblenum,
  }) : super(key: key);

  final int visiblenum;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              navigator.pop();
            },
            child: Container(
              height: MediaQuery.of(context).size.width / 9,
              width: MediaQuery.of(context).size.width / 3.65,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(
                        0xFFFF530D), // Change this to your desired border color
                    width: 1.0, // Change this to your desired border width
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
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => MainMarkertPlace(),
              //     ));
            },
            child: Container(
              height: MediaQuery.of(context).size.width / 9,
              width: MediaQuery.of(context).size.width / 3.65,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(
                        0xFFFF530D), // Change this to your desired border color
                    width: 1.0, // Change this to your desired border width
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
    );
  }
}
