import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/Api/ApiV2/api_V2.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/controllers/item_label_controller.dart';
import 'package:play_pointz/models/store/upcomming_item_model.dart';
import 'package:play_pointz/screens/Items/item_screen.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/widgets/store/time_btn.dart';
import 'package:shimmer/shimmer.dart';

class OtherItemWidget extends StatefulWidget {
  final UpCommingItem item;
  String current;

  OtherItemWidget({Key key, this.item, this.current}) : super(key: key);

  @override
  State<OtherItemWidget> createState() => _OtherItemWidgetState();
}

class _OtherItemWidgetState extends State<OtherItemWidget> {
  DateTime _now;
  DateTime _auction;
  DateTime _start;
  Timer _timer;
  Duration difference;
  Duration difference2;
  @override
  void initState() {
    setState(() {
      // _now =  DateTime.now();
      _now = DateTime.parse(widget.current) ?? DateTime.now();

      _auction = DateTime.parse(widget.item.endTime);
      _start = DateTime.parse(widget.item.startTime);

      _timer = Timer.periodic(
        Duration(
          seconds: 1,
        ),
        (timer) {
          setState(() {
            // Updates the current date time.
            widget.current = DateTime.parse(widget.current)
                .add(const Duration(seconds: 1))
                .toString();
            _now = DateTime.parse(widget.current) ?? DateTime.now();

            // If the auction has now taken place, then cancels the timer.
            if (_auction.isBefore(_now)) {
              timer.cancel();
              //initState();
            } else if (_start.isAfter(_now)) {
              // timer.cancel();
            }
          });
        },
      );
    });
    print('now' + _now.toString());

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      difference = _auction.difference(_now);
      difference2 = _start.difference(_now);
    });
    //  debugPrint("difference uis $difference");
    return InkWell(
      onTap: () {
        // print(ApiV2().getResentWinners());

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemView(
                      newitemdata: widget.item,
                      current: widget.current,
                    )));
      },
      child: Container(
        height: 300.h,
        width: (MediaQuery.of(context).size.width - 40) / 2,
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        // padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(0xffC4C4C4).withOpacity(0.3),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: 70,
                    decoration: BoxDecoration(
                        color: ItemLabelController().itemLabel(difference,
                            widget.item.itemQuantity, difference2)["color"],
                        borderRadius: BorderRadius.circular(21)),
                    child: Center(
                      child: Text(
                        ItemLabelController().itemLabel(difference,
                            widget.item.itemQuantity, difference2)["lable"],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  ////////////////////////////////////////////////////////////////jjjjjj

                  // Chip(
                  //   label: Text(
                  //     ItemLabelController().itemLabel(difference,
                  //         widget.item.itemQuantity, difference2)["lable"],
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  //   backgroundColor: ItemLabelController().itemLabel(difference,
                  //       widget.item.itemQuantity, difference2)["color"],
                  // ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Center(
                      child: CachedNetworkImage(
                    cacheManager: CustomCacheManager.instance,
                    imageUrl: widget.item.imageUrl,
                    errorWidget: (context, url, error) {
                      // Retry after a delay
                      Future.delayed(Duration(seconds: 5), () {
                        setState(() {
                          // Update the widget or retry the image loading logic
                        });
                      });
                      return Shimmer(
                        child: Container(
                          height:
                              300.h, // Adjust the height based on your design
                          width: (MediaQuery.of(context).size.width - 40) / 2,
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
                        height: 300.h, // Adjust the height based on your design
                        width: (MediaQuery.of(context).size.width - 40) / 2,
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
                    ),
                  )),
                ],
              ),
            ),
            // Expanded(child: Container()),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12)),
                  color: Colors.white),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: Text(
                      widget.item.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff373737),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "PTZ ${widget.item.priceInPoints}",
                            // text: _now.toLocal.toString(),
                            style: TextStyle(
                              color: AppColors.PRIMARY_COLOR_LIGHT,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          /* TextSpan(
                            text:
                                "PTZ ${double.parse(widget.item.priceInPoints) / 100 * 10}",
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 8,
                            ),
                          ), */
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      timeBtnSmall(
                        difference2: difference2,
                        context: context,
                        title: 'DAYS',
                        active: true,
                        countdown: difference2.inSeconds > 0
                            ? difference2.inDays.toString()
                            : difference.inDays.toString(),
                        difference: difference,
                        taken: widget.item.itemQuantity == 0,
                      ),
                      timeBtnSmall(
                        difference2: difference2,
                        context: context,
                        title: 'HRS',
                        active: false,
                        countdown: difference2.inSeconds > 0
                            ? difference2.inHours.remainder(24).toString()
                            : difference.inHours.remainder(24).toString(),
                        difference: difference,
                        taken: widget.item.itemQuantity == 0,
                      ),
                      timeBtnSmall(
                        difference2: difference2,
                        context: context,
                        title: 'MINS',
                        active: false,
                        countdown: difference2.inSeconds > 0
                            ? difference2.inMinutes.remainder(60).toString()
                            : difference.inMinutes.remainder(60).toString(),
                        difference: difference,
                        taken: widget.item.itemQuantity == 0,
                      ),
                      timeBtnSmall(
                        difference2: difference2,
                        context: context,
                        title: 'SEC',
                        active: false,
                        countdown: difference2.inSeconds > 0
                            ? difference2.inSeconds.remainder(60).toString()
                            : difference.inSeconds.remainder(60).toString(),
                        difference: difference,
                        taken: widget.item.itemQuantity == 0,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
