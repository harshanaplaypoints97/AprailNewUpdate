import 'dart:convert';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/models/getAds.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/shimmers/shimmer_widget.dart';

import 'package:http/http.dart' as http;
import 'package:play_pointz/store/widgets/rounded_button.dart';
import 'package:play_pointz/widgets/common/notification_button.dart';
import 'package:play_pointz/widgets/common/toast.dart';

import '../../../../../constants/app_colors.dart';
import '../../../../constants/default_router.dart';
import '../../../../controllers/coin_balance_controller.dart';
import '../../../../screens/profile/profile.dart';
import '../../../../widgets/profile/profile_name.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:play_pointz/Animations/celebration_popup_ani.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/Shared%20Pref/player_pref.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/models/purchase_item.dart';
import 'package:play_pointz/models/store/upcomming_item_model.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/home/home_page.dart';
import 'package:play_pointz/screens/register/delivery_terms.dart';
import 'package:play_pointz/store/widgets/animated_hurry_text.dart';

import 'package:play_pointz/widgets/common/toast.dart';
import 'package:play_pointz/widgets/login/text_form_field.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ConformItemPage extends StatefulWidget {
  final String size;
  final String Quantity;
  final String Color;
  final String ActualPrice;
  final String RedeamPoint;
  const ConformItemPage(
      {Key key,
      @required this.ActualPrice,
      @required this.Color,
      @required this.Quantity,
      @required this.RedeamPoint,
      @required this.size})
      : super(key: key);

  @override
  State<ConformItemPage> createState() => _ConformItemPageState();
}

class _ConformItemPageState extends State<ConformItemPage> {
  CoinBalanceController coinBalanceController;
  @override
  void initState() {
    setState(() {
      coinBalanceController = Get.put(CoinBalanceController(callback: () {
        setState(() {});
      }));
    });
    // TODO: implement initState
    super.initState();
  }

  double itemprice = 11200.00;
  int selectsize = 0;
  int selectcolor = 0;
  double unselectedborder = 1;
  double selectedborder = 3;
  Map<String, dynamic> paymentIntent;
  int ItemCount = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xff536471), // Set your desired icon color here
        ),
        elevation: 0,
        title: Text(
          "Play Mart",
          style: TextStyle(color: Color(0xff536471)),
        ),
        centerTitle: true,
        leading: BackButton(),
        backgroundColor: AppColors.scaffoldBackGroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "      Order\nConfirmation",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff444444)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Material(
                borderRadius: BorderRadius.circular(40),
                elevation: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.85,
                  child: Column(
                    children: [
                      ProfileDetails(),
                      Text(
                        "Product Details",
                        style: TextStyle(
                            fontSize: 17,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff444444)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElementOfDetails(
                        title: " Size          :",
                        value: widget.size,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElementOfDetails(
                        title: "Quantity :",
                        value: widget.Quantity,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ColorElementOfDetails(
                        title: "  Color       :",
                        value: widget.Color,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElementOfDetails(
                        title: "  Actual price          :",
                        value: widget.ActualPrice,
                      ),
                      ElementOfDetails(
                        title: "With PTZ Coins   :",
                        value: widget.RedeamPoint,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundedButton(
                    buttonText: "Buy Now",
                    buttonColor: Color(0xff38B000),
                    onPress: () {
                      makePayment();
                    },
                    height: MediaQuery.of(context).size.width / 9,
                    width: MediaQuery.of(context).size.width / 2.80,
                    fontWeight: FontWeight.w500,
                    fontSize: 15)
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent(10, 'LKR', 'test fff');

      // var gpay = PaymentSheetGooglePay(
      //     merchantCountryCode: "GB", currencyCode: "GBP", testEnv: true);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret:
                paymentIntent['client_secret'], //Gotten from payment intent
            style: ThemeMode.light,
            merchantDisplayName: 'Abhi',
          ))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        print("Payment Successfully");
      });
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(
    int amount,
    String currency,
    String Description,
  ) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        "description": Description,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51Ju7zoBZuuCKdwArPVHdyv8aXk5N4Uwab4rUqG0XC1EGZJu7fKrmPWEK5rgdPsFKnub7Pl0SaUznyOXN0bv0sYTU009QWJhCcd',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}

class ElementOfDetails extends StatelessWidget {
  final String title;
  final String value;
  const ElementOfDetails({
    Key key,
    @required this.title,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 17,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
              color: Color(0xff444444)),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          value,
          style: TextStyle(
              fontSize: 17,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
              color: Color(0xff444444)),
        ),
      ],
    );
  }
}

class ColorElementOfDetails extends StatelessWidget {
  final String title;
  final String value;
  const ColorElementOfDetails({
    Key key,
    @required this.title,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 17,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
              color: Color(0xff444444)),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Color(int.parse('0xFF' + value)),
          ),
          height: 25,
          width: 25,
        )
      ],
    );
  }
}

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: GestureDetector(
        onTap: () {
          // DefaultRouter.defaultRouter(ProfileNew(), context);
          DefaultRouter.defaultRouter(
            Profile(
              myProfile: true,
            ),
            context,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          height: 90,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Profile Image
                // ProfileImage(profileData: profileData),
                ClipOval(
                  child: CachedNetworkImage(
                    cacheManager: CustomCacheManager.instance,
                    imageUrl: userController.currentUser.value.profileImage,
                    width: 50.w,
                    height: 50.w,
                    fit: BoxFit.fill,
                    fadeInDuration: const Duration(milliseconds: 600),
                    fadeOutDuration: const Duration(milliseconds: 600),
                    errorWidget: (a, b, c) {
                      return CachedNetworkImage(
                        cacheManager: CustomCacheManager.instance,
                        imageUrl:
                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                      );
                    },
                  ),
                ),

                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    profileName(
                        name: userController.currentUser.value.fullName ?? ""),
                    userController.currentUser.value.username == null
                        ? Container()
                        : userLocation(
                            name:
                                "@${userController.currentUser.value.username}")
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SizeTexeWidgect extends StatelessWidget {
  final Color textcolor;
  final String text;
  const SizeTexeWidgect({
    @required this.textcolor,
    @required this.text,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Color(0xffD9D9D9),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textcolor),
        ),
      ),
    );
  }
}

class ColorButton extends StatelessWidget {
  final Color color;
  final double bordersize;
  const ColorButton({Key key, @required this.color, @required this.bordersize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 10,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: bordersize),
              color: color,
              borderRadius: BorderRadius.circular(50)),
          height: 30,
          width: 30,
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }
}

class ItemClipers extends CustomClipper<Path> {
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
