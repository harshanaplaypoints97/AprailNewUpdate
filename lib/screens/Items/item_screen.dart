import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:math';

import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/controllers/coin_balance_controller.dart';
import 'package:play_pointz/controllers/feed_controller.dart';
import 'package:play_pointz/models/store/upcomming_item_model.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/register/delivery_terms.dart';

import 'package:play_pointz/widgets/common/toast.dart';
import 'package:play_pointz/widgets/store/time_btn.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Api/ApiV2/api_V2.dart';
import '../../constants/default_router.dart';
import '../../models/NewModelsV2/store/resent_winners.dart';
import '../../store/place_order.dart';
import '../shimmers/shimmer_widget.dart';

class ItemView extends StatefulWidget {
  final UpCommingItem newitemdata;
  String current;

  ItemView({Key key, this.newitemdata, this.current}) : super(key: key);

  @override
  State<ItemView> createState() => _ItemViewState(newitemdata);
}

class _ItemViewState extends State<ItemView> {
  bool _isChecked = false;
  bool expanded = false;
  final controller = ConfettiController();
  // NewArrivals newitemdata;
  DateTime _now;
  DateTime _auction;
  DateTime _start;
  Timer _timer;
  final coinBalanceController = Get.put(CoinBalanceController());
  _ItemViewState(newitemdata);
  @override
  void initState() {
    super.initState();
    controller.play();

    _now = DateTime.parse(widget.current) ?? DateTime.now();

    _auction = DateTime.parse(widget.newitemdata.endTime);
    _start = DateTime.parse(widget.newitemdata.startTime);

    _timer = Timer.periodic(
      Duration(
        seconds: 1,
      ),
      (timer) {
        setState(() {
          widget.current = DateTime.parse(widget.current)
              .add(const Duration(seconds: 1))
              .toString();
          _now = DateTime.parse(widget.current) ?? DateTime.now();

          if (_auction.isBefore(_now)) {
            timer.cancel();
          }
        });
      },
    );
    print(widget.newitemdata.endTime);
  }

  String title(int index) {
    switch (index) {
      case 0:
        return "DYS";
      case 1:
        return "HRS";
      case 2:
        return "MIN";
      case 3:
        return "SEC";
      default:
        return "";
    }
  }

