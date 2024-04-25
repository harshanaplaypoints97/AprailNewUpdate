import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';

class ResentWinnersCard extends StatefulWidget {
  final String profileImgUrl;
  final String userName;
  final String itemUrl;
  final String itemName;

  const ResentWinnersCard(
      this.profileImgUrl, this.userName, this.itemUrl, this.itemName,
      {Key key})
      : super(key: key);

  @override
  State<ResentWinnersCard> createState() => _ResentWinnersCardState();
}

class _ResentWinnersCardState extends State<ResentWinnersCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 30,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              // height: size.height * 0.23,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(40),
                image: DecorationImage(
                    image: AssetImage("assets/new/card1.png"),
                    fit: BoxFit.fitWidth),
              ),
            ),
          ),
        ),
        SizedBox(
          // height: size.width * 0.3,
          width: size.width * 0.45,
          child: CachedNetworkImage(
            cacheManager: CustomCacheManager.instance,
            imageUrl: widget.itemUrl,
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
          top: 0,
          right: size.width * 0.05,
          left: size.width * 0.45,
          bottom: 30,
          //right: MediaQuery.of(context).size.width * 0.00,
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.09,
                  backgroundColor: Color(0xfffe7f2b),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: MediaQuery.of(context).size.width * 0.083,
                    backgroundImage: NetworkImage(
                      widget.profileImgUrl ??
                          "https://st3.depositphotos.com/4111759/13425/v/600/depositphotos_134255710-stock-illustration-avatar-vector-male-profile-gray.jpg",
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                SizedBox(
                  width: size.width * 0.45,
                  child: FittedBox(
                    child: Text(
                      "Congratulations!",
                      style: TextStyle(
                          fontFamily: "Arial",
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 24.sp),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  widget.userName.split(" ").elementAt(0),
                  style: TextStyle(
                      fontFamily: "Arial",
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You Won",
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Arial",
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 6.sp,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 8.sp, right: 8.sp, top: 4.sp, bottom: 4.sp),
                        child: Column(
                          children: [
                            Container(
                              width: size.width * 0.3,
                              child: Text(
                                widget.itemName ?? "Purchase Item",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: "Arial",
                                  fontSize: 14.sp,
                                  color: Color(0xfffe7f2b),
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
