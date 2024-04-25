import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/profile/profile.dart';

import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:social_share/social_share.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../constants/app_colors.dart';
import '../../../../Shared Pref/player_pref.dart';
import '../../../../constants/style.dart';
import '../../../../models/markertPlace/MarkertPlace_Profile_Item.dart';
import '../../../../screens/Chat/Provider/Chat_provider.dart';
import '../../../../widgets/profile/profile_name.dart';

class MarkertPlaceItemView extends StatefulWidget {
  final List<MarketplaceMedia> imageList;
  final String PlayerImage;
  final String Playername;
  final String playerid;
  final String ItemName;
  final String ItemImage;
  final String ItemDescription;
  final String ItemPrice;

  final int index;

  const MarkertPlaceItemView(
      {Key key,
      @required this.PlayerImage,
      @required this.Playername,
      @required this.imageList,
      @required this.playerid,
      @required this.ItemName,
      @required this.ItemDescription,
      @required this.ItemImage,
      @required this.ItemPrice,
      @required this.index})
      : super(key: key);

  @override
  State<MarkertPlaceItemView> createState() => _MarkertPlaceItemViewState();
}

class _MarkertPlaceItemViewState extends State<MarkertPlaceItemView> {
  bool isWhatsappProcessing = false;
  bool itisprocessing = false;
  bool loadingdata = false;
  String refarrallink = "";
  var data;
  getRefarralLink() async {
    setState(() {
      loadingdata = true;
    });
    data = await getPlayerPref(key: "playerProfileDetails");

    setState(() {
      refarrallink = "$baseUrl/invite/${data['invite_token']}";

      loadingdata = false;
    });
  }

  int _current = 0;
  final CarouselController _controller = CarouselController();

  UserController userController = Get.put(UserController());
  TextEditingController chatcontroller = TextEditingController();
  Map<String, dynamic> paymentIntent;
  int ItemCount = 1;

