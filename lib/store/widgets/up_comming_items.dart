import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import '../../../config.dart';

import '../../../controllers/upcomming_items_controller.dart';
import '../../../models/store/upcomming_item_model.dart';
import '../../../widgets/store/time_btn.dart';

class upCommingItem extends StatefulWidget {
  ItemController itemController;
  UpCommingItem item;
  String current;
  upCommingItem(this.itemController, this.item, this.current, {Key key})
      : super(key: key);

  @override
  State<upCommingItem> createState() => _upCommingItemState();
}

class _upCommingItemState extends State<upCommingItem> {
  DateTime _now;
  DateTime _auction;
  Timer _timer;
  DateTime _start;
  Duration difference2;
  String currentTime;

  bool checkActiveStatus() {
    DateTime startTime = DateTime.parse(widget.item.startTime)
        .add(Duration(hours: 5, minutes: 30));
    DateTime endTime = DateTime.parse(widget.item.endTime)
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
      _now = DateTime.parse(widget.current) ?? DateTime.now();
      // _now = DateTime.now();

      // Sets the date time of the auction.
      _auction = DateTime.parse(widget.item.endTime);
      _start = DateTime.parse(widget.item.startTime);

      // Creates a timer that fires every second.
      _timer = Timer.periodic(
        Duration(
          seconds: 1,
        ),
        (timer) {
          setState(() {
            // Updates the current date time.
            // _now = DateTime.now();
            widget.current = DateTime.parse(widget.current)
                .add(const Duration(seconds: 1))
                .toString();
            _now = DateTime.parse(widget.current) ?? DateTime.now();

            // If the auction has now taken place, then cancels the timer.
            if (_auction.isBefore(_now)) {
              timer.cancel();
              // initState();
            }
          });
        },
      );
    });
    super.initState();
  }

  getCurrentTime() async {
    var result = await Api().getCurrentTime();
    if (result.done) {
      setState(() {
        _now = DateTime.parse(result.body.currentTime);
      });
    } else {
      setState(() {
        _now = DateTime.now();
      });
    }
    // print(currentTime);
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    difference2 = _start.difference(_now);
    return Stack(
      children: [
        Center(
          child: Image.asset("assets/new/waiting.png"),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: CachedNetworkImage(
              cacheManager: CustomCacheManager.instance,
              imageUrl:
                  widget.item.imageUrl ?? '$baseUrl/assets/images/no_cover.png',
              imageBuilder: (context, imageProvider) => Stack(
                children: <Widget>[
                  Image(
                    image: imageProvider,
                    width: MediaQuery.of(context).size.width,
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
                            offset: Offset(0, 3), // changes position of shadow
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
        ),
        Center(
          child: Image.asset("assets/new/waiting_gray.png"),
        ),
        Positioned(
          bottom: 5,
          left: 30,
          right: 30,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 80.h,
              //  color: Colors.white70,
              width: MediaQuery.of(context).size.width,

              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: timeBtnMedium(
                          context: context,
                          title: 'DAYS',
                          active: false,
                          countdown: difference2.inDays.toString()),
                    ),
                    Flexible(
                      child: timeBtnMedium(
                          context: context,
                          title: 'HRS',
                          active: false,
                          countdown:
                              difference2.inHours.remainder(24).toString()),
                    ),
                    Flexible(
                      child: timeBtnMedium(
                          context: context,
                          title: 'MINS',
                          active: false,
                          countdown:
                              difference2.inMinutes.remainder(60).toString()),
                    ),
                    Flexible(
                      child: timeBtnMedium(
                          context: context,
                          title: 'SEC',
                          active: false,
                          countdown:
                              difference2.inSeconds.remainder(60).toString()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
            top: 20,
            left: 40,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                child: Row(
                  children: [
                    SizedBox(
                        width: 26,
                        height: 26,
                        child: Image.asset("assets/logos/z.png")),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      widget.item.priceInPoints + "  PTZ",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ))
      ],
    );
  }
}
