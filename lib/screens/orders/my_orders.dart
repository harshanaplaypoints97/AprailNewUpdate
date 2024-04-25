import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/models/Orders.dart';
import 'package:play_pointz/models/feed/create_post.dart';
import 'package:play_pointz/screens/home/home_page.dart';
import 'package:play_pointz/services/image_cropper/image_cropper.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:play_pointz/widgets/orders/orderitem.dart';

class MyOrders extends StatefulWidget {
  bool fromProfile;
  int index;
  final Function onPostCreate;
  MyOrders({Key key, this.index = 0, this.onPostCreate, this.fromProfile})
      : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

bool loadingdata = false;
String base64Image;
String base64Image2;
PickedFile imageFile;
var bytes;
Io.File image;
ScrollController _scrollController = ScrollController();

class _MyOrdersState extends State<MyOrders>
    with SingleTickerProviderStateMixin {
  List<BodyOFOrders> orders = [];
  List<BodyOFOrders> pendingItems = [];
  List<BodyOFOrders> deliveredItems = [];
  List<BodyOFOrders> shipedItems = [];
  List<BodyOFOrders> processingItems = [];
  List<BodyOFOrders> placedItems = [];
  List<BodyOFOrders> canceledItem = [];
  List<BodyOFOrders> reviewItem = [];

  TextEditingController descriptionController = TextEditingController();

  getOrders() async {
    setState(() {
      loadingdata = true;
    });
    Orders result = await Api().getOrders();
    if (result.done != null) {
      if (result.done) {
        orders = result.body;
        for (int i = 0; i <= orders.length - 1; i++) {
          debugPrint("order status is ${orders[i].status}");
          if (orders[i].status == "Delivered") {
            deliveredItems.add(orders[i]);
          } else if (orders[i].status == "Shipped") {
            shipedItems.add(orders[i]);
          } else if (orders[i].status == "Processing") {
            processingItems.add(orders[i]);
          } else if (orders[i].status == "Pending") {
            pendingItems.add(orders[i]);
          } else if (orders[i].status == "Placed") {
            placedItems.add(orders[i]);
          } else if (orders[i].status == "Canceled") {
            canceledItem.add(orders[i]);
          } else if (orders[i].status == "In Review") {
            reviewItem.add(orders[i]);
          }
        }
        setState(() {
          loadingdata = false;
        });
      } else {
        setState(() {
          loadingdata = false;
        });
      }
    } else {
      setState(() {
        loadingdata = false;
      });
    }
  }

  setItemStatus(String orderId) async {
    setState(() {
      orders.clear();
      pendingItems.clear();
      deliveredItems.clear();
      shipedItems.clear();
      processingItems.clear();
      placedItems.clear();
      canceledItem.clear();
      reviewItem.clear();
    });
    await Api().changeOrderStatus(orderId, 'Delivered');

    await getOrders();
  }

  void _openGallery(BuildContext context) async {
    /* final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    ); */
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
    /* final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    ); */
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
              controller: _scrollController,
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
    // print('picked img ${ base64Image.toString()} ${base64Image2.toString()} ${base64.toString()} ' );

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
          widget.onPostCreate();
          Navigator.pop(context);
        } else {
          messageToastRed(result.message != '' || result.message != null
              ? result.message
              : 'Please Try again Later');
          //       Navigator.of(context, rootNavigator: true).pop();
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
        //   Navigator.of(context, rootNavigator: true).pop();
        Get.back();
        setState(() {
          creating = false;
        });
        // navigate();
      }
    }
    // feedController.feeds.clear();

