import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:play_pointz/Api/MarkertPlaceApi.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/controllers/coin_balance_controller.dart';
import 'package:play_pointz/screens/shimmers/shimmer_widget.dart';
import 'package:play_pointz/store/main%20Store/Markert%20Place/screens/Makert_Place_Edit_Item.dart';
import 'package:play_pointz/store/main%20Store/Markert%20Place/screens/MarkertPlaceAddItem.dart';
import 'package:play_pointz/store/store.dart';
import 'package:play_pointz/store/widgets/rounded_button.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../Api/Api.dart';
import '../../../../controllers/MakertPlace_Profile_Controlller.dart';
import '../../../../controllers/Markert_place_All_Item_Controller.dart';
import '../../../../controllers/user_controller.dart';
import '../../../../models/home/UnReadNoti.dart';
import '../../../../models/markertPlace/MarkertPlacePlayerItem.dart';
import '../../../../screens/feed/CustomCacheManager.dart';
import '../../../../widgets/common/app_bar.dart';
import '../../../../widgets/login/text_form_field.dart';

class MarkertPlaceMyITem extends StatefulWidget {
  const MarkertPlaceMyITem({Key key}) : super(key: key);

  @override
  State<MarkertPlaceMyITem> createState() => _MarkertPlaceMyITemState();
}

class _MarkertPlaceMyITemState extends State<MarkertPlaceMyITem> {
  bool loder = false;
  final ScrollController scrollController = ScrollController();
  final MarkertPlaceProfileController controller =
      Get.put(MarkertPlaceProfileController());

  String selectedCategory;

  List<String> categories = [
    'Electronics',
    'Property',
    'Vehicles',
    'Home & Garden',
    'Services',
    'Business & Industry',
    'Hobby, Sport & Kids',
    'Animals',
    'Fashion & Beauty',
    'Education',
    'Essentials',
    'Work Overseas',
    'Agriculture',
    'Other',
    // Add more categories as needed
  ];

  List<Map<String, dynamic>> mediaList = [];
  bool _change = true;
  TextEditingController itemname = TextEditingController();
  TextEditingController itemprices = TextEditingController();
  TextEditingController itemcatergory = TextEditingController();
  TextEditingController itemdescription = TextEditingController();
  UserController userController = UserController();
  CoinBalanceController coinBalanceController = CoinBalanceController();
  String unreadNotifications = "";

  void updateNotificationSocket() async {
    UnReadNotiCount res = await Api().getUnReadNotificationCount();
    if (res.body.count != null) {}
    setState(() {
      unreadNotifications = res.body.count;
    });
  }

