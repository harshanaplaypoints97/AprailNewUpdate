import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/controllers/item_label_controller.dart';
import 'package:play_pointz/models/store/upcomming_item_model.dart';
import 'package:play_pointz/screens/Items/item_screen.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/widgets/store/time_btn.dart';

import '../../../constants/app_colors.dart';

class ActiveItem extends StatefulWidget {
  final UpCommingItem activeItem;
  const ActiveItem({Key key, this.activeItem}) : super(key: key);

  @override
  State<ActiveItem> createState() => _ActiveItemState();
}

class _ActiveItemState extends State<ActiveItem> {
  DateTime _now;
  DateTime _auction;
  Timer _timer;
  DateTime _start;
  Duration difference2;
  Duration difference;
  String currentTime;

  bool checkActiveStatus() {
    DateTime startTime = DateTime.parse(widget.activeItem.startTime)
        .add(Duration(hours: 5, minutes: 30));
    DateTime endTime = DateTime.parse(widget.activeItem.endTime)
        .add(Duration(hours: 5, minutes: 30));
    DateTime nowTime = DateTime.now();

    if (nowTime.isAfter(startTime) && nowTime.isBefore(endTime)) return true;

    return false;
  }

  @override
  void initState() {
    // getCurrentTime();
    setState(() {
      // Sets the current date time.
      _now = DateTime.parse(widget.activeItem.serverTime);

      // Sets the date time of the auction.
      _auction = DateTime.parse(widget.activeItem.endTime);
      _start = DateTime.parse(widget.activeItem.startTime);

      // Creates a timer that fires every second.
      _timer = Timer.periodic(
        Duration(
          seconds: 1,
        ),
        (timer) {
          setState(() {
            // Updates the current date time.
            // _now = DateTime.now();
            widget.activeItem.serverTime =
                DateTime.parse(widget.activeItem.serverTime)
                    .add(const Duration(seconds: 1))
                    .toString();
            _now = DateTime.parse(widget.activeItem.serverTime);

            // If the auction has now taken place, then cancels the timer.
            if (_auction.isBefore(_now)) {
              timer.cancel();
              // initState();
            } else if (_start.isAfter(_now)) {
              // timer.cancel();
            }
          });
        },
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      difference = _auction.difference(_now);
      difference2 = _start.difference(_now);
      print(difference + difference2);
    });

    return Container(
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height / 1.5,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 2 / 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Chip(
                            label: Text(
                              ItemLabelController().itemLabel(
                                  difference,
                                  widget.activeItem.itemQuantity,
                                  difference2)["lable"],
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            // backgroundColor: Colors.green,
                            backgroundColor: ItemLabelController().itemLabel(
                                difference,
                                widget.activeItem.itemQuantity,
                                difference2)["color"],
                          ),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: CachedNetworkImage(
                          cacheManager: CustomCacheManager.instance,
                          imageUrl: widget.activeItem.imageUrl ??
                              '$baseUrl/assets/images/no_cover.png',
                          imageBuilder: (context, imageProvider) => Stack(
                            children: <Widget>[
                              Image(
                                image: imageProvider,
                                width:
                                    MediaQuery.of(context).size.width * 2 / 5,
                              ),
                              Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(200, 0, 0, 0),
                                        Color.fromARGB(0, 0, 0, 0)
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                // color: Colors.blueAccent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      widget.activeItem.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text("PTZ ${widget.activeItem.priceInPoints.toString()}",
                        style: TextStyle(
                          color: AppColors.PRIMARY_COLOR_LIGHT,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius:
                              BorderRadius.all(const Radius.circular(10.0))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text(difference.inDays.toString()),
                            Flexible(
                              child: timeBtnActive(
                                  context: context,
                                  difference2: difference2,
                                  difference: difference,
                                  taken: widget.activeItem.stockAmount == 0,
                                  title: 'DAYS',
                                  active: true,
                                  countdown: difference.inDays.toString()),
                            ),
                            Flexible(
                              child: timeBtnActive(
                                  context: context,
                                  difference2: difference2,
                                  difference: difference,
                                  taken: widget.activeItem.stockAmount == 0,
                                  title: 'HRS',
                                  active: false,
                                  countdown: difference.inHours
                                      .remainder(24)
                                      .toString()),
                            ),
                            Flexible(
                              child: timeBtnActive(
                                  context: context,
                                  difference2: difference2,
                                  difference: difference,
                                  taken: widget.activeItem.stockAmount == 0,
                                  title: 'MINS',
                                  active: false,
                                  countdown: difference.inMinutes
                                      .remainder(60)
                                      .toString()),
                            ),
                            Flexible(
                              child: timeBtnActive(
                                  context: context,
                                  difference2: difference2,
                                  difference: difference,
                                  taken: widget.activeItem.stockAmount == 0,
                                  title: 'SEC',
                                  active: false,
                                  countdown: difference.inSeconds
                                      .remainder(60)
                                      .toString()),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    MaterialButton(
                      onPressed: () {
                        // _showChoiceDialog(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ItemView(
                                      newitemdata: widget.activeItem,
                                      current: widget.activeItem.serverTime,
                                    )));
                      },
                      elevation: 0,
                      minWidth: double.infinity,
                      // height: kToolbarHeight,
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        "Redeem Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