  bool shouldActive() {
    if (widget.newitemdata.itemQuantity == 0) {
      return false;
    }

    if (DateTime.parse(widget.newitemdata.endTime).isBefore(DateTime.now())) {
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Duration difference = _auction.difference(_now);
    Duration difference2 = _now.difference(_start);
    Duration difference3 = _start.difference(_now);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.scaffoldBackGroundColor,
        automaticallyImplyLeading: false, // Hide the back icon
      ),
      backgroundColor: AppColors.scaffoldBackGroundColor,
      floatingActionButton: !shouldActive()
          ? null
          : difference2.isNegative
              ? Container()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  color: AppColors.scaffoldBackGroundColor,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 16, top: 8, left: 10, right: 10),
                    child: FloatingActionButton.extended(
                      elevation: 0,
                      backgroundColor: Color(0xff02A41C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      onPressed: coinBalanceController.coinBalance.value >=
                              double.parse(widget.newitemdata.priceInPoints)
                          ? () {
                              if (_isChecked) {
                                debugPrint(
                                    "coin balance is ${coinBalanceController.coinBalance.value} item price ${widget.newitemdata.priceInPoints}");
                                Get.off(() =>
                                    PlaceOrder(itemdata: widget.newitemdata));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'please Agree with Delevery Method'),
                                  ),
                                );
                              }
                            }
                          : () {
                              Get.snackbar(
                                  "Hey ${userController.currentUser.value.username}",
                                  "Not enough Pointz. Play more, Earn more.");
                            },
                      label: Container(
                        width: MediaQuery.of(context).size.width / 1.25,
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        alignment: Alignment.center,
                        child: Text(
                          "Redeem Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            letterSpacing: 0.6,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          primary: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 0),
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2 * 0.8,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16)),
                        // gradient: LinearGradient(
                        //   begin: Alignment.topCenter,
                        //   end: Alignment.bottomCenter,
                        //   colors: [
                        //     Colors.white,
                        //     Colors.white,
                        //     AppColors.WHITE,
                        //     Colors.white,
                        //   ],
                        // ),
                      ),
                    ),

                    Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        child: ClipPath(
                          clipper: ItemCliper(),
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                colors: [
                                  Color.fromARGB(255, 255, 219, 180)
                                      .withOpacity(0.7),
                                  Color.fromARGB(255, 255, 219, 180)
                                      .withOpacity(0.7),
                                ],
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: difference.isNegative
                                                ? Colors.red
                                                : difference2.isNegative
                                                    ? Colors.orange
                                                    : Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        height: 30,
                                        width: difference.isNegative ? 80 : 70,
                                        child: Center(
                                          child: Text(
                                            (difference.isNegative)
                                                ? " Taken "
                                                : (difference2.isNegative)
                                                    ? "Waiting"
                                                    : "Active",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                    difference.isNegative
                                        ? FutureBuilder<ResentWinners>(
                                            future: ApiV2().getResentWinners(),
                                            builder: (context,
                                                AsyncSnapshot<ResentWinners>
                                                    snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.data.body.orders
                                                      .isNotEmpty) {}
//Winneer Image
                                              return ConfettiWidget(
                                                blastDirection: -pi / 2,
                                                confettiController: controller,
                                                shouldLoop: true,
                                                child: ClipOval(
                                                  child: Container(
                                                    color: Color.fromARGB(
                                                            255, 255, 219, 180)
                                                        .withOpacity(0.7),
                                                    height: 50,
                                                    width: 50,
                                                  ),
                                                ),
                                              );
                                            })
                                        : Container(),

                                    //  Showing Delever Method ===========================================================================================================================================

                                    // Container(
                                    //   decoration: BoxDecoration(
                                    //       color: Colors.orange,
                                    //       borderRadius: BorderRadius.only(
                                    //           bottomLeft: Radius.circular(20),
                                    //           bottomRight:
                                    //               Radius.circular(20))),
                                    //   child: Center(
                                    //     child: Padding(
                                    //       padding: const EdgeInsets.all(8.0),
                                    //       child: Center(
                                    //         child: Text(
                                    //           "Delivery Method\n     " +
                                    //               widget.newitemdata
                                    //                   .delivery_option,
                                    //           style: TextStyle(
                                    //               color: Colors.white,
                                    //               fontSize: 14,
                                    //               fontWeight: FontWeight.w400),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                // Column(
                                //   children: [
                                //     difference.isNegative
                                //         ? FutureBuilder<ResentWinners>(
                                //             future: ApiV2().getResentWinners(),
                                //             builder: (context,
                                //                 AsyncSnapshot<ResentWinners>
                                //                     snapshot) {
                                //               if (snapshot.hasData &&
                                //                   snapshot.data.body.orders
                                //                       .isNotEmpty) {
                                //                 return Text(snapshot
                                //                     .data
                                //                     .body
                                //                     .orders[int.parse(
                                //                         widget.newitemdata.id)]
                                //                     .player
                                //                     .fullName);
                                //               }
                                //             })
                                //         : Container()

                                //     // widget.newitemdata.id
                                //   ],
                                // )
                              ],
                            ),
                          ),
                        )),
                    Positioned(
                      child: BounceInDown(
                        duration: Duration(seconds: 2),
                        child: CachedNetworkImage(
                          cacheManager: CustomCacheManager.instance,
                          errorWidget: (context, url, error) {
                            return Image.network(
                                "https://static.thenounproject.com/png/1100147-200.png");
                          },
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) {
                            return ShimmerWidget(
                              height: 70.h,
                              width: 70.h,
                              isCircle: false,
                            );
                          },
                          imageUrl: widget.newitemdata.imageUrl ??
                              "$baseUrl/assets/images/no_cover.png",
                          width: 260.h,
                          height: 260.h,
                          imageBuilder: (context, imageProvider) => Container(
                            padding: EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Image(
                                  image: imageProvider ??
                                      "$baseUrl/assets/images/no_profile.png",
                                  fit: BoxFit.contain),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(
                                  0xffFF530D), // Replace with your first color
                              Color(0xffFF960C),
                              Colors.yellow // Replace with your second color
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            (widget.newitemdata.itemQuantity == 0) ||
                                    (difference.isNegative)
                                ? "You Missed It"
                                : (difference2.isNegative)
                                    ? "You Have To Wait"
                                    : "Active Until",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ),
                    ),

                    //       height: 200.h,
                  ],
                ),
              ),
              Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        (widget.newitemdata.itemQuantity == 0) ||
                                (difference.isNegative)
                            ? "Times Up"
                            : (difference2.isNegative)
                                ? "Waiting Until"
                                : "Active Until",
                        style: TextStyle(
                          color: Color.fromARGB(255, 99, 98, 98),
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      widget.newitemdata.itemQuantity == 0 ||
                              (difference.isNegative)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(
                                4,
                                (index) => Column(
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 8,
                                      height:
                                          MediaQuery.of(context).size.width / 8,
                                      alignment: Alignment.center,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              const Radius.circular(5.0))),
                                      child: FittedBox(
                                        child: Text(
                                          "00",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      child: Text(title(index),
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          )),
                                    )
                                  ],
                                ),
                              ).toList(),
                            )
                          : difference2.isNegative
                              ? Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      timeBtn(
                                          context: context,
                                          title: 'DAYS',
                                          active: false,
                                          countdown:
                                              difference3.inDays.toString()),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 25),
                                        child: Text(
                                          ":",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amber[600]),
                                        ),
                                      ),
                                      timeBtn(
                                          context: context,
                                          title: 'HRS',
                                          active: false,
                                          countdown: difference3.inHours
                                              .remainder(24)
                                              .toString()),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 25),
                                        child: Text(
                                          ":",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amber[600]),
                                        ),
                                      ),
                                      timeBtn(
                                          context: context,
                                          title: 'MINS',
                                          active: false,
                                          countdown: difference3.inMinutes
                                              .remainder(60)
                                              .toString()),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 25),
                                        child: Text(
                                          ":",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amber[600]),
                                        ),
                                      ),
                                      timeBtn(
                                          context: context,
                                          title: 'SEC',
                                          active: false,
                                          countdown: difference3.inSeconds
                                              .remainder(60)
                                              .toString()),
                                    ],
                                  ),
                                )
                              : Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      timeBtn(
                                          context: context,
                                          title: 'DAYS',
                                          active: true,
                                          countdown:
                                              difference.inDays.toString()),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 25),
                                        child: Text(
                                          ":",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff02A41C)),
                                        ),
                                      ),
                                      timeBtn(
                                          context: context,
                                          title: 'HRS',
                                          active: true,
                                          countdown: difference.inHours
                                              .remainder(24)
                                              .toString()),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 25),
                                        child: Text(
                                          ":",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff02A41C)),
                                        ),
                                      ),
                                      timeBtn(
                                          context: context,
                                          title: 'MINS',
                                          active: true,
                                          countdown: difference.inMinutes
                                              .remainder(60)
                                              .toString()),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 25),
                                        child: Text(
                                          ":",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff02A41C)),
                                        ),
                                      ),
                                      timeBtn(
                                          context: context,
                                          title: 'SEC',
                                          active: true,
                                          countdown: difference.inSeconds
                                              .remainder(60)
                                              .toString()),
                                    ],
                                  ),
                                ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    //   height: MediaQuery.of(context).size.height / 4,
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldBackGroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/logos/1.png",
                                height: 25,
                                width: 25,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "PTZ ${widget.newitemdata.priceInPoints}",
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    letterSpacing: 0.6,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xffFF721C)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),

                        //Delevery Method Adding Part

                        widget.newitemdata.delivery_option.isEmpty
                            ? Container()
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Divider(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        widget.newitemdata.delivery_option
                                                    .toString() ==
                                                "in-store"
                                            ? expanded = true
                                            : expanded = false;
                                      });
                                    },
                                    child: Container(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Color.fromARGB(
                                                255, 231, 230, 230)),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // +

                                                Row(
                                                  children: [
                                                    Icon(
                                                      widget.newitemdata
                                                                  .delivery_option
                                                                  .toString() ==
                                                              "in-store"
                                                          ? BootstrapIcons.shop
                                                          : widget.newitemdata
                                                                      .delivery_option
                                                                      .toString() ==
                                                                  "delivery"
                                                              ? BootstrapIcons
                                                                  .truck
                                                              : BootstrapIcons
                                                                  .globe,
                                                      size: widget.newitemdata
                                                                  .delivery_option
                                                                  .toString() ==
                                                              "online"
                                                          ? 28
                                                          : 30,
                                                      color: Color(0xff4e4e4e),
                                                    ),
                                                    Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              "Delivery Method    ",
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xffFF721C),
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              widget.newitemdata
                                                                          .delivery_option
                                                                          .toString() ==
                                                                      "delivery"
                                                                  ? "Home Delivery"
                                                                  : widget.newitemdata
                                                                              .delivery_option
                                                                              .toString() ==
                                                                          "in-store"
                                                                      ? "Self Pickup"
                                                                      : widget
                                                                          .newitemdata
                                                                          .delivery_option
                                                                          .toString(),
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xff4e4e4e),
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                              width: 1,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              child: Container(
                                                                height: 15,
                                                                width: 15,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .green,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50)),
                                                                child: Icon(
                                                                  Icons.check,
                                                                  size: 15,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),

                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Checkbox(
                                                      value: _isChecked,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          _isChecked == true
                                                              ? _isChecked =
                                                                  false
                                                              : _isChecked =
                                                                  true;
                                                        });
                                                      },
                                                    ),
                                                    Text(
                                                      "Agree With Delivery Method",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff4e4e4e),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),

                                                _isChecked
                                                    ? Text(
                                                        widget.newitemdata
                                                                    .delivery_option
                                                                    .toString() ==
                                                                "in-store"
                                                            ? "No.50,Nikape Road ,Dehiwala,Sri Lanka\nOpen -10.00 AM -4.00 PM\nMonday To Friday"
                                                            : widget.newitemdata
                                                                        .delivery_option
                                                                        .toString() ==
                                                                    "delivery"
                                                                ? "Home Delivery\nAddress & Tel. Must Be Correct"
                                                                : "Online\nAddress & Tel. Must Be Correct",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff4e4e4e),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      )
                                                    : Container(),

                                                SizedBox(
                                                  height: 10,
                                                ),
                                                _isChecked
                                                    ? Container(
                                                        child: RichText(
                                                          textAlign:
                                                              TextAlign.center,
                                                          text: TextSpan(
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                            children: [
                                                              TextSpan(
                                                                  text:
                                                                      ' Upon clicking \'Place Order\',I confirm I have read and acknowledged all  ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal)),
                                                              TextSpan(
                                                                  text:
                                                                      ' Delivery terms and Conditions.',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .blue),
                                                                  recognizer:
                                                                      TapGestureRecognizer()
                                                                        ..onTap =
                                                                            () {
                                                                          DefaultRouter.defaultRouter(
                                                                              DeliveryTermsConditions(),
                                                                              context);
                                                                        }),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Text(
                            widget.newitemdata.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                                color: Color(0xff373737)),
                          ),
                        ),
                        Html(
                          data: widget.newitemdata.description,
                          onLinkTap: (url, context, attributes, element) async {
                            if (await canLaunch(url)) {
                              await launch(
                                url,
                              );
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          style: {
                            "body": Style(
                              fontWeight: FontWeight.w400,
                              color: Color(0xff536471),
                              // Change the text color to black
                              fontSize: FontSize(15.0),
                            ),
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ItemCliper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.0042857);
    path_0.lineTo(size.width * 0.0008333, size.height * 0.5700000);
    path_0.quadraticBezierTo(size.width * 0.3741667, size.height * 0.7778571,
        size.width * 0.4991667, size.height * 0.7785714);
    path_0.quadraticBezierTo(size.width * 0.6239583, size.height * 0.7785714,
        size.width, size.height * 0.5728571);
    path_0.lineTo(size.width * 0.9991667, size.height * -0.0028571);
    path_0.close();

    return path_0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
