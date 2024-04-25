import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/screens/Chat/Provider/Chat_provider.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/friends_controller.dart';
import '../../../feed/CustomCacheManager.dart';

class UserCard extends StatefulWidget {
  UserCard({
    Key key,
    @required this.UserId,
    @required this.Myid,
    @required this.profileData,
    @required this.UserImage,
    @required this.UserName,
    @required this.index,
    @required this.MyProfileImage,
    @required this.MyProfileName,
  }) : super(key: key);

  var profileData;
  var UserName;
  var UserImage;
  var UserId;
  var Myid;
  var index;

  var MyProfileImage;
  var MyProfileName;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  int pressValue = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(FriendsController());
  }

  final friendsController = Get.put(FriendsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            color: AppColors.scaffoldBackGroundColor,
            height: 3,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        CachedNetworkImage(
                          cacheManager: CustomCacheManager.instance,
                          imageUrl: widget.UserImage ??
                              '$baseUrl/assets/images/no_profile.png',
                          imageBuilder: (context, imageProvider) => Stack(
                            children: [
                              Container(
                                height: 52,
                                width: 52,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  border: Border.all(
                                    color: Color(0xFFF2F3F5),
                                    width: 1,
                                  ),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider ??
                                        AssetImage(
                                            "assets/dp/blank-profile-picture-png.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              border: Border.all(
                                color: Color(0xFFF2F3F5),
                                width: 1,
                              ),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/dp/error-placeholder.png"), // Replace with your error placeholder image
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        // Positioned(
                        //     bottom: 3,
                        //     right: 0,
                        //     child: ClipOval(
                        //       child: Icon(
                        //         Icons.circle,
                        //         size: 12,
                        //         color: Color(0xff2BEF83),
                        //       ),
                        //     ))
                      ],
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.UserName.length > 20
                                  ? '${widget.UserName.substring(0, 13)}...' // Display only first 13 characters with ellipsis
                                  : widget.UserName + '  ',
                              style: TextStyle(
                                color: Color(0xFF303030),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Let's Chat",
                          style: TextStyle(
                            color: Color(0xFF797C7B),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Consumer<ChatProvider>(
                  builder: (context, value, child) => Container(
                    height: MediaQuery.of(context).size.width / 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color(0xffFF721C),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(8), // Remove default padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          pressValue++;
                        });
                        if (pressValue == 1) {
                          value.statrCreateConvercation(
                            
                            context,
                            widget.Myid,
                            widget.UserId,
                            widget.index,
                            widget.UserImage,
                            widget.UserName,
                            widget.MyProfileImage,
                            widget.MyProfileName,
                            ""
                          );
                        }
                        setState(() async {
                          await Future.delayed(Duration(seconds: 1));
                          pressValue = 0;
                        });
                      },
                      child: value.loadingindex == widget.index
                          ? CircularPercentIndicator()
                          : Text(
                              "Chat",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                )
              ],
            ),
          ),
          // Container(
          //   color: Colors.grey.withOpacity(0.2),
          //   height: 1,
          //   width: MediaQuery.of(context).size.width,
          // )
        ],
      ),
    );
  }
}