  @override
  void initState() {
    setState(() {
      chatcontroller.text = "Hello is this available?";
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xff536471), // Set your desired icon color here
        ),
        elevation: 0,
        title: Text(
          "MakertPlace Item View",
          style: TextStyle(color: Color(0xff536471)),
        ),
        centerTitle: true,
        backgroundColor: AppColors.scaffoldBackGroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 16 / 20,
                      viewportFraction: 1.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                    items: widget.imageList.map((MarketplaceMedia media) {
                      return Builder(
                        builder: (BuildContext context) {
                          if (media.imageUrl != null) {
                            return CachedNetworkImage(
                              cacheManager: CustomCacheManager.instance,
                              errorWidget: (context, url, error) {
                                return Center(
                                    child: CircularProgressIndicator());
                              },
                              imageUrl: media.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return null; // Return null when imageUrl is null
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buidindicator(widget.imageList.length),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.ItemName,
                    style: TextStyle(
                        fontSize: 30,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  Text(
                    "LKR " +
                        NumberFormat('###,000')
                            .format(int.parse(widget.ItemPrice)),
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  userController.currentUser.value.id.toString() ==
                          widget.playerid.toString()
                      ? Container()
                      : Consumer<ChatProvider>(
                          builder: (context, value, child) => TextButton(
                            style: TextButton.styleFrom(
                              padding:
                                  EdgeInsets.all(8), // Remove default padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            onPressed: () {
                              // print(userController.currentUser.value.id.toString());

                              // print(widget.playerid.toString());

                              value.statrCreateConvercation(
                                context,
                                userController.currentUser.value.id,
                                widget.playerid,
                                0,
                                widget.PlayerImage,
                                widget.Playername,
                                userController.currentUser.value.profileImage,
                                userController.currentUser.value.fullName,
                                chatcontroller.text + widget.ItemName,
                              );
                            },
                            child: value.loadingindex == 1
                                ? CircularPercentIndicator()
                                : Container(
                                    height:
                                        MediaQuery.of(context).size.width / 4,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Color.fromARGB(255, 217, 217,
                                            217), // Replace with your desired border color
                                        width:
                                            1.0, // Replace with your desired border width
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.chat,
                                                size: 20,
                                                color: AppColors.PRIMARY_COLOR,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Send seller a message",
                                                style: TextStyle(
                                                    decorationThickness: 2.5,
                                                    fontSize: 15.sp,
                                                    letterSpacing: 0.6,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  11,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child: TextFormField(
                                                style: TextStyle(fontSize: 12),
                                                maxLength: 30,
                                                buildCounter:
                                                    (BuildContext context,
                                                            {int currentLength,
                                                            int maxLength,
                                                            bool isFocused}) =>
                                                        null,
                                                decoration: InputDecoration(
                                                  fillColor: Color.fromARGB(
                                                      255, 221, 212, 212),
                                                  filled: true,
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                  labelStyle:
                                                      AppStyles.lableText,
                                                  hintText: 'Type Your Text',
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          15, 0, 15, 0),
                                                ),
                                                controller: chatcontroller,
                                                textInputAction:
                                                    TextInputAction.done,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return ("Type your Message");
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  11,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color:
                                                      AppColors.PRIMARY_COLOR),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  'assets/bg/send.png',
                                                  height: 15,
                                                  width: 15,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                  ////////////////////////////////////////////////////share bellow ////////////////////////////////////////////////////
                  ///
                  ///
                  userController.currentUser.value.id.toString() ==
                          widget.playerid.toString()
                      ? Container(
                          height: 10,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                getRefarralLink();
                                setState(() {
                                  itisprocessing = true;
                                });

                                // Introduce a delay (e.g., 2 seconds)
                                await Future.delayed(Duration(seconds: 2));

                                final downloadlink =
                                    'https://play.google.com/store/apps/details?id=com.avanux.playpointz&hl=en&gl=US';
                                await Share.share(widget.ItemName +
                                    '\n\n' +
                                    widget.ItemDescription +
                                    '\n\n' +
                                    widget.imageList[0].imageUrl +
                                    '\n\n' +
                                    'Download Link => $refarrallink');

                                setState(() {
                                  // Reset the flag to indicate that the process is completed
                                  itisprocessing = false;
                                });
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Your regular GestureDetector child goes here
                                  itisprocessing
                                      ? Center(
                                          child: Container(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              )),
                                        )
                                      : Icon(
                                          FontAwesomeIcons.share,
                                          color: AppColors.normalTextColor
                                              .withOpacity(0.8),
                                          size: 19,
                                        ),

                                  // Show circular progress indicator when isProcessing is true
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),

                            //Whatsapp
                            GestureDetector(
                              onTap: () async {
                                getRefarralLink();
                                setState(() {
                                  isWhatsappProcessing = true;
                                });
                                final downloadlink =
                                    'https://play.google.com/store/apps/details?id=com.avanux.playpointz&hl=en&gl=US';

                                await Future.delayed(Duration(seconds: 2));

                                await SocialShare.shareWhatsapp(
                                    widget.ItemDescription +
                                        '\n\n' +
                                        widget.imageList[0].imageUrl +
                                        '\n\n' +
                                        'Download Link => $refarrallink');

                                setState(() {
                                  isWhatsappProcessing = false;
                                });
                              },
                              child: isWhatsappProcessing
                                  ? Center(
                                      child: Container(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          )),
                                    )
                                  : Icon(
                                      FontAwesomeIcons.whatsapp,
                                      color: AppColors.normalTextColor
                                          .withOpacity(0.8),
                                      size: 20,
                                    ),
                            )
                          ],
                        ),

                  ////////////////////////////////////////////////////////////////////////////////////////////////////share upeer
                  Text(
                    "Discription",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.ItemDescription,
                    style: TextStyle(
                      color: Color(0xff626262).withOpacity(0.9),
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  userController.currentUser.value.id.toString() ==
                          widget.playerid.toString()
                      ? Container()
                      : Divider(),
                  userController.currentUser.value.id.toString() ==
                          widget.playerid.toString()
                      ? Container()
                      : Text(
                          "Seller information",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                          ),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  userController.currentUser.value.id.toString() ==
                          widget.playerid.toString()
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: GestureDetector(
                            onTap: () {
                              // DefaultRouter.defaultRouter(ProfileNew(), context);
                              DefaultRouter.defaultRouter(
                                Profile(
                                  id: widget.playerid,
                                  myProfile: false,
                                ),
                                context,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(
                                  color: Color.fromARGB(
                                      255, 217, 217, 217), // Border color
                                  width: 1.0, // Border width
                                ),
                              ),
                              height: 90,
                              width: double.infinity,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    //Profile Image
                                    // ProfileImage(profileData: profileData),
                                    ClipOval(
                                      child: CachedNetworkImage(
                                        cacheManager:
                                            CustomCacheManager.instance,
                                        imageUrl: widget.PlayerImage,
                                        width: 50.w,
                                        height: 50.w,
                                        fit: BoxFit.fill,
                                        fadeInDuration:
                                            const Duration(milliseconds: 600),
                                        fadeOutDuration:
                                            const Duration(milliseconds: 600),
                                        errorWidget: (a, b, c) {
                                          return CachedNetworkImage(
                                            cacheManager:
                                                CustomCacheManager.instance,
                                            imageUrl: widget.PlayerImage,
                                          );
                                        },
                                      ),
                                    ),

                                    SizedBox(
                                      width: 20,
                                    ),

                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        profileName(
                                          name: widget.Playername.length > 10
                                              ? widget.Playername.substring(
                                                  0, 10)
                                              : widget.Playername,
                                        )
                                      ],
                                    ),
                                    Spacer(),
                                    Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.grey, // Border color
                                            width: 1.0, // Border width
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "view",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }

  Widget buidindicator(int len) => Center(
        child: AnimatedSmoothIndicator(
          activeIndex: _current,
          count: len,
          effect: WormEffect(
              dotHeight: 10,
              dotWidth: 10,
              activeDotColor: AppColors.PRIMARY_COLOR,
              dotColor: Color(0xff626262).withOpacity(0.9)),
        ),
      );
}