    // await feedController.fetchDataFromApi();

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
          child: Column(
            children: [
              const SizedBox(
                height: kToolbarHeight,
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackGroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 5,
                width: kToolbarHeight * 1.8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              descriptionController.clear();
                              imageFile = null;
                              base64Image = null;
                              base64Image2 = null;
                            });
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Center(
                      child: Text(
                        "Create Post",
                        style: TextStyle(
                          color: AppColors.normalTextColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Row(
                      children: [
                        const Spacer(),
                        ValueListenableBuilder<bool>(
                            valueListenable: shouldLoad,
                            builder: (context, bool snapshot, _) {
                              return /*snapshot
                                  ? SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.PRIMARY_COLOR,
                                        ),
                                      ),
                                    )
                                  :*/
                                  MaterialButton(
                                minWidth: kToolbarHeight,
                                elevation: 0,
                                color: AppColors.PRIMARY_COLOR,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
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
                                    // getFeedPosts();
                                    // Navigator.popUntil(
                                    //     context, (route) => false);
                                  }
                                },
                                child: snapshot
                                    ? SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        "Post",
                                        style: TextStyle(color: Colors.white),
                                      ),
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 150,
                child: ListView(
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
                          labelText: "What's on your mind,"),
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
                                // child: IconButton(Icons.close, color: Colors.white)),
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
                              // child: ElevatedButton(
                              //   onPressed: () {
                              //     setState(() {
                              //       imageFile = null;
                              //       base64Image = null;
                              //       base64Image2 = null;
                              //     });
                              //     Navigator.pop(context);
                              //     createPost(context: context);
                              //   },
                              //   child: Icon(Icons.close, color: Colors.white),
                              //   style: ElevatedButton.styleFrom(
                              //     shape: CircleBorder(),
                              //     //padding: EdgeInsets.all(4),
                              //     backgroundColor:
                              //         Colors.black, // <-- Button color
                              //     foregroundColor:
                              //         Colors.red, // <-- Splash color
                              //   ),
                              // ),
                            )
                            // Padding(
                            //   padding: EdgeInsets.symmetric(horizontal: 20.w),
                            //   child: MaterialButton(
                            //     child: Text(
                            //       "View Image",
                            //       style: TextStyle(
                            //           letterSpacing: 1,
                            //           color: Colors.white,
                            //           fontWeight: FontWeight.w600),
                            //     ),
                            //     onPressed: () {
                            //       Get.dialog(
                            //         Dialog(
                            //           child: Container(
                            //             width:
                            //                 MediaQuery.of(context).size.width / 1.1,
                            //             decoration: BoxDecoration(
                            //               borderRadius: BorderRadius.circular(6),
                            //               image: DecorationImage(
                            //                 fit: BoxFit.fitWidth,
                            //                 image: FileImage(
                            //                   File(imageFile.path),
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //     color: Colors.transparent,
                            //     elevation: 0,
                            //     shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(6),
                            //         side: BorderSide(
                            //           color: Colors.white,
                            //         )),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 8,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    MaterialButton(
                      onPressed: () {
                        _showChoiceDialog(context);
                      },
                      elevation: 0,
                      minWidth: double.infinity,
                      height: kToolbarHeight,
                      color: AppColors.PRIMARY_COLOR.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        imageFile != null ? "Change Image" : "Pick Image",
                        style: TextStyle(
                          color: AppColors.PRIMARY_COLOR,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showAppDetailDialogBox({String item, String orderId, String image}) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Did you receive your dream item?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    // fontSize: 16,
                    // color: Colors.orange[900],
                    fontWeight: FontWeight.bold)),
            content: Stack(
              children: [
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: '"' + item + '"',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic)),
                      TextSpan(
                          text: ' that you ordered from ',
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      TextSpan(
                          text: 'PLAYPOINTZ',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.orange[900],
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic)),
                      TextSpan(
                          text: ' has been shipped. Are they received?',
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                    ],
                  ),
                ),

                /*  Container(
                  height: 50,
                  width: 50,
                  child: CachedNetworkImage(
                    imageUrl: image,
                    placeholder: (context, url) => Container(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ) */
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  // EasyLoading.show(status: "loading....",dismissOnTap: false);
                  setState(() {
                    loadingdata = true;
                  });
                  await setItemStatus(orderId);
                },
                child: Text(
                  "Yes",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      // color: Colors.orange[900],
                      fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: Text(
                  "Not Yet",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      // color: Colors.orange[900],
                      fontSize: 18),
                ),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    EasyLoading.init();
    getOrders();
    super.initState();
  }

  Future<void> refreshOrders() async {
    setState(() {
      placedItems.clear();
      deliveredItems.clear();
      shipedItems.clear();
      processingItems.clear();
      canceledItem.clear();
    });
    await getOrders();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: DefaultTabController(
        initialIndex: widget.index,
        length: 4,
        child: Scaffold(
          backgroundColor: AppColors.SCREEN_BACKGROUND_COLOR,
          appBar: AppBar(
            leading: widget.fromProfile
                ? BackButton()
                : IconButton(
                    onPressed: () {
                      socket.disconnect();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                    activeIndex: 2,
                                  )),
                          (Route<dynamic> route) => false);
                    },
                    icon: Icon(Icons.arrow_back_ios_new)),
            toolbarHeight: 44,
            backgroundColor: Colors.white,
            bottom: TabBar(
              labelStyle: TextStyle(fontSize: 12),
              labelColor: AppColors.PRIMARY_COLOR,
              unselectedLabelColor: Color(0xff626262),
              tabs: [
                Tab(
                  icon: Icon(
                    BootstrapIcons.box_seam,
                    size: 24,
                  ),
                  text: "Placed",
                ),
                Tab(
                    icon: Icon(
                      BootstrapIcons.truck,
                      size: 24,
                    ),
                    text: "Processing"),
                Tab(
                  icon: Icon(
                    BootstrapIcons.truck_flatbed,
                    size: 24,
                  ),
                  text: "Shipped",
                ),
                Tab(
                  icon: Icon(
                    FontAwesomeIcons.gift,
                    size: 24,
                  ),
                  text: "Completed",
                ),
                /*  Tab(
                  icon: Icon(
                    FontAwesomeIcons.ban,
                    size: 24,
                  ),
                  text: "Cancelled",
                ), */
              ],
            ),
            title: Text('Orders'),
            centerTitle: true,
          ),
          body: loadingdata
              ? Center(
                  child: CupertinoActivityIndicator(),
                )

