import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';

class OrderItem extends StatelessWidget {
  final String itemPrice;
  final Size size;
  final String status;
  final Color color;
  final Color color2;
  final String itemName;
  final String imgUrl;
  final Function onTap;
  final Function onPressed;
  const OrderItem({
    Key key,
    this.size,
    this.status,
    this.color,
    this.color2,
    this.itemName,
    this.imgUrl,
    this.itemPrice,
    this.onTap,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 1),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: 15,
                              top: 10,
                              bottom: 10,
                              right: 5,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            height: size.height * 0.08,
                            width: size.height * 0.08,
                            child: CachedNetworkImage(
                              cacheManager: CustomCacheManager.instance,
                              imageUrl: imgUrl,
                              placeholder: (context, url) => Container(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Container(
                            width: size.width - 225,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: size.width * 0.5,
                                  child: Text(
                                    itemName,
                                    maxLines: 2,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 14.sp,
                                      width: 14.sp,
                                      child: Image(
                                          image:
                                              AssetImage("assets/logos/z.png")),
                                    ),
                                    SizedBox(
                                      child: Text(
                                        "$itemPrice" " PTZ",
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      status != "Completed" &&
                              status != "Cancelled" &&
                              status != "In Review"
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 5),
                              child: Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.info_outline,
                                            size: 14,
                                            color: Colors.orange[900],
                                          ),
                                        ),
                                        TextSpan(
                                            text:
                                                " Delivery will take 1-14 days.",
                                            style: TextStyle(
                                                color: Colors.orange[900])),
                                      ],
                                    ),
                                  ),
                                  // Spacer(),
                                  // Text('data')
                                ],
                              ),
                            )
                          : status == "In Review"
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, bottom: 5),
                                  child: Row(
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.info_outline,
                                                size: 14,
                                                color: Colors.orange[900],
                                              ),
                                            ),
                                            TextSpan(
                                                text:
                                                    " Due to the our terms & conditions,\n     we have requesting id for verification ",
                                                style: TextStyle(
                                                    color: Colors.orange[900])),
                                          ],
                                        ),
                                      ),
                                      // Spacer(),
                                      // Text('data')
                                    ],
                                  ),
                                )
                              : status == "Cancelled"
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15, bottom: 5),
                                      child: Row(
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  child: Icon(
                                                    Icons.info_outline,
                                                    size: 14,
                                                    color: Colors.orange[900],
                                                  ),
                                                ),
                                                TextSpan(
                                                    text:
                                                        " Due to the our terms & conditions,\n     we have cancelled your item",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .orange[900])),
                                              ],
                                            ),
                                          ),
                                          // Spacer(),
                                          // Text('data')
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      height: 0,
                                    )
                    ],
                  ),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: onTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                color,
                                color2,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(5, 5),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              status == 'Shipped' ? 'Received' : status,
                              style: TextStyle(
                                color: Colors.white,
                                // fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (status == 'Shipped')
                        Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: 95,
                            child: Text('Confirm when your gift received.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 10)))
                    ],
                  ),
                  SizedBox(width: 10)
                ],
              ),
            ),
          ),
          status == 'Completed'
              ? Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: size.width - 175,
                            child: Text(
                              'Share your experience with friends.',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.orange[900]),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        MaterialButton(
                          onPressed: onPressed,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.app_shortcut_outlined,
                                      size: 14,
                                      color: Colors.blue[400],
                                    ),
                                  ),
                                  TextSpan(
                                      text: " Create Post",
                                      style:
                                          TextStyle(color: Colors.orange[900])),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
