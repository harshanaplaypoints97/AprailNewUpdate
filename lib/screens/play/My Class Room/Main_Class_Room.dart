import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/controllers/coin_balance_controller.dart';
import 'package:play_pointz/controllers/user_controller.dart';
import 'package:play_pointz/screens/play/My%20Class%20Room/Quections_Screen.dart';
import 'package:play_pointz/screens/play/My%20Class%20Room/Techer_Profile_screen.dart';
import 'package:play_pointz/store/widgets/rounded_button.dart';
import 'package:play_pointz/widgets/common/app_bar.dart';
import 'package:screen_protector/screen_protector.dart';

import '../../../config.dart';
import '../../../constants/style.dart';
import '../../feed/CustomCacheManager.dart';
import '../../home/home_page.dart';

class MainClassRoom extends StatefulWidget {
  const MainClassRoom({Key key}) : super(key: key);

  @override
  State<MainClassRoom> createState() => _MainClassRoomState();
}

class _MainClassRoomState extends State<MainClassRoom> {
  bool obsecureCurrent = true;
  TextEditingController subrciptioncode = TextEditingController();
  final List<String> imageUrls = [
    'https://i.ytimg.com/vi/La-S1QVLIBY/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLDLC19p-vDOQlmLTWLLXrq0_0niWg',
    'https://pbs.twimg.com/media/E8RaeJSXsAMeEO2?format=jpg&name=large',
    'https://i.ytimg.com/vi/hRaeNmAt6Og/maxresdefault.jpg'

    // Add more image URLs as needed
  ];
  double calculateHeight(int itemIndex) {
    // Adjust the height based on your requirements
    // For example, you can use a fixed height or calculate dynamically
    return 100.0;
  }

  @override
  void initState() {
    // ScreenProtector.preventScreenshotOn();
    coinBalanceController = Get.put(CoinBalanceController(callback: () {
      debugPrint(
          "+++++++++++++++++++++++++ controller from paly widget called");
      setState(() {});
    }));

    super.initState();
  }

  UserController userController = UserController();
  CoinBalanceController coinBalanceController = CoinBalanceController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: kToolbarHeight * appBarHeightMultiPlier,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            activeIndex: 1,
                          )),
                  (Route<dynamic> route) => false);
              socket.disconnect();
            },
            icon: Icon(Icons.arrow_back_ios)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 26,
                width: 26,
                child: Image(
                  image: AssetImage("assets/logos/z.png"),
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 4),
              Obx(() {
                return Countup(
                  begin: coinBalanceController.previousBalance.value,
                  end: coinBalanceController.coinBalance.value,
                  duration: Duration(milliseconds: 1500),
                  separator: ',',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff52616B),
                  ),
                );
              }),
              SizedBox(width: 38),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: 150,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 1500),
                  autoPlay: true,
                  viewportFraction: 1,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {},
                ),
                itemCount: imageUrls.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  // Get the screen size
                  double screenHeight = MediaQuery.of(context).size.height;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(imageUrls[itemIndex]),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  );
                },
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      "Top Search",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      navigator.push(MaterialPageRoute(
                        builder: (context) => TeacherProfileScreen(),
                      ));
                    },
                    child: ClassTeachersCard(
                      subjectColor: Colors.amber,
                      TeacherName: "Charitha Dissanayake",
                      Subject: "Chemistry",
                      ImageUrl:
                          'https://scontent.fcmb1-2.fna.fbcdn.net/v/t39.30808-6/348816311_560905109299437_6657479826419006948_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=5f2048&_nc_ohc=goy2pucDUCcAX9MNP9j&_nc_ht=scontent.fcmb1-2.fna&oh=00_AfDrPBPkPfiB430f9FMqOwb1H3K6v4DMk-wYj9PRD6Hb2Q&oe=6607F6C8',
                    ),
                  ),
                  ClassTeachersCard(
                    subjectColor: Colors.green,
                    TeacherName: "Dushyantha Mahabaduge",
                    Subject: "Co.Maths",
                    ImageUrl:
                        'https://www.syzygy.lk/img/teachers/dushyantha.jpg',
                  ),
                  ClassTeachersCard(
                    subjectColor: Colors.red,
                    TeacherName: " Samitha Rathnayake",
                    Subject: "Physics",
                    ImageUrl: 'https://www.syzygy.lk/img/teachers/samitha.jpg',
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Subscriptions",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text(
                              "WellCome To Subcription Plan ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 15),
                            ),
                            actions: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextFormField(
                                    style: TextStyle(fontSize: 12),
                                    obscureText: obsecureCurrent,
                                    maxLength: 30,
                                    buildCounter: (BuildContext context,
                                            {int currentLength,
                                            int maxLength,
                                            bool isFocused}) =>
                                        null,
                                    decoration: InputDecoration(
                                      fillColor:
                                          AppColors.scaffoldBackGroundColor,
                                      filled: true,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      labelStyle: AppStyles.lableText,
                                      hintText: 'Enter Code',
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              obsecureCurrent =
                                                  !obsecureCurrent;
                                            });
                                          },
                                          icon: FaIcon(
                                            obsecureCurrent
                                                ? FontAwesomeIcons.eyeSlash
                                                : FontAwesomeIcons.eye,
                                            size: 18,
                                          )),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    ),
                                    controller: subrciptioncode,
                                    textInputAction: TextInputAction.done,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return ("Current Password can't be empty");
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        RoundedButton(
                                            buttonText: "Login",
                                            buttonColor: Colors.green,
                                            onPress: () {
                                              navigator.push(MaterialPageRoute(
                                                builder: (context) =>
                                                    QuectionScreen(),
                                              ));
                                            },
                                            height: 40,
                                            width: 100,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        RoundedButton(
                                            buttonText: "Register",
                                            buttonColor: Colors.green,
                                            onPress: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (context) => AlertDialog(
                                                            title: Text(
                                                              "WellCome To Subcription Plan ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontSize: 15),
                                                            ),
                                                            actions: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "LKR 300.00",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w800,
                                                                        fontSize:
                                                                            30),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Center(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        RoundedButton(
                                                                            buttonText:
                                                                                "Buy Now",
                                                                            buttonColor: Colors
                                                                                .green,
                                                                            onPress:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            height:
                                                                                40,
                                                                            width:
                                                                                100,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: 12),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ));
                                            },
                                            height: 40,
                                            width: 100,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              )
                            ],
                          ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage('assets/bg/11.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  height: 120,
                  width: double.infinity,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/bg/22.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                height: 110,
                width: double.infinity,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/bg/11.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                height: 120,
                width: double.infinity,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClassTeachersCard extends StatelessWidget {
  String TeacherName;
  String ImageUrl;
  String Subject;
  Color subjectColor;
  ClassTeachersCard(
      {Key key,
      @required this.TeacherName,
      @required this.subjectColor,
      @required this.ImageUrl,
      @required this.Subject})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Column(
        children: [
          CachedNetworkImage(
            cacheManager: CustomCacheManager.instance,
            imageUrl: ImageUrl,
            imageBuilder: (context, imageProvider) => Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors
                      .red, // Change this color to your desired border color
                  width: 4, // Change this value to your desired border width
                ),
              ),
              child: ClipOval(
                child: Stack(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey,
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
              ),
            ),
            errorWidget: (context, url, error) => Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors
                      .red, // Change this color to your desired border color
                  width: 2, // Change this value to your desired border width
                ),
              ),
              child: ClipOval(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage("assets/dp/error-placeholder.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              TeacherName,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 5,
            height: MediaQuery.of(context).size.width / 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: subjectColor,
            ),
            child: Center(
              child: Text(
                Subject,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
