import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:play_pointz/config.dart';
import 'package:play_pointz/models/getAds.dart';
import 'package:play_pointz/screens/feed/CustomCacheManager.dart';
import 'package:play_pointz/screens/shimmers/shimmer_widget.dart';

import 'package:http/http.dart' as http;
import 'package:play_pointz/store/main%20Store/Play%20Mart/widgets/FinalItemPreview.dart';
import 'package:play_pointz/store/widgets/rounded_button.dart';
import 'package:supercharged/supercharged.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../constants/app_colors.dart';

class PlayMartItemView extends StatefulWidget {
  final String ItemName;
  final String ItemImage;
  final String ItemDescription;
  final String ItemPrice;
  final String link;
  final String RedeamPoint;
  final bool ColorVisible;
  final bool SizeVisible;
  final bool WeightVisible;
  final int index;

  const PlayMartItemView(
      {Key key,
      @required this.ItemName,
      @required this.ItemDescription,
      @required this.ItemImage,
      @required this.ItemPrice,
      @required this.link,
      @required this.RedeamPoint,
      @required this.ColorVisible,
      @required this.SizeVisible,
      @required this.WeightVisible,
      @required this.index})
      : super(key: key);

  @override
  State<PlayMartItemView> createState() => _PlayMartItemViewState();
}

class _PlayMartItemViewState extends State<PlayMartItemView> {
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.width / 1 * 0.85,
              width: MediaQuery.of(context).size.width,
              child: Stack(children: [
                ClipPath(
                  clipper: ItemClipers(),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        colors: [
                          Color.fromARGB(255, 255, 219, 180).withOpacity(0.7),
                          Color.fromARGB(255, 255, 219, 180).withOpacity(0.7),
                        ],
                      ),
                    ),
                    height: MediaQuery.of(context).size.width / 1 * 0.55,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.width / 3 * 0.58),
                  child: Center(
                    child: BounceInDown(
                      duration: Duration(seconds: 2),
                      child: CachedNetworkImage(
                        cacheManager: CustomCacheManager.instance,
                        errorWidget: (context, url, error) {
                          return Image.asset("assets/bg/shoe.png");
                        },
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) {
                          return ShimmerWidget(
                            height: 20.h,
                            width: 20.h,
                            isCircle: true,
                          );
                        },
                        imageUrl: widget.ItemImage,
                        width: 300.h,
                        height: 300.h,
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
                ),
                Positioned(
                  bottom: 20,
                  left: 10,
                  right: 10,
                  child: Text(
                    widget.ItemName,
                    style: TextStyle(
                        fontSize: 30,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Product Detail",
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
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      String url = widget.link;

                      try {
                        // debugPrint("url is $url");
                        Uri uri = Uri.parse(url);
                        if (await canLaunchUrl(
                          uri,
                        )) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          debugPrint("can't launch $url");
                        }
                      } catch (e) {
                        debugPrint("url launch failed $e");
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          "Check Out this link :",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        Text(
                          " Watch Now",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Price",
                    style: TextStyle(
                        decorationThickness: 2.5,
                        fontSize: 20.sp,
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff626262).withOpacity(0.9)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Rs . " + widget.ItemPrice,
                    style: TextStyle(
                        decorationThickness: 2.5,
                        fontSize: 30.sp,
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        elevation: 2,
                        child: Container(
                          height: MediaQuery.of(context).size.width / 12,
                          width: MediaQuery.of(context).size.width / 1.75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xffEBEBEB),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/logos/1.png",
                                height: 25,
                                width: 25,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                " ${widget.RedeamPoint.toDouble()}" +
                                    "  OFF with PTZ",
                                style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff666666)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      " You can pay up to" +
                          " ${widget.RedeamPoint.toDouble()}" +
                          " rupees with your Points",
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff666666)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ImageRoundedButton(
                    buttonColor: Color(0xffFF530D),
                    buttonText: "Next",
                    onPress: () {
                      navigator.push(MaterialPageRoute(
                        builder: (context) => FinalItemPreview(
                          index: widget.index + 1,
                          ItemImage: widget.ItemImage,
                          ItemName: widget.ItemName,
                          ColorVisible: widget.ColorVisible,
                          SizeVisible: widget.SizeVisible,
                          WeightVisible: widget.WeightVisible,
                        ),
                      ));
                    },
                    height: MediaQuery.of(context).size.width / 9,
                    width: MediaQuery.of(context).size.width / 3.25,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
                SizedBox(
                  width: 10,
                )
              ],
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent =
          await createPaymentIntent('10000', 'GBP', 'test fff', 'harshana');

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

  createPaymentIntent(String amount, String currency, String Description,
      String Customer) async {
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