  @override
  void initState() {
    controller.fetchProduct(0, 10);
    updateNotificationSocket();
    coinBalanceController = Get.put(CoinBalanceController(callback: () {
      debugPrint(
          "+++++++++++++++++++++++++ controller from paly widget called");
      setState(() {});
    }));
    if (userController.currentUser == null) {
      userController.setCurrentUser();
    }

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (loder == false) {
          if (controller.offset <
              controller.markertplaceprofileItemList[0].body.count) {
            controller.loadMoreData('g');
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
    // TODO: implement initState
    super.initState();
  }

  List<XFile> _images = [];
  List<String> _base64Images = [];

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    List<XFile> pickedImages = await picker.pickMultiImage();
    if (pickedImages != null) {
      List<String> base64List = [];
      for (var image in pickedImages) {
        List<int> imageBytes = await image.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        base64List.add(base64Image);
      }
      setState(() {
        _images = pickedImages;
        _base64Images = base64List;
      });
    }
  }

  int visiblenum = 1;
  @override
  Widget build(BuildContext context) {
    // scrollController.addListener(() {
    //   if (scrollController.position.pixels ==
    //       scrollController.position.maxScrollExtent) {
    //     Logger().i(
    //         controller.markertplaceprofileItemList[0].body.count.toString() +
    //             '                ' +
    //             controller.limit.toString());
    //     // if (controller.markertplaceprofileItemList[0].body.count < 10
    //     //     ? 10
    //     //     : controller.markertplaceprofileItemList[0].body.count >=
    //     //         controller.limit) {
    //     controller.loadMoreData();
    //     // } else {}

    //     // Load more data when reaching the end of the list
    //   }
    // });
    return RefreshIndicator(
      onRefresh: () async {
        controller.clear();
        controller.fetchProduct(0, 10);
      },
      child: Scaffold(
        backgroundColor: AppColors.SCREEN_BACKGROUND_COLOR,
        appBar: MainAppBar(
            context: context,
            userController: userController,
            coinBalanceController: coinBalanceController,
            unreadNotifications: unreadNotifications),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
                            "Your Items",
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
                      width: 40,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MarkertPlaceAddItem(),
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
                            color: visiblenum == 2
                                ? Color(0xFFFF530D).withOpacity(0.2)
                                : Colors.white),
                        child: Center(
                          child: Text(
                            "Add Item",
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
              /////////////////////////////////////////////////////////////////////////
              ///
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Divider(
                  thickness: 2,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  visiblenum == 1 ? "My Sell List" : "Sell Your Item",
                  style: TextStyle(
                    color: Color(0xff7C7A7A),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ///////////////////////////////////////////////////////////////////////////
              ///
              Obx(
                () {
                  var marketplaceItems =
                      controller.markertplaceprofileItemList.isEmpty
                          ? []
                          : controller.markertplaceprofileItemList[0].body
                              .marketplaceItems;
                  if (marketplaceItems.isEmpty) {
                    return Center(child: Text("No Items "));
                  } else {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: controller
                                  .markertplaceprofileItemList[0]
                                  .body
                                  .marketplaceItems
                                  .length,
                              itemBuilder: (context, index) => MyItemCard(
                                Itemid: controller
                                    .markertplaceprofileItemList[0]
                                    .body
                                    .marketplaceItems[index]
                                    .id,
                                imageList: controller
                                    .markertplaceprofileItemList[0]
                                    .body
                                    .marketplaceItems[index]
                                    .marketplaceMedia,
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
                                ondelete: () async {
                                  navigator.pop();

                                  controller.deleteItem(controller
                                      .markertplaceprofileItemList[0]
                                      .body
                                      .marketplaceItems[index]
                                      .id);
                                  controller.clear();

                                  controller.fetchProduct(0, 10);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyItemCard extends StatefulWidget {
  MyItemCard({
    @required this.itemcatergory,
    @required this.ItemImage,
    @required this.ItemName,
    @required this.ItemDescription,
    @required this.ItemPrice,
    @required this.ondelete,
    @required this.imageList,
    @required this.Itemid,
    Key key,
  }) : super(key: key);
  String itemcatergory;
  String Itemid;
  String ItemImage;
  String ItemName;
  String ItemDescription;
  String ItemPrice;
  VoidCallback ondelete;
  final List<MarketplaceMedia> imageList;

  @override
  State<MyItemCard> createState() => _MyItemCardState();
}

class _MyItemCardState extends State<MyItemCard> {
  @override
  Widget build(BuildContext context) {
    bool change = false;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            width: 100,
            fit: BoxFit.cover,
            height: 100,
            cacheManager: CustomCacheManager.instance,
            imageUrl: widget.ItemImage ?? "",
            errorWidget: (context, url, error) {
              // Retry after a delay
              Future.delayed(Duration(seconds: 5), () {
                setState(() {
                  // Update the widget or retry the image loading logic
                });
              });
              return Shimmer(
                child: Container(
                  height: 100, // Adjust the height based on your design
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xffC4C4C4).withOpacity(0.3),
                  ),
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.grey[300],
                    Colors.grey[200],
                    Colors.grey[300]
                  ],
                  begin: Alignment(-1, -1),
                  end: Alignment(1, 1),
                  stops: [0, 0.5, 1],
                ),
              );
            },
            placeholder: (context, url) => Shimmer(
              child: Container(
                height: 100, // Adjust the height based on your design
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color(0xffC4C4C4).withOpacity(0.3),
                ),
              ),
              gradient: LinearGradient(
                colors: [Colors.grey[300], Colors.grey[200], Colors.grey[300]],
                begin: Alignment(-1, -1),
                end: Alignment(1, 1),
                stops: [0, 0.5, 1],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.ItemName.length > 20
                      ? widget.ItemName.substring(0, 20)
                      : widget.ItemName,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                  maxLines: 1,
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 210.h, // Set your desired width
                  child: Text(
                    widget.ItemDescription,
                    style: TextStyle(
                      color: Color(0xff7C7A7A),
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Rs . " +
                      NumberFormat('###,000')
                          .format(int.parse(widget.ItemPrice)),
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: change
                          ? Colors.red
                          : Color.fromARGB(255, 71, 70, 70)),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60.0),
                      topRight: Radius.circular(60.0),
                    ),
                  ),
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60.0),
                            topRight: Radius.circular(60.0),
                          ),
                        ),
                        height: 180.h,
                        child: Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Divider(),
                                InkWell(
                                  onTap: () {
                                    navigator.push(MaterialPageRoute(
                                      builder: (context) => MarketPlaceEditItem(
                                        /////////////////////////////////////////////////////////////////
                                        itemid: widget.Itemid,
                                        imageList: widget.imageList,
                                        itemdescription: widget.ItemDescription,
                                        itemname: widget.ItemName,
                                        itemprice: widget.ItemPrice,
                                      ),
                                    ));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        color: Color.fromARGB(255, 71, 70, 70),
                                        size: 20,
                                      ),
                                      Text(
                                        "  Edit    ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.sp,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Divider(),
                                InkWell(
                                  onTap: widget.ondelete,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: Color.fromARGB(255, 71, 70, 70),
                                        size: 20,
                                      ),
                                      Text(
                                        "   Delete",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.sp,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Divider(),
                              ]),
                        ),
                      ));
            },
            child: Icon(Icons.more_horiz),
          )
        ],
      ),
    );
  }
}

class MarkertPlaceMyITemContainer extends StatelessWidget {
  const MarkertPlaceMyITemContainer({
    Key key,
    // @required this.MarkertPlaceMyITemContainer,
  }) : super(key: key);

  // final MarkertPlaceAllItemController MarkertPlaceMyITemContainer;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              navigator.push(MaterialPageRoute(
                builder: (context) => MarkertPlaceMyITem(),
              ));
            },
            child: ItemCtergory(itemname: "Sell Your Item !"),
          ),
          InkWell(onTap: () {}, child: ItemCtergory(itemname: "Vehicle ")),
        ],
      ),
    );
  }
}