              //  Text("Recents",
              //               style: TextStyle(
              //                 color: Color(0xff536471),
              //                 fontSize: 20,
              //                 fontWeight: FontWeight.w700,
              //                 fontStyle: FontStyle.normal,
              //               )),
              : TabBarView(
                  children: [
                    RefreshIndicator(
                        onRefresh: () async {
                          await refreshOrders();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Placed items ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.width / 2,
                                  left: 8),
                              child: Divider(
                                thickness: 1,
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                            placedItems.isEmpty
                                ? Expanded(
                                    child: const Center(
                                      child: Text("No items available"),
                                    ),
                                  )
                                : Expanded(
                                    child: ListView.separated(
                                      itemCount: placedItems.length,
                                      padding: EdgeInsets.only(top: 10),
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              const Divider(
                                        height: 3,
                                      ),
                                      itemBuilder: (context, index) =>
                                          OrderItem(
                                        itemPrice: placedItems[index]
                                            .item
                                            .priceInPoints
                                            .toString(),
                                        size: size,
                                        status: "Placed",
                                        color: Colors.lightBlue[100],
                                        color2: Color.fromARGB(255, 4, 69, 248),
                                        itemName:
                                            placedItems[index].item.name ?? "",
                                        imgUrl:
                                            placedItems[index].item.imageUrl ??
                                                "",
                                        onTap: () {},
                                        onPressed: () {},
                                      ),
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Cancelled items ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.width / 2,
                                  left: 8),
                              child: Divider(
                                thickness: 1,
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                            canceledItem.isEmpty
                                ? Expanded(
                                    child: const Center(
                                      child: Text("No items available"),
                                    ),
                                  )
                                : Expanded(
                                    child: ListView.separated(
                                      itemCount: canceledItem.length,
                                      padding: EdgeInsets.only(top: 10),
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              const Divider(
                                        height: 3,
                                      ),
                                      itemBuilder: (context, index) =>
                                          OrderItem(
                                        itemPrice: canceledItem[index]
                                            .item
                                            .priceInPoints
                                            .toString(),
                                        size: size,
                                        status: "Cancelled",
                                        color: Colors.red[200],
                                        color2:
                                            Color.fromARGB(255, 236, 49, 49),
                                        itemName:
                                            canceledItem[index].item.name ?? "",
                                        imgUrl:
                                            canceledItem[index].item.imageUrl ??
                                                "",
                                        onTap: () {},
                                        onPressed: () {},
                                      ),
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Review items ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.width / 2,
                                  left: 8),
                              child: Divider(
                                thickness: 1,
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                            reviewItem.isEmpty
                                ? Expanded(
                                    child: const Center(
                                      child: Text("No items available"),
                                    ),
                                  )
                                : Expanded(
                                    child: ListView.separated(
                                      itemCount: reviewItem.length,
                                      padding: EdgeInsets.only(top: 10),
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              const Divider(
                                        height: 3,
                                      ),
                                      itemBuilder: (context, index) =>
                                          OrderItem(
                                        itemPrice: reviewItem[index]
                                            .item
                                            .priceInPoints
                                            .toString(),
                                        size: size,
                                        status: "In Review",
                                        color: Colors.red[200],
                                        color2:
                                            Color.fromARGB(255, 236, 49, 49),
                                        itemName:
                                            reviewItem[index].item.name ?? "",
                                        imgUrl:
                                            reviewItem[index].item.imageUrl ??
                                                "",
                                        onTap: () {},
                                        onPressed: () {},
                                      ),
                                    ),
                                  ),
                          ],
                        )),
                    RefreshIndicator(
                      onRefresh: () async {
                        await refreshOrders();
                      },
                      child: processingItems.isEmpty
                          ? const Center(
                              child: Text("No items available"),
                            )
                          : ListView.separated(
                              itemCount: processingItems.length,
                              padding: EdgeInsets.only(top: 10),
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(
                                height: 3,
                              ),
                              itemBuilder: (context, index) => OrderItem(
                                itemPrice: processingItems[index]
                                    .item
                                    .priceInPoints
                                    .toString(),
                                size: size,
                                status: "Processing",
                                color: Color.fromARGB(255, 247, 201, 255),
                                color2: Color.fromARGB(255, 106, 0, 124),
                                itemName: processingItems[index].item.name,
                                imgUrl: processingItems[index].item.imageUrl,
                                onTap: () {},
                                onPressed: () {},
                              ),
                            ),
                    ),
                    RefreshIndicator(
                      onRefresh: () async {
                        await refreshOrders();
                      },
                      child: shipedItems.isEmpty
                          ? const Center(
                              child: Text("No items available"),
                            )
                          : ListView.separated(
                              itemCount: shipedItems.length,
                              padding: EdgeInsets.only(top: 10),
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(
                                height: 3,
                              ),
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  /*  // print('shipped');
                                  showAppDetailDialogBox(
                                      item: shipedItems[index].item.name,
                                      orderId: shipedItems[index].id); */
                                },
                                child: OrderItem(
                                  itemPrice: shipedItems[index]
                                      .item
                                      .priceInPoints
                                      .toString(),
                                  size: size,
                                  status: "Shipped",
                                  color: Color.fromARGB(255, 253, 209, 144),
                                  color2: Color.fromRGBO(255, 89, 0, 1),
                                  itemName: shipedItems[index].item.name,
                                  imgUrl: shipedItems[index].item.imageUrl,
                                  onTap: () {
                                    showAppDetailDialogBox(
                                      item: shipedItems[index].item.name,
                                      orderId: shipedItems[index].id,
                                      image: shipedItems[index].item.imageUrl,
                                    );
                                  },
                                  onPressed: () {},
                                ),
                              ),
                            ),
                    ),
                    RefreshIndicator(
                      onRefresh: () async {
                        await refreshOrders();
                      },
                      child: deliveredItems.isEmpty
                          ? const Center(
                              child: Text("No items available"),
                            )
                          : ListView.separated(
                              itemCount: deliveredItems.length,
                              padding: EdgeInsets.only(top: 10),
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(
                                height: 3,
                              ),
                              itemBuilder: (context, index) => OrderItem(
                                itemPrice: deliveredItems[index]
                                    .item
                                    .priceInPoints
                                    .toString(),
                                size: size,
                                status: "Completed",
                                color: Color.fromARGB(255, 121, 245, 127),
                                color2: Color.fromARGB(255, 5, 92, 10),
                                itemName: deliveredItems[index].item.name,
                                imgUrl: deliveredItems[index].item.imageUrl,
                                onTap: () {},
                                onPressed: () {
                                  createPost(context: context);
                                },
                              ),
                            ),
                    ),
                    /* RefreshIndicator(
                      onRefresh: () async {
                        await refreshOrders();
                      },
                      child: canceledItem.isEmpty
                          ? const Center(
                              child: Text("No items available"),
                            )
                          : ListView.separated(
                              itemCount: canceledItem.length,
                              padding: EdgeInsets.only(top: 10),
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(
                                height: 3,
                              ),
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  /*  // print('shipped');
                                  showAppDetailDialogBox(
                                      item: shipedItems[index].item.name,
                                      orderId: shipedItems[index].id); */
                                },
                                child: OrderItem(
                                  itemPrice: canceledItem[index]
                                      .item
                                      .priceInPoints
                                      .toString(),
                                  size: size,
                                  status: "Cancelled",
                                  color: Color.fromARGB(255, 239, 62, 3),
                                  color2: Color.fromRGBO(255, 0, 0, 1),
                                  itemName: canceledItem[index].item.name,
                                  imgUrl: canceledItem[index].item.imageUrl,
                                  onTap: () {
                                    /*   showAppDetailDialogBox(
                                      item: canceledItem[index].item.name,
                                      orderId: canceledItem[index].id,
                                      image: canceledItem[index].item.imageUrl,
                                    ); */
                                  },
                                  onPressed: () {},
                                ),
                              ),
                            ),
                    ), */
                  ],
                ),
        ),
      ),
      // bottomNavigationBar: CommanBottomNavBar(
      //   activeIndex: 4,
      // ),
    );
  }
}
